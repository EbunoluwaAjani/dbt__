select
	DATE_TRUNC('week',
	oi.created_at) as week_start,
	ROUND(
    SUM((oi.quantity * (p.price * p.discount_percent))::numeric),
	2
) as total_discount
from
	{{ ref('fct_orderitem') }} oi
join {{ ref('dim_product') }} p
    on
	oi.product_id = p.product_id
where
	oi.price > 0
group by
	1