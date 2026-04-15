SELECT
    order_id,
    customer_id,
    order_date,
    LOWER(status)  AS status,
    amount         AS order_amount
FROM {{ source('raw', 'orders') }}