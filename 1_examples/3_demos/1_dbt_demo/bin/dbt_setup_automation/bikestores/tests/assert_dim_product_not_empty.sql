-- dim_product shouldn't be empty
select  count(*) as row_count
from    {{ ref('vw_dim_product' )}}
having  row_count < 1
