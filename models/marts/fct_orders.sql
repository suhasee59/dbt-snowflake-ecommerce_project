SELECT
    o.order_id,
    o.order_date,
    o.status,
    o.order_amount,
    c.full_name    AS customer_name,
    c.email,
    c.country
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_customers') }} c
    ON o.customer_id = c.customer_id