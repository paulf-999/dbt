{% snapshot order_items_snapshot %}

{{
    config(
        target_database='bike_shop_snapshot_proc_db',
        target_schema='sales',
        unique_key='order_id',

        strategy='timestamp',
        updated_at='load_ts',
    )
}}

SELECT * FROM {{ ref('data_quality', 'order_items_dq') }}

{% endsnapshot %}
