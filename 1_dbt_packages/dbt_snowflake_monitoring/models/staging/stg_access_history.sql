{{ config(materialized='incremental') }}

SELECT
    query_id
    , query_start_time
    , user_name
    , direct_objects_accessed
    , base_objects_accessed
    , objects_modified
FROM {{ source('snowflake_account_usage', 'access_history') }}

--to reduce the compute of the query, we add this condition to only query the previous month of data
{% if is_incremental() %}
    WHERE
        query_start_time > current_date - 30
        AND query_start_time > (SELECT coalesce(max(query_start_time), DATE '1970-01-01') FROM {{ this }})
{% endif %}

WHERE query_start_time > current_date - 30
ORDER BY query_start_time ASC
