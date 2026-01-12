select
    cv.customer_id,
    cu.email,
    cv.cart_value
from {{ref('int_cart_value')}} cv
join {{ ref('dim_customer') }} cu
    on cu.customer_id = cv.customer_id
order by cv.cart_value desc




