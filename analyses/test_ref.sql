
{#
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




{% macro source() %}

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
#}