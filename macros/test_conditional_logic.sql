{% test assert_conditional_not_null(model, column_name, condition_column, condition_operator, condition_value) %}
    select *
    from {{ model }}
    where {{ condition_column }} {{ condition_operator }} {{ condition_value }}
      and {{ column_name }} is null
{% endtest %}

{% test assert_positive_values_when_condition(model, column_name, condition_column, condition_operator, condition_value) %}
    select *
    from {{ model }}
    where {{ condition_column }} {{ condition_operator }} {{ condition_value }}
      and {{ column_name }} <= 0
{% endtest %}

{% test assert_customer_type_logic(model, customer_type_column='customer_type', order_count_column='count_lifetime_orders') %}
    select *
    from {{ model }}
    where ({{ customer_type_column }} = 'returning' and {{ order_count_column }} <= 1)
       or ({{ customer_type_column }} = 'new' and {{ order_count_column }} > 1)
{% endtest %} 