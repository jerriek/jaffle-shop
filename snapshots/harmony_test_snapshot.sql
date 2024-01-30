{% snapshot harmony_test %}
    {{ config(
            target_schema='snapshots',
            unique_key='source_id',
            strategy='check',
            check_cols=['EXPECTEDREBATEAMOUNT', 'EXPECTEDSALEFEES', 'REBATEAMOUNT', 'SALEFEES'],
            post_hook="{{ update_valid_snapshot_records(
                from_relation=ref('harmony_sample'), 
                unique_key='source_id', 
                update_cols=['LASTMODIFIEDAT']
            ) }}"

    ) }}

    select * from {{ ref('harmony_sample') }}

{% endsnapshot %}