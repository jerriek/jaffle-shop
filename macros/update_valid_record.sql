{# This macro can be used in a post_hook to update only valid records with live
 # changes to the data on provided columns.
 # 
 # from_relation: Give the source() or ref() you want to grab current values from
 # unique_key: This is what it will be matched on
 # update_cols: This is the list of columns that you always want to stay up-to-date
 #}
{% macro update_valid_snapshot_records(from_relation='', unique_key='', update_cols=[]) %}
    create or replace view {{ this }}__dbt_tmp as (
        select 
            {{ unique_key }}, 
            {%- for column in update_cols %}{{ column }}{% if not loop.last %}, {% endif %}{% endfor %}
        from {{ from_relation }}
    );

    merge into {{ this }} as DBT_INTERNAL_DEST
        using {{ this }}__dbt_tmp as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.{{ unique_key }} = DBT_INTERNAL_DEST.{{ unique_key }}
        and DBT_INTERNAL_DEST.dbt_valid_to is null 
    
    when matched then update set
        {%- for column in update_cols %}
        "{{ column | upper }}" = DBT_INTERNAL_SOURCE.{{ column | upper }}{% if not loop.last %},{% endif %}
        {%- endfor %}
    ;
{% endmacro %}