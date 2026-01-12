	with orders as (
select
	*
from
	{{ source('raw', 'orders') }})
	select
	customer as customer_id,
	status as order_status,
	customer_address,
	id as order_id,
	created_at,
	modified_at,
	ts as timestamp
from
	orders