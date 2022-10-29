{% macro dynamic_ref(source_name, table_name, package_name, ref_tbl) %}

    {% if 'dev-child-project' in target.name %}

        {{ return(builtins.source(source_name, table_name)) }}

    {% else %}

        {{ return(ref(package_name, table_name)) }}

    {% endif %}

{% endmacro %}
