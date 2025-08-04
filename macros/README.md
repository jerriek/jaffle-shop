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