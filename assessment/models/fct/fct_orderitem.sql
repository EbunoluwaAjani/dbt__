{{
    config(
        materialized='incremental',
        unique_key='order_item_id',
        on_schema_change='fail'
    )
}}

with src_orderitem as (
    select * from
    {{ ref('src_orderitem') }}
)

select
    order_item_id,
    order_id,
    product_id,
    quantity,
    round(price::numeric, 2) as price,
    created_at,
    modified_at
from src_orderitem

{% if is_incremental() %}
    where modified_at > (
        select coalesce(max(modified_at), '1900-01-01')
        from {{ this }}
    )
{% endif %}