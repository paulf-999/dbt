{#-
/*
    **Description**
        - This macro searches the [dbt graph context variable](https://docs.getdbt.com/reference/dbt-jinja-functions/graph) for dbt test results for the tag `dq_test`.
        - If the tag is found, it sets the `dq_checks_flag` variable to 'T'. If not, `dq_checks_flag` is set to 'F'.
        - For more details on the dbt `graph context variable`, see [about graph context variable | getdbtdocs.com](https://docs.getdbt.com/reference/dbt-jinja-functions/graph).

    **Example usage**: `{% set dq_checks_flag = get_dq_checks_flag(model) %}`

    **Inputs**: `model`: The dbt model to check for 'dq_checks' tag.

    **Outputs**:
        - `dq_checks_flag` = 'T' (if `dq_checks` tag is found),
        - or `dq_checks_flag` = 'F' (if `dq_checks` tag is not found).
*/
-#}

{% macro get_dq_checks_flag(model) %}

    {%- set vars = {'dq_checks_flag': ''} -%}

    {#- /* search the dbt graph context var for dbt test results with a tag containing the value 'dq_test' */ -#}
    {% for node in graph.nodes.values()
        | selectattr("resource_type", "equalto", "test")
        | selectattr("config.tags", "defined") %}

        {#- /* if the tag 'dq_checks' is found, set 'dq_checks_flag' to 'T' */ -#}
        {% if 'dq_checks' in node.config.tags %}
            {%- set vars = vars.update({'dq_checks_flag': 'T'}) -%}
            {{ log("INFO: 'dq_checks' tag found! Set 'dq_checks_flag' var to true.", info = true) }}
            {#- /* {{ log("DEBUG: node.config.tags = " ~ node.config.tags, info = true) }} */ -#}
        {% endif %}
    {% endfor %}


    {#- /* else if the tag 'dq_checks' is NOT found, set 'dq_checks_flag' to 'F' */ -#}
    {% if vars.dq_checks_flag == '' %}
        {%- set vars = vars.update({'dq_checks_flag': 'F'}) -%}
        {{ log("INFO: dq_checks tag not found, set 'dq_checks_flag' var to false ('F').", info = true) }}
    {% endif %}

    {{ return(vars.dq_checks_flag) }}

{% endmacro %}