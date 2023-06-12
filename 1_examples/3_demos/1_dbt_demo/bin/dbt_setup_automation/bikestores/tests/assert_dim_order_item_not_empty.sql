-- dim_order_item shouldn't be empty
select  count(*) as row_count
from    {{ ref('vw_dim_order_item' )}}
having  row_count < 1
