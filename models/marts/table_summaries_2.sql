{% set table_list = ["customers", "orders","supplies"] %}

select
    {%- for table_name in table_list -%}
        (select count(*) from {{ ref(table_name) }}) as {{ table_name }}_count
        {%- if not loop.last -%} 
            , 
        {%- endif -%}
    {%- endfor -%}
