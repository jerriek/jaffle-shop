{% macro get_columns_attributes(model) %}

  select
  
    '{{ model.description }}' as model_description,
    '{{ model.columns.tags | tojson }}' as column_tags

{% endmacro %}