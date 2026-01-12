--- Get the start/end timestamps of each session
    select
        customer_id,
        session_id,
        min(created_at) as session_start,
        max(created_at) as session_end
    from {{ ref('int_session') }}
    group by 1,2
