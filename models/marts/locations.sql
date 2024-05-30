with

locations as (

    select * from {{ ref('stg_locations') }}

)

select * ,
1 as test
from locations
