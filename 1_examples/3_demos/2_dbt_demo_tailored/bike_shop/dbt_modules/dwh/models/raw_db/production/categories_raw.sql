{{
    config(
        materialized='incremental',
        database='bike_shop_raw_db',
        schema='production',
        tags=["incremental"]
    )
}}

SELECT *
FROM {{ ref('snapshot_cdc_processing', 'categories_snapshot') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where load_ts > (select max(load_ts) from {{ this }})

{% endif %}
