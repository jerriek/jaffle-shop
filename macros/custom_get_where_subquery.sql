{#{% macro get_where_subquery(relation) -%}
    {% set where = config.get('where') %}
    {% if where %}
        {% if "__three_days_ago__" in where %}
            {# replace placeholder string with result of custom macro #}
{#            {% set three_days_ago = dbt.dateadd('day', -3, current_timestamp()) %}
            {% set where = where | replace("__three_days_ago__", three_days_ago) %}
        {% endif %}
        {%- set filtered -%}
            (select * from {{ relation }} where {{ where }}) dbt_subquery
        {%- endset -%}
        {% do return(filtered) %}
    {%- else -%}
        {% do return(relation) %}
    {%- endif -%}
{%- endmacro %} #}


{% macro get_where_subquery(relation) -%}
    {% do return(adapter.dispatch('get_where_subquery', 'dbt')(relation)) %}
{%- endmacro %}

{% macro default__get_where_subquery(relation) -%}
    {# Check if the 'is_full_test' variable is set to true #}
    {% if var('is_full_test', false) %}
        {# Return the relation without any condition if 'is_full_test' is true #}
        {% do return(relation) %}
    {% else %}
        {# Apply the configured 'where' clause otherwise #}
        {% set where = config.get('where', '') %}
        {% if where %}
            {%- set filtered -%}
                (select * from {{ relation }} where {{ where }}) dbt_subquery
            {%- endset -%}
            {% do return(filtered) %}
        {% else %}
            {% do return(relation) %}
        {% endif %}
    {% endif %}
{%- endmacro %}
