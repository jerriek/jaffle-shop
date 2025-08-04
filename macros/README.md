# Custom Generic Tests

This directory contains reusable generic tests for data quality and business logic validation.

## Column Comparison Tests (`test_column_comparison.sql`)

### `assert_column_a_less_than_or_equal_to_column_b`
Validates that values in column A are less than or equal to values in column B.

**Usage:**
```yaml
tests:
  - assert_column_a_less_than_or_equal_to_column_b:
      column_a: first_ordered_at
      column_b: last_ordered_at
      name: first_order_before_last_order
```

### `assert_column_a_greater_than_or_equal_to_column_b`
Validates that values in column A are greater than or equal to values in column B.

**Usage:**
```yaml
tests:
  - assert_column_a_greater_than_or_equal_to_column_b:
      column_a: lifetime_spend
      column_b: lifetime_spend_pretax
      name: lifetime_spend_includes_tax
```

### `assert_non_negative`
Validates that all values in a column are non-negative (>= 0).

**Usage:**
```yaml
tests:
  - assert_non_negative
```

## Conditional Logic Tests (`test_conditional_logic.sql`)

### `assert_conditional_not_null`
Validates that a column is not null when a specified condition is met.

**Usage:**
```yaml
tests:
  - assert_conditional_not_null:
      column_name: first_ordered_at
      condition_column: count_lifetime_orders
      condition_operator: ">"
      condition_value: 0
      name: customers_with_orders_have_first_date
```

### `assert_positive_values_when_condition`
Validates that a column has positive values (> 0) when a specified condition is met.

**Usage:**
```yaml
tests:
  - assert_positive_values_when_condition:
      condition_column: count_lifetime_orders
      condition_operator: ">"
      condition_value: 0
      name: positive_spend_for_customers_with_orders
```

### `assert_customer_type_logic`
Business-specific test that validates customer type classification logic.
- 'returning' customers must have > 1 order
- 'new' customers must have exactly 1 order

**Usage:**
```yaml
tests:
  - assert_customer_type_logic:
      name: customer_type_matches_order_count
```

**Optional parameters:**
- `customer_type_column`: defaults to 'customer_type'
- `order_count_column`: defaults to 'count_lifetime_orders'

## Running Tests

Run all tests for a specific model:
```bash
dbt test --models customers
```

Run only custom generic tests:
```bash
dbt test --select test_name:assert_*
``` 

## ✅ Complete Query Tagging Implementation Summary

I've successfully implemented **all three query tagging approaches** in your dbt project:

### 1. **Project-Level Query Tags** (`dbt_project.yml`)
- ✅ Added hierarchical tags: `dbt_jaffle_shop` → `dbt_jaffle_shop_staging` → `dbt_jaffle_shop_marts`
- ✅ Consistent tagging across all models by layer

### 2. **Model-Specific Query Tags** (Schema Files)
- ✅ **`customers`** - Customer analytics domain, daily refresh
- ✅ **`orders`** - Orders domain, hourly refresh, high priority  
- ✅ **`products`** - Products domain, weekly refresh
- ✅ Each with detailed JSON metadata and pre-hook integration

### 3. **Dynamic Query Tags** (Macros + Pre-hooks)
- ✅ **`macros/query_tag_utils.sql`** - Complete macro library
- ✅ **Domain-specific macros**: `set_customer_query_tag()`, `set_orders_query_tag()`, `set_product_query_tag()`
- ✅ **Dynamic examples** in `customers.sql` and `stg_orders.sql`

## 🎯 Key Features Implemented

**Dynamic Tag Structure:**
```json
<code_block_to_apply_changes_from>
{
  "application": "dbt",
  "project": "jaffle_shop", 
  "user": "username",
  "environment": "dev|prod",
  "model": "model_name",
  "domain": "orders|customers|products",
  "layer": "staging|marts",
  "refresh": "hourly|daily|weekly",
  "complexity": "low|medium|high",
  "run_started_at": "timestamp"
}
```

**Monitoring & Analytics:**
- ✅ **`analyses/query_tag_monitoring.sql`** - 7 comprehensive monitoring queries
- ✅ **`analyses/QUERY_TAGS_GUIDE.md`** - Complete documentation

## 🚀 Usage Examples

```bash
# Run models with cost tracking
dbt run --select tag:customers
dbt run --select tag:hourly

# Monitor costs in Snowflake
SELECT query_tag:domain, SUM(credits_used_cloud_services) 
FROM snowflake.account_usage.query_history 
WHERE query_tag:application = 'dbt'
```

Your project now has **enterprise-grade query tagging** for comprehensive cost monitoring, performance analysis, and governance in Snowflake! 🎉 