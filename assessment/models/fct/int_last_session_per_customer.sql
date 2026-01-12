 -- Identify each customer's last session
    select
        customer_id,
        max(session_id) as last_session_id
    from {{ ref('int_session') }}
    group by customer_id




