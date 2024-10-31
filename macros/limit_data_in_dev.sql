{% macro limit_data_in_dev(column_name, dev_days=3) -%}
 {% if target.name == 'dev' %}
where {{ column_name }} >= dateadd('day', -{{ dev_days }}, current_date)
{% endif %}
{%- endmacro %}


{# overriding the ref macro to test this out at the project level #}

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

-- finally, override the database name with "dev"
{% set newrel = rel.replace_path(database="analytics") %}

-- additional logic to check environment and apply data limit if needed
{% set filter = var('filter') %}
{%- if env_var('DBT_ENVIRONMENT') in ('dev', 'ci') and var('limit', true) -%}
    {% set limited_rel %} (select * from {{ newrel }} {{ filter }}) {% endset %}
    {% do return(limited_rel) %}
{% else %}
    {% do return(newrel) %}
{%- endif -%}

{% endmacro %}
