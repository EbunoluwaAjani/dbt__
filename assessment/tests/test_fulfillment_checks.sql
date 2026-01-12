with order_fulfillment as (
    select
        order_id,
        max(case when upper(order_status) = 'PLACED' then created_at end) as placed_at,
        max(case when upper(order_status) = 'SHIPPED' then modified_at end) as shipped_at
    from {{ ref('fct_orders') }}
    where upper(order_status) in ('PLACED', 'SHIPPED')
    group by order_id
)

select *
from order_fulfillment
where shipped_at is not null
  and (
        shipped_at < placed_at              -- negative duration
        or shipped_at - placed_at > interval '90 days'  -- unrealistic duration
      )
