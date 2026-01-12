{{ config(
    materialized = 'incremental',
    unique_key   = 'customer_id',
    on_schema_change = 'fail'
) }}

with src_customer as (
    select
        customer_id,
        customer_name,
        email,
        created_at,
        modified_at,
        regexp_replace(split_part(phone_number, 'x', 1), '[^0-9]', '', 'g') as digits_only
    from {{ ref('src_customer') }}
),

normalized as (
    select
        customer_id,
        customer_name,
        email,
        created_at,
        modified_at,
        case
            when length(digits_only) > 10 and left(digits_only, 3) = '001' then right(digits_only, 10)
            when length(digits_only) > 10 and left(digits_only, 1) = '1' then right(digits_only, 10)
            when length(digits_only) = 10 then digits_only
            else null
        end as phone_number
    from src_customer
)

select
    customer_id,
    customer_name,
    email,
    phone_number,
    created_at,
    modified_at
from normalized

{% if is_incremental() %}
where modified_at > (
    select max(modified_at)
    from {{ this }}
)
{% endif %}
