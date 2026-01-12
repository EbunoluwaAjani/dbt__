SELECT
    DATE_TRUNC('week', placed_at) AS week,
    AVG(hours_diff) AS avg_hours_to_ship
FROM {{ ref('int_order_fulfillment') }}
GROUP BY 1
