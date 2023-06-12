-- dim_order shouldn't be empty
select  count(*) as row_count
from    {{ ref('vw_dim_order' )}}
having  row_count < 1
