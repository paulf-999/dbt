{{
    config(
        materialized='incremental',
        tags=["incremental"]
    )
}}

SELECT order_items.order_id
        , products.product_id
        , stores.store_id
        , staffs.staff_id
        , products.product_name
        , order_date
        , required_date
        , shipped_date
        , order_items.quantity
        , order_items.list_price
        , order_items.discount
        , staffs.first_name
        , staffs.last_name
FROM {{ ref('dwh', 'products_raw') }} AS products
LEFT JOIN {{ ref('dwh', 'order_items_raw') }} AS order_items
    ON order_items.product_id = products.product_id
LEFT JOIN {{ ref('dwh', 'orders_raw') }} AS orders
    ON orders.order_id = order_items.order_id
LEFT JOIN {{ ref('dwh', 'stores_raw') }} AS stores
    ON stores.store_id = orders.store_id
LEFT JOIN {{ ref('dwh', 'staffs_raw') }} AS staffs
    ON staffs.staff_id = orders.staff_id
LIMIT 5
