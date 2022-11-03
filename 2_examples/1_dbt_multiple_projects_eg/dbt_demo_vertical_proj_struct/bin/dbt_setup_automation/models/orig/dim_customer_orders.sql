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
FROM {{ source('bike_production', 'products') }}
LEFT JOIN {{ source('bike_sales', 'order_items') }}
    ON order_items.product_id = {{ source('bike_production', 'products') }}.product_id
LEFT JOIN {{ source('bike_sales', 'orders') }}
    ON orders.order_id = order_items.order_id
LEFT JOIN {{ source('bike_sales', 'stores') }}
    ON stores.store_id = orders.store_id
LEFT JOIN {{ source('bike_sales', 'staffs') }}
    ON staffs.staff_id = orders.staff_id
LIMIT 5
