-- Description: Validates the existence of certain columns in a table within the raw database.
-- Args:
-- * schema (string): name of the raw schema
-- * table_list (list): list of tables referenced
-- * column_list: list of columns referenced

{% macro raw_column_existence(schema, table, column_list) %}

WITH source as (
    SELECT *
    FROM "{{ env_var('SNOWFLAKE_LOAD_DATABASE') }}".information_schema.columns
)
, counts AS (
    SELECT COUNT(1) as row_count
    FROM source
    WHERE LOWER(table_schema) = '{{schema|lower}}'
        AND LOWER(table_name) = '{{table|lower}}'
        AND LOWER(column_name) in (
            {%- for column in column_list -%}
                '{{column|lower}}'{% if not loop.last %},{%- endif -%}
            {%- endfor -%}
        )
)

SELECT row_count
FROM counts
WHERE row_count < array_size(array_construct(
        {%- for column in column_list -%}
            '{{column|lower}}'{% if not loop.last %},{%- endif -%}
        {%- endfor -%}
    )
)

{% endmacro %}
