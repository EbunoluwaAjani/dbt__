with orderitem as (
    select * from stg_orderitem
)
select
    "order" as order_id,
    product as product_id,
    quantity,
    price,
    id as order_item_id,
    created_at,
    modified_at,
    ts as event_ts
from orderitem