
  
with source_data as (
select 2 as offer_id, 'towing' as fee_type, 45 as amount, '2023-01-05 16:15' as fee_date union all
select 3 as offer_id, 'towing' as fee_type, 95 as amount, '2023-01-04 16:15' as fee_date)

select * from source_data
    
