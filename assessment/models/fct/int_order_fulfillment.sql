with order_fulfillment as (
    select
        order_id,
        created_at,
        max(case when order_status = 'PLACED' then created_at end) as placed_at,
        max(case when order_status = 'SHIPPED' then modified_at end) as shipped_at
    from {{ ref('fct_orders') }}
    where upper(order_status) in ('PLACED', 'SHIPPED')
    group by order_id, created_at
)

select
    order_id,
    created_at,
    placed_at,
    shipped_at,
    extract(epoch from (shipped_at - placed_at)) / 3600 as hours_diff
from order_fulfillment
where placed_at is not null