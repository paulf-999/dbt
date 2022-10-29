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

select *
FROM {{ dynamic_ref('bike_production', 'categories') }}
