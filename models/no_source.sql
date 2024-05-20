
with no_source as (
select 1 as od_id, 'jump' as asset_type 
union all
select 2 as od_id, 'sit' as asset_type 
union all
select 3 as od_id, 'stand' as asset_type 
)
select * from no_source