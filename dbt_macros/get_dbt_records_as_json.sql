{%-
/*
    Description:
    This macro transforms all records from a dbt model into a (Snowflake-queryable) JSON object. It achieves this by performing the following steps:

    1. **Fetch dbt relation: ** Verify that the dbt relation exists within the dbt graph context.
    2. **Fetch columns names:** Retrieve column names of the specified dbt model using the `get_dbt_model_columns` macro.
    3. **Fetch total row count:** Determine the total number of rows in the specified dbt model using the `run_query_fetch_row_count` macro.
    4. **Construct JSON records:** Loop through each row, fetch data using `run_query_fetch_row_from_offset`, convert the row to a JSON format using `convert_row_to_json`, and append it to the `json_records` list.
    5. **Final JSON String Construction:** Create a final parsed JSON string using the `construct_parse_json_query_str` macro, ready to be used for downstream processing.

    Parameters:
    - dbt_model: The name of the DBT model to retrieve dbt test failures from.

    Usage: {{ get_dbt_records_as_json(model) }}

    Returns:
    A SQL-queryable JSON object called `failed_records`. E.g.:

    `PARSE_JSON(<table records as JSON>) AS failed_records`
*/
-%}

{% macro get_dbt_records_as_json(dbt_model) %}

    {%- if execute -%}
        {#- /* JSON records will be used to store each of the dbt model records. */ -#}
        {#- /* This in turn will be the main input to generate the key var, 'parse_json_query_str'. */ -#}
        {%- set json_records = [] -%}

        {#- /* 1. Fetch dbt relation and handle errors */ -#}
        {%- set dbt_model_ref = get_and_verify_dbt_relation(dbt_model|string) -%}

        {#- /* 2. Fetch columns names */ -#}
        {%- set dbt_model_columns_names = get_dbt_model_columns(dbt_model_ref) -%}

        {#- /* 3. Fetch total row count */ -#}
        {%- set dbt_model_rows = run_query_fetch_row_count(dbt_model_ref) -%}

        {#- /* 4. Loop through EACH of the rows and construct a JSON record */ -#}
        {% for row in range(dbt_model_rows|int) -%}

            {#- /* 4a. SQL query to fetch a single row based on the SQL offset query */ -#}
            {%- set dbt_model_row = run_query_fetch_row_from_offset(dbt_model, row) -%}
            {#- /* 4b. convert the row to json */ -#}
            {% set json_record = convert_row_to_json(dbt_model_columns_names, dbt_model_row, json_records) %}

        {% endfor %}

        {#- /* 5. Construct final JSON string */ -#}
        {%- set parse_json_query_str = construct_parse_json_str(json_records) -%}

        {#- /* 6. Return the JSON record */ -#}
        {{ return(parse_json_query_str) }}

    {%- endif -%}

{% endmacro %}

{#- /* ####################################################################################### */ -#}
{#- /* # Listed below are 'child' macros (functions) used by the parent macro                  */ -#}
{#- /* ####################################################################################### */ -#}

{#- /* Fetch & verify dbt relation object exists. */ -#}
{#- /* See https://docs.getdbt.com/reference/dbt-jinja-functions/adapter#get_relation */ -#}
{% macro get_and_verify_dbt_relation(dbt_model) %}

    {%- set dbt_model_ref = adapter.get_relation(
        database=dbt_model.split('.')[0],
        schema=dbt_model.split('.')[1],
        identifier=dbt_model.split('.')[2]) -%}

    {#- /* {{ print("INFO: dbt relation = " ~ dbt_model_ref ~ "\n") }} */ -#}

    {#- /* Verify that the dbt relation exists within dbt's graph context */ -#}
    {% set relation_exists = load_relation(dbt_model_ref) is not none %}
    {% if relation_exists %}
        {{ print("INFO: dbt model '" ~ dbt_model_ref ~ "' exists.") }}
    {% else %}
        {{ print("INFO: dbt model '" ~ dbt_model_ref ~ "' doesn't exist in the warehouse. Maybe it was dropped?") }}
    {% endif %}

    {{ return(dbt_model_ref) }}

{% endmacro %}

{#- /* Get all columns names for the specified dbt model */ -#}
{% macro get_dbt_model_columns(dbt_model_ref) %}

    {#- /* fetch the dbt model column names */ -#}
    {%- set initial_column_names = adapter.get_columns_in_relation(dbt_model_ref) -%}
    {%- set dbt_model_columns_names = initial_column_names | map(attribute='column') | list -%}
    {#- /* {{ print("\nINFO: dbt model column names:") }} */ -#}
    {#- /* {% for column_name in dbt_model_columns_names -%} */ -#}
        {#- /* {{ print("column_name = " ~ column_name)}} */ -#}
    {#- /* {% endfor %} */ -#}

    {{ return(dbt_model_columns_names) }}

{% endmacro %}

{#- /* Fetch total row count */ -#}
{% macro run_query_fetch_row_count(dbt_model_ref) %}

    {#- /* Get the table row count */ -#}
    {%- set model_row_count = run_query("SELECT COUNT(*) FROM " ~ dbt_model_ref) -%}

    {#- /* if the model row count isn't empty */ -#}
    {% if execute and model_row_count.rows|length > 0 and model_row_count.rows[0][0] > 0 -%}

        {#- /* fetch table row count */ -#}
        {%- set total_rows = model_row_count.rows[0][0]|int -%}
        {{ print("INFO: Row count = " ~ total_rows) }}

    {#- /* Table is empty, return message */ -#}
    {%- else -%}
        {{ print("No records found in the table.") }}
        {{ return("'' AS failed_records") }}
    {%- endif -%} {#- /* close 'if model_row_count.rows|length > ... ' */ -#}

    {{ return(total_rows) }}

{% endmacro %}

{#- /* SQL query to fetch a single row based on the SQL offset query */ -#}
{% macro run_query_fetch_row_from_offset(dbt_model_ref, row) %}

    {#- /* Construct the SQL query */ -#}
    {% set sql_query_get_row = "SELECT * FROM " ~ dbt_model_ref ~ " LIMIT 1 " ~ "OFFSET " ~ row -%}
    {#- /* {{ print("DEBUG: Query: " ~ sql_query_get_row) }} */ -#}

    {#- /* Fetch the row using the query and print its values */ -#}
    {% set dbt_model_row = run_query(sql_query_get_row)[0] -%}
    {#- /* {{ print("\nDEBUG: Row: " ~ dbt_model_row.values()) }} */ -#}

    {{ return(dbt_model_row) }}

{% endmacro %}

{#- /* Parent macro call child macros to create  */ -#}
{% macro convert_row_to_json(dbt_model_columns_names, dbt_model_row, json_records) %}
    {%- set json_record = {} -%}

    {%- for column_name, column_value in zip(dbt_model_columns_names, dbt_model_row) -%}
        {#- /* {{ print("DEBUG: Column Name: " ~ column_name ~ ", Column Value: " ~ column_value) }} */ -#}

        {#- /* Construct the JSON key-value pair strings and add to json_record dictionary */ -#}
        {%- set _ = json_record.update({column_name: column_value|string if column_value is not none else 'None'}) -%}

    {% endfor %}

    {#- /* Convert the dictionary to a JSON string */ -#}
    {% set json_record_json = json_record | tojson %}

    {#- /* Replace single quotes with double quotes in the JSON record */ -#}
    {% set json_record_json = json_record_json | replace("'", '"') %}

    {#- /* Append the modified JSON record to json_records list */ -#}
    {%- set _ = json_records.append(json_record_json) -%}

    {#- /* Return the JSON record */ -#}
    {{ return(json_record_json) }}

{% endmacro %}

{#- /* Construct the final parsed JSON string with PARSE_JSON function */ -#}
{% macro construct_parse_json_str(json_records) %}

    {#- /* Construct the value 'PARSE_JSON(<value>) AS failed_records' */ -#}
    {% set parse_json_query_str = 'PARSE_JSON(' ~ "'[" ~ json_records | join(", ") ~ "]'" ~ ')' -%}
    {{ print("\nFinal Parsed JSON: \n" ~ parse_json_query_str ~ "\n") }}

    {{ return(parse_json_query_str) }}

{% endmacro %}