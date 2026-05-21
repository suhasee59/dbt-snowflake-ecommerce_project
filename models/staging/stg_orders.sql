select

    order_id as order_id,
    customer_id as customer_id,
    session_id as session_id,
    order_date::date as order_date,
    created_at::timestamp_ntz as created_at,
    updated_at::timestamp_ntz as updated_at,
    lower(trim(order_status)) as order_status,
    upper(trim(currency)) as currency,
    lower(trim(payment_method)) as payment_method,
    lower(trim(shipping_method)) as shipping_method,
    shipping_cost::float as shipping_cost,
    subtotal::float as subtotal,
    discount_amount::float as discount_amount,
    tax_amount::float as tax_amount,
    total_amount::float as total_amount,
    lower(trim(device_type)) as device_type,
    lower(trim(referrer_source)) as referrer_source

from {{ source("e_raw", "raw_orders") }}
