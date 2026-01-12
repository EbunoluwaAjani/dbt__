select
	*
from
	{{ ref ('fct_events')}}
where
	customer_id is null
