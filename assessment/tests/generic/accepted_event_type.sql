{% test accepted_event_types(model, column_name) %}
{{config(severity = 'warn')}}

SELECT *
FROM {{ model }}
WHERE upper({{ column_name }}) NOT IN (
    'ADD_PRODUCT_TO_CART',
    'PAGE_VIEW',
    'REMOVE_PRODUCT_FROM_CART',
    'SEARCH',
    'SIGN_UP_SUCCESS',
    'VISIT_PERSONAL_RECOMMENDATION',
    'VISIT_RECENTLY_VISITED_PRODUCT',
    'VISIT_RELATED_PRODUCT'
)

{% endtest %}