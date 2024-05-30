-- this macro overides the ref function and defines the limits as a project varaible 

{#
{%- macro ref(model_name, relation=False) -%}
    {%- set ref_rel = builtins.ref(model_name) -%}
    {%- set filter = var('filter') -%}

    {%- if env_var('DBT_ENVIRONMENT') in ('dev','ci') and var('limit', true) and not relation -%}
        {% set dev_rel %} (select * from {{ ref_rel }} {{ filter }}) {% endset %}
        {% do return(dev_rel) %}
    {% else %}
        {% do return(ref_rel) %}
    {%- endif -%}

{%- endmacro -%}


{%- macro source(source_name, table_name, relation=False) -%}

    {% set rel_source = builtins.source(source_name, table_name) %}
    {%- set filter = var('filter') -%}

    {%- if env_var('DBT_ENVIRONMENT') in ('dev','ci') and var('limit', true) and not relation -%}
        {% set dev_source %} (select * from {{ rel_source }} {{ filter }}) {% endset %}
        {% do return(dev_source) %}
    {% else %}
        {% do return(rel_source) %}
    {% endif %}

{%- endmacro -%}
#}


{% macro ref() %}

-- extract user-provided positional and keyword arguments
{% set version = kwargs.get('version') or kwargs.get('v') %}
{% set packagename = none %}
{%- if (varargs | length) == 1 -%}
    {% set modelname = varargs[0] %}
{%- else -%}
    {% set packagename = varargs[0] %}
    {% set modelname = varargs[1] %}
{% endif %}

-- call builtins.ref based on provided positional arguments
{% set rel = None %}
{% if packagename is not none %}
    {% set rel = builtins.ref(packagename, modelname, version=version) %}
{% else %}
    {% set rel = builtins.ref(modelname, version=version) %}
{% endif %}

-- extract the filter variable
{% set filter = var('filter') %}

-- apply environment-specific logic
{% if env_var('DBT_ENVIRONMENT') in ('dev', 'ci') and var('limit', true) %}
    {% set newrel %} (select * from {{ rel }} {{ filter }}) {% endset %}
    {% do return(newrel) %}
{% else %}
    -- finally, override the database name with "dev"
    {% set newrel = rel.replace_path(database="dev") %}
    {% do return(newrel) %}
{% endif %}

{% endmacro %}
