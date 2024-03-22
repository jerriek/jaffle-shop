
{#I want to build models in the write schema automatically based on folder #}

{% macro generate_schema_name(custom_schema_name, node) %}
  {% set default_schema = target.schema %}
  {% if custom_schema_name %}
    {{ custom_schema_name }}
  {% else %}
    {% set model_path = node.path.split('/') %}
    {% if 'mart' in model_path %}
      {% set intermediate_index = model_path.index('mart') %}
      {% if model_path|length > intermediate_index + 1 %}
        {% set schema_name = model_path[intermediate_index + 1] %}
        {{ schema_name }}
      {% else %}
        {{ default_schema }}
      {% endif %}
    {% else %}
      {{ default_schema }}
    {% endif %}
  {% endif %}
{% endmacro %}
