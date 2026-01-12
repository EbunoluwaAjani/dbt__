with product as (
select
	*
from
	{{ source('raw', 'product') }})
select
	id as product_id,
	name as product_name,
	description,
	"EAN" as ean,
	price,
	discount_percent,
	brand,
	inventory,
	published,
	created_at,
	modified_at,
	ts as timestamp
from
	product