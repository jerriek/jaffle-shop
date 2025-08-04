{% macro set_dynamic_query_tag(model_name=none, domain=none, custom_tags={}) %}
  
  {% set base_tags = {
    "application": "dbt",
    "project": "jaffle_shop", 
    "user": target.user,
    "environment": target.name,
    "run_started_at": run_started_at.strftime("%Y-%m-%d %H:%M:%S") if run_started_at else "unknown"
  } %}
  
  {% if model_name %}
    {% do base_tags.update({"model": model_name}) %}
  {% endif %}
  
  {% if domain %}
    {% do base_tags.update({"domain": domain}) %}
  {% endif %}
  
  {% if this is defined and this.name %}
    {% do base_tags.update({"model": this.name}) %}
  {% endif %}
  
  {% if custom_tags %}
    {% do base_tags.update(custom_tags) %}
  {% endif %}
  
  {% set query_tag_json = base_tags | tojson %}
  
  ALTER SESSION SET QUERY_TAG = '{{ query_tag_json }}';

{% endmacro %}

{% macro set_model_query_tag(domain=none) %}
  {{ set_dynamic_query_tag(domain=domain) }}
{% endmacro %}

{% macro set_orders_query_tag() %}
  {{ set_dynamic_query_tag(domain="orders", custom_tags={"refresh_frequency": "hourly"}) }}
{% endmacro %}

{% macro set_customer_query_tag() %}
  {{ set_dynamic_query_tag(domain="customers", custom_tags={"refresh_frequency": "daily"}) }}
{% endmacro %}

{% macro set_product_query_tag() %}
  {{ set_dynamic_query_tag(domain="products", custom_tags={"refresh_frequency": "weekly"}) }}
{% endmacro %} 