{#- /*
This macro collects all columns and their values from a specified dbt model.
It does this using the functions 'adapter.get_columns_in_relation function' & 'dbt_utils.get_column_values'
*/ -#}
{% macro get_dbt_model_column_values(dbt_model) %}
    {#- /* Get all columns of the source table using the dbt adapter.get_columns_in_relation function. */-#}
    {% set all_columns = adapter.get_columns_in_relation(ref(dbt_model)) %}

    {#- /* Initialize an empty list to store column names and their corresponding values. */ -#}
    {% set column_values = [] %}

    {% for col in all_columns %}
        {#- /* Get the values of the current column using dbt_utils.get_column_values function. */-#}
        {% set col_value = dbt_utils.get_column_values(table=ref(dbt_model), column=col.name) %}

        {#- /*Create a dictionary containing the column name and its values. */ -#}
        {% set column_info = {"name": col.name, "values": col_value} %}

        {#- /* Add the column info dictionary to the column_values list. */-#}
        {% do column_values.append(column_info) %}
    {% endfor %}

    {#- /* Log the column_values list to the dbt logs for inspection. */-#}
    {% do log(column_values, info=true) %}
{% endmacro %}