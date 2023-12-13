
{% macro table_count(table_name) -%}
    (select count(*) as record_count
  from {{ ref(table_name) }})
{%- endmacro %}
