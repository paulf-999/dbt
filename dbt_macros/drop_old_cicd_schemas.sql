{#- /*
    Description:
        - Finds CICD PR schemas older than a set date and drops them
        - Defaults to looking for PR schemas older than 10 days old
        - But can be configured with the input argument `age_in_days`

    Usage: dbt run-operation drop_old_cicd_schemas --args "{'database_name': 'CICD'}"

    Example usage with different date:
        dbt run-operation drop_old_cicd_schemas --args "{'database_name': 'CICD','age_in_days':'15'}"

    Influenced by: https://docs.getdbt.com/guides/custom-cicd-pipelines?step=3
*/ -#}

{% macro drop_old_cicd_schemas(database_name, age_in_days=10) %}

    {{ log("Macro called: drop_old_cicd_schemas()", info=True)}}

    {#- /* Generate SQL code to identify CICD PR schemas older than the specified age. */ #}
    {%- set find_old_schemas = identify_old_cicd_schemas(database_name) -%}

    {#- /* 'if execute' tells dbt to only run this code at execution time (i.e., not during compilation) */ -#}
    {% if execute %}

        {#- /* Generate the 'DROP SCHEMA' statements, if any. */ #}
        {%- set schema_drop_list = run_query(find_old_schemas).columns[0].values() -%}

        {#- /* Check whether any CICD PR schemas (to be dropped) have been identified. */ #}
        {% if schema_drop_list %}

            {#- /* Execute each of the 'DROPS SCHEMA' queries stored within the list 'schema_to_drop'. */ #}
            {{ log("Executing the following SQL drop statements:", True) }}
            {% for schema_to_drop in schema_drop_list %}
                {% do run_query(schema_to_drop) %}
                {{ log(schema_to_drop, True) }}
            {% endfor %}

        {#- /* Else produce a message saying, "No old CICD PR schemas to drop" */ #}
        {% else %}
            {{ log("No old CICD PR schemas to drop.", True) }}
        {% endif %} {#- /* close 'if schema_drop_list' */ #}

    {% endif %} {#- /* close 'if execute' */ #}

{% endmacro %}

{% macro identify_old_cicd_schemas(database_name, age_in_days=10) %}

    {#- /* Define the schema name prefix pattern for CICD PR schemas. */ #}
    {% set cicd_pr_schema_prefix = '_CICD_PR_%' %}

    {#- /* Generate SQL code to identify CICD PR schemas older than the specified age. */ #}
    {% set find_old_schemas %}
        SELECT 'DROP SCHEMA IF EXISTS {{ database_name | upper }}.' || schema_name || ';' AS drop_schema_sql_stmt
        FROM {{ database_name }}.information_schema.schemata
        WHERE
            catalog_name = '{{ database_name | upper }}'
            AND schema_name ILIKE '{{ cicd_pr_schema_prefix }}'
            AND last_altered <= (CURRENT_DATE() - INTERVAL '{{ age_in_days }} days')
    {% endset -%}

    {{ return(find_old_schemas) }}

{% endmacro %}
