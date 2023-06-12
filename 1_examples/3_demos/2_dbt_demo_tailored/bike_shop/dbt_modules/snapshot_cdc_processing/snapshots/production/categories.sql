{% snapshot categories_snapshot %}

{{
    config(
        target_database='bike_shop_snapshot_proc_db',
        target_schema='production',
        unique_key='category_id',

        strategy='timestamp',
        updated_at='load_ts',
    )
}}

SELECT * FROM {{ ref('data_quality', 'categories_dq') }}

{% endsnapshot %}
