{% snapshot updated_test_source %}
    {{ config(
            target_schema='snapshots',
            unique_key='offer_id',
            strategy='check',
            check_cols=['amount'],
            post_hook="{{ update_valid_snapshot_records(
                from_relation=ref('test_source'), 
                unique_key='offer_id', 
                update_cols=['fee_type']
            ) }}"
    ) }}

    select * from {{ ref('test_source') }}

{% endsnapshot %}