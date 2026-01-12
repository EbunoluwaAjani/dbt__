select *
from {{ ref('mart_cart_value') }}
where cart_value < 0
