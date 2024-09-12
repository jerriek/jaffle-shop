
{#I want to build models in the write schema automatically based on folder #}

{% macro generate_schema_name(custom_schema_name, node) %}
  {% set default_schema = target.schema %}
  {% if custom_schema_name %}
    {{ custom_schema_name }}



  {% elif  %}
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



--example from jaffle shop
{% macro generate_schema_name(custom_schema_name, node) %}

    {% set default_schema = target.schema %}

    {# seeds go in a global `raw` schema #}
    {% if node.resource_type == 'seed' %}
        {{ custom_schema_name | trim }}

    {# non-specified schemas go to the default target schema #}
    {% elif custom_schema_name is none %}
        {{ default_schema }}


    {# specified custom schema names go to the schema name prepended with the the default schema name in prod (as this is an example project we want the schemas clearly labeled) #}
    {% elif target.name == 'prod' %}
        {{ default_schema }}_{{ custom_schema_name | trim }}

    {# specified custom schemas go to the default target schema for non-prod targets #}
    {% else %}
        {{ default_schema }}
    {% endif %}

{% endmacro %}

-- example from website
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {%- else -%}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}

-- schema by environment remains default otherwise custom schema
-- put this in macros/get_custom_schema.sql

{% macro generate_schema_name(custom_schema_name, node) -%}
    {{ generate_schema_name_for_env(custom_schema_name, node) }}
{%- endmacro %}