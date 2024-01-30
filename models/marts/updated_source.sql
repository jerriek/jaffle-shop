    {{ config(
            post_hook="{{ update_records(
                from_relation=ref('test_source'), 
                unique_key='offer_id', 
                update_cols=['amount']
            ) }}"
    ) }}

with source_data as (
select 1 as offer_id, 'towing' as fee_type, 75 as amount, '2023-01-04 10:14' as fee_date union all
select 2 as offer_id, 'towing' as fee_type, 75 as amount, '2023-01-04 10:14' as fee_date union all
select 2 as offer_id, 'towing' as fee_type, 75 as amount, '2023-01-04 16:15' as fee_date union all
select 3 as offer_id, 'towing' as fee_type, 95 as amount, '2023-01-04 16:15' as fee_date)

select * from source_data
