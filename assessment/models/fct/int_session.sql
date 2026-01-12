with ordered_events as (
  select
    customer_id,
    event_id,
    event_type,
    created_at,
    product as product_id,

    -- compute previous event once with deterministic ordering
    lag(created_at) over (
      partition by customer_id
      order by created_at, event_id
    ) as previous_event_time
  from {{ ref('fct_events') }}
),

with_deltas as (
  select
    *,
    -- minutes since previous event; null for first event
    extract(epoch from (created_at - previous_event_time)) / 60.0 as min_since_prev_event,

    -- session break when gap > 30 minutes; first event is not a break
    case
      when previous_event_time is null then 0
      when extract(epoch from (created_at - previous_event_time)) / 60.0 > 30 then 1
      else 0
    end as session_break
  from ordered_events
),

sessionized as (
  select
    *,
    -- cumulative sum of breaks; add 1 so session_id starts at 1
    sum(session_break) over (
      partition by customer_id
      order by created_at, event_id
      rows between unbounded preceding and current row
    ) + 1 as session_id
  from with_deltas
)

select *
from sessionized