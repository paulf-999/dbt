{{
    config(
        materialized='incremental',
        tags=["incremental"]
    )
}}

SELECT * FROM {{ source('bike_sales', 'order_items') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where load_ts > (select max(load_ts) from {{ this }})

{% endif %}