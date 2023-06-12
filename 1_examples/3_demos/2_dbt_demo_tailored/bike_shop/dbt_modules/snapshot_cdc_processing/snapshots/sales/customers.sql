{% snapshot customers_snapshot %}

{{
    config(
        target_database='bike_shop_snapshot_proc_db',
        target_schema='sales',
        unique_key='customer_id',

        strategy='timestamp',
        updated_at='load_ts',
    )
}}

SELECT * FROM {{ ref('data_quality', 'customers_dq') }}

{% endsnapshot %}
