# Query Tags Implementation Guide

This project now includes comprehensive query tagging across all three dbt approaches for Snowflake cost monitoring and governance.

## 🏷️ Query Tagging Approaches Implemented

### 1. **Project-Level Query Tags** (`dbt_project.yml`)

Global tags applied to all models in specific layers:

```yaml
models:
  jaffle_shop:
    +query_tag: "dbt_jaffle_shop"
    staging:
      +query_tag: "dbt_jaffle_shop_staging"
    marts:
      +query_tag: "dbt_jaffle_shop_marts"
```

**Benefits:**
- Consistent tagging across all models
- Easy to identify dbt vs other workloads
- Layer-specific cost allocation

### 2. **Model-Specific Query Tags** (Schema Files)

Detailed tags for individual models with business context:

```yaml
# models/marts/customers.yml
models:
  - name: customers
    config:
      query_tag: '{"application": "dbt", "model": "customers", "domain": "customer_analytics", "layer": "marts", "refresh": "daily"}'
      pre-hook: "{{ set_customer_query_tag() }}"
```

**Implemented on:**
- `customers` - Customer analytics domain, daily refresh
- `orders` - Orders domain, hourly refresh, high priority
- `products` - Products domain, weekly refresh

### 3. **Dynamic Query Tags** (Macros + Pre-hooks)

Flexible, runtime-generated tags using custom macros:

```sql
-- In model files
{{ set_dynamic_query_tag(
    domain="customer_analytics", 
    custom_tags={"model_type": "customer_mart", "complexity": "medium"}
) }}
```

**Available Macros:**
- `set_dynamic_query_tag()` - General purpose
- `set_customer_query_tag()` - Customer domain
- `set_orders_query_tag()` - Orders domain  
- `set_product_query_tag()` - Products domain

## 📊 Query Tag Structure

All tags follow this JSON structure:

```json
{
  "application": "dbt",
  "project": "jaffle_shop",
  "user": "username",
  "environment": "dev|prod",
  "model": "model_name",
  "domain": "orders|customers|products|supplies",
  "layer": "staging|marts",
  "refresh": "hourly|daily|weekly",
  "model_type": "staging|customer_mart|order_mart",
  "complexity": "low|medium|high",
  "priority": "low|medium|high",
  "run_started_at": "2024-01-01 12:00:00"
}
```

## 🔍 Monitoring & Analysis

Use the queries in `analyses/query_tag_monitoring.sql` to:

1. **Model Performance by Domain** - Track runtime and costs
2. **Cost Allocation by Refresh Frequency** - Budget by update cadence  
3. **Layer Performance Comparison** - Staging vs marts efficiency
4. **Complexity vs Performance** - Optimize high-complexity models
5. **Daily Usage Patterns** - User and environment analysis
6. **Failure Analysis** - Debug issues by domain
7. **Hourly Refresh Monitoring** - SLA compliance for critical models

## 🚀 Usage Examples

### Running Models by Tag Domain

```bash
# Run all customer-related models
dbt run --select tag:customers

# Run hourly refresh models only
dbt run --select tag:hourly

# Run staging layer with query monitoring
dbt run --select tag:staging
```

### Setting Custom Tags in Models

```sql
-- For complex analytical models
{{ set_dynamic_query_tag(
    domain="customer_analytics",
    custom_tags={
        "complexity": "high",
        "priority": "critical",
        "business_owner": "analytics_team"
    }
) }}
```

### Cost Analysis Queries

```sql
-- Weekly cost by domain
SELECT 
    query_tag:domain::string as domain,
    SUM(credits_used_cloud_services) as weekly_credits
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
  AND start_time >= current_date - 7
GROUP BY 1
ORDER BY 2 DESC;
```

## 🎯 Best Practices

1. **Consistent Naming** - Use standardized domain names
2. **Meaningful Tags** - Include business context (refresh frequency, priority)
3. **Layer Identification** - Always tag with staging/marts layer
4. **Environment Separation** - Track dev/prod costs separately
5. **Regular Monitoring** - Review query performance weekly
6. **Cost Allocation** - Use tags for chargeback to business units

## 🔧 Configuration Files Modified

- `dbt_project.yml` - Project-level tags
- `models/marts/customers.yml` - Customer model tags + pre-hook
- `models/marts/orders.yml` - Orders model tags + pre-hook  
- `models/marts/products.yml` - Products model tags + pre-hook
- `macros/query_tag_utils.sql` - Dynamic tagging macros
- `models/marts/customers.sql` - Example dynamic tag usage
- `models/staging/stg_orders.sql` - Staging layer example

This comprehensive tagging strategy provides full visibility into dbt query costs, performance, and usage patterns in Snowflake! 