select
    payment_id,
    order_id,
    payment_method,
    amount,
    currency,
    payment_status,
    transaction_id,
    processed_at,
    gateway_response_code,
    created_at,
    datediff('second', created_at, processed_at) as processing_time_sec
from {{ source("e_raw", "raw_payments") }}
