{% test accepted_order_types(model, column_name) %}
  {{ config(severity='warn') }}

  SELECT *
  FROM {{ model }}
  WHERE upper({{ column_name }}) NOT IN ('PLACED', 'SHIPPED', 'PAID')

{% endtest %}
