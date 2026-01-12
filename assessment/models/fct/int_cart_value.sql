with cart_items as (
    -- Get items added to cart in the last session
    select
        s.customer_id,
        s.session_id,
        s.product_id,
        oi.quantity,
        oi.price
    from {{ ref('int_session') }} s
    join {{ ref('fct_orderitem') }} oi
        on oi.product_id = s.product_id
        and oi.price > 0
    where s.event_type = 'ADD_PRODUCT_TO_CART'
)

    -- Compute cart value for the last session
    select
        o.customer_id,
        sum(c.quantity * c.price) as cart_value
    from {{ref('int_check_order')}} o
    join cart_items c
        on c.customer_id = o.customer_id
       and c.session_id = o.last_session_id
    group by 1


