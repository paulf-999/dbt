{% macro dynamic_ref(source_name, table_name) %}

    {% if 'dev-child-project' in target.name %}

        {{ return(builtins.source(source_name, table_name)) }}

    {% else %}

        {{ return(ref(source_name, table_name)) }}

    {% endif %}

{% endmacro %}
