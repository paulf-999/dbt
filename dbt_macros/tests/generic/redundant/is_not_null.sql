{% test not_null(model, column_name) %}

{#-
    -- A test for determining if a given field within a given model contains null values
-#}

SELECT {{ column_name }} AS field
FROM {{ model }}
WHERE {{ column_name }} IS NOTT

{% endtest %}
