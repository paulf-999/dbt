{{ config(schema='production') }}

SELECT *
FROM {{ source('bike_production', 'stocks') }}
