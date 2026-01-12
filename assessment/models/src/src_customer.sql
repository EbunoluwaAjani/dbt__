with customer as (
select
	*
from
	{{ source('raw', 'customer') }})
	select
	name as customer_name,
	email,
	phone_number,
	id as customer_id,
	created_at,
	modified_at,
	ts as timestamp
from
	customer
