{{
    config(
        schema='production'
    )
}}
--this would be a 'source' command in here
--logic:
--'if this wasn't installed as a package/child project'
--'use source'
--'else if it was, use ref'


SELECT * FROM {{ ref('bike_shop_sub_proj1', 'categories_dq') }}
