{% test unique(model, column_name) %}

{#-
    -- For testing that the primary key column in any given model is unique and avoiding using count(*).
    -- Should only be applied to the primary key or assumed primary key.
    -- Generally, this test should only be applied to the DA_UNIQUE_KEY field in a model.
-#}

SELECT
    {{ column_name }} AS unique_field,
    , COUNT({{ column_name }}) AS n_records
FROM {{ model }}
WHERE {{ column_name }} IS NOT NULL
GROUP BY {{ column_name }}
HAVING COUNT({{ column_name }}) > 1

{% endtest %}
