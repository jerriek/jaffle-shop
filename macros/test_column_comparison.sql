{% test assert_column_a_less_than_or_equal_to_column_b(model, column_a, column_b) %}
    select *
    from {{ model }}
    where {{ column_a }} > {{ column_b }}
{% endtest %}

{% test assert_column_a_greater_than_or_equal_to_column_b(model, column_a, column_b) %}
    select *
    from {{ model }}
    where {{ column_a }} < {{ column_b }}
{% endtest %}

{% test assert_non_negative(model, column_name) %}
    select *
    from {{ model }}
    where {{ column_name }} < 0
{% endtest %} 