-- dim_staff shouldn't be empty
select  count(*) as row_count
from    {{ ref('vw_dim_staff' )}}
having  row_count < 1
