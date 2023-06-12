{{ config(schema='sales') }}

SELECT *
FROM {{ source('bike_sales', 'staffs') }}
