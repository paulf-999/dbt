{% macro get_dbt_run_result_metadata(model, resource_type) %}

    {#- /* Iterate through the dbt test results & write the output to stdout */ #}
    {%- for node in graph.nodes.values()
        | selectattr("resource_type", "equalto", resource_type) -%}
        {{ log("\n" ~ node, info=true) }}
    {%- endfor -%}

{% endmacro %}