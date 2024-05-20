{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}
    
    {%- if custom_schema_name is none or target.name in ['dev'] -%}

        {{ default_schema }}

    {%- else -%}

       {{ custom_schema_name }}

    {%- endif -%}

{%- endmacro %}