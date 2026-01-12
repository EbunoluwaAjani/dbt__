
    select
        ls.customer_id,
        ls.last_session_id,
        o.order_id,
        o.created_at as order_time
    from {{ref('int_last_session_per_customer') }} ls
    join {{ref('int_session_bounds')}} sb
        on sb.customer_id = ls.customer_id
       and sb.session_id = ls.last_session_id
    join {{ ref('fct_orders') }} o
        on o.customer_id = ls.customer_id
       and o.created_at between sb.session_start and sb.session_end
