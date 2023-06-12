-- dim_category shouldn't be empty
select  count(*) as row_count
from    {{ ref('vw_dim_category' )}}
having  row_count < 1
