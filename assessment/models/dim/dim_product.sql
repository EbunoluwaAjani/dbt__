with src_product as (
    select *
    from {{ ref('src_product') }}
),

deduped as (
    select *
    from (
        select
            *,
            row_number() over (
                partition by product_id
                order by modified_at desc
            ) as rn
        from src_product
    ) t
    where rn = 1
)

select
    product_id,
    product_name,
    description,
    ean,
    round(price::numeric, 2) as price,
    discount_percent,
    case when discount_percent > 0 then true else false end as is_discounted,
    brand,
    inventory,
    published,
    created_at
from deduped