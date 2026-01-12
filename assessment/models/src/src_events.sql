	with events as (
select
	*
from
	{{ source('raw', 'event') }})
	select
	type as event_type,
	id as event_id,
	created_at,
	modified_at,
	ts as timestamp,
	event
from
	events