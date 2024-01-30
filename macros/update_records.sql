{# This macro can be used in a post_hook to update only valid records with live
 # changes to the data on provided columns.
 # 
 # from_relation: Give the source() or ref() you want to grab current values from
 # unique_key: This is what it will be matched on

 #}
{% macro update_records(from_relation='', unique_key='', update_cols=[]) %}
    create or replace view {{ this }}__dbt_tmp as (
        select 
            {{ unique_key }}, 
            {%- for column in update_cols %}{{ column }}{% if not loop.last %}, {% endif %}{% endfor %}
        from {{ from_relation }}
    );

{% endmacro %}