-- this macro overides the ref function and defines the limits as a project varaible 


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

