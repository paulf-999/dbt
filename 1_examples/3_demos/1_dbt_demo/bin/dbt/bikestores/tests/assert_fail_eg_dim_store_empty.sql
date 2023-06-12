-- dim_store shouldn't be empty
select  count(*) as row_count
from    {{ ref('vw_dim_store' )}}
having  row_count > 1
