{{
    config(
        materialized='incremental',
        on_schema_change='fail'
    )
}}

with src_orders as (
    select *
    from {{ ref('src_orders') }}
)

select
    order_id,
    customer_id,
    customer_address,
    order_status,
    created_at,
    modified_at
from src_orders

{% if is_incremental() %}
    where modified_at > (
        select coalesce(max(modified_at), '1900-01-01')
        from {{ this }}
    )
{% endif %}