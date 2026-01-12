{{
    config(
        materialized = 'incremental',
        unique_key = 'event_id',
        on_schema_change = 'fail'
    )
}}

with src_events as (
    select *
    from {{ ref('src_events') }}
)

select
    event_id,
    event_type,
    (event::jsonb ->> 'customer-id')::int as customer_id,
    (event::jsonb ->> 'product')::int     as product,
    event::jsonb ->> 'referrer' as referrer,
    event::jsonb ->> 'user-agent' as user_agent,
	event::jsonb ->> 'ip' as ip,
    created_at,
    modified_at
from src_events
where (event::jsonb ->> 'customer-id') is not null

{% if is_incremental() %}
    and modified_at > (
        select coalesce(max(modified_at), '1900-01-01')
        from {{ this }}
    )
{% endif %}