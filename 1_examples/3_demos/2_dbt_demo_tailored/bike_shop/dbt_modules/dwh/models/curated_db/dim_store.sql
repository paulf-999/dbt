{{
    config(
        materialized='incremental',
        tags=["incremental"]
    )
}}

SELECT * FROM {{ ref('dwh', 'stores_raw') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where load_ts > (select max(load_ts) from {{ this }})

{% endif %}
