{% docs mart_sales %}
The `mart_sales` model aggregates the weekly total discount given across all products over time.
{% enddocs %}

{% docs int_session %}
The `int_session` model groups customer events into sessions.

A session is defined as a continuous sequence of events for a single customer
with no more than 30 minutes of inactivity between consecutive events.
Session IDs are generated sequentially per customer by detecting inactivity
gaps in chronologically ordered events.
{% enddocs %}


{% docs int_last_session_per_customer %}
The `int_last_session_per_customer` model identifies each customer's most recent session.
{% enddocs %}


{% docs int_session_bounds %}
The `int_session_bounds` model calculates the start and end timestamps for every customer session.
{% enddocs %}


{% docs int_check_order %}
The `int_check_order` model filters to customers who placed an order during their last session.
{% enddocs %}


{% docs int_cart_value %}
The `int_cart_value` model retrieves items added to cart in the customer's last session
and computes the total cart value for that session.
{% enddocs %}

{% docs mart_cart_value %}
`mart_cart_value` returns each customer’s email and the total value of items added in their last session, limited to sessions where an order was placed.
A custom SQL test ensures that `cart_value` is always non‑negative.
{% enddocs %}

{% docs int_order_fulfillment %}
`int_order_fulfillment` extracts the timestamps for when each order was placed and shipped, and calculates `hours_diff`, the number of hours between the two events.
A consistency check ensures `shipped_at` occurs after `placed_at` and that fulfillment durations remain within realistic business ranges.
{% enddocs %}

{% docs weekly_order_fulfillment %}
`weekly_order_fulfillment` calculates the average number of hours it takes for orders to ship each week.
It uses `int_order_fulfillment` as its source, which provides validated placement and shipment timestamps.
{% enddocs %}






