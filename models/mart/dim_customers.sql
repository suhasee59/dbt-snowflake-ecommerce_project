{{ config(materialized="table") }}

with base as (select * from {{ ref("int_orders_customer") }})

select

    -- identifiers
    customer_id,

    -- personal info
    full_name,
    email,
    city,
    state,
    customer_segment,
    is_active,

    -- order history
    total_orders,
    completed_orders,
    cancelled_orders,
    first_order_date,
    last_order_date,

    -- derived: days since last order
    datediff('day', last_order_date, current_date()) as days_since_last_order,

    -- derived: customer type based on order count
    case
        when total_orders = 0
        then 'no_orders'
        when total_orders = 1
        then 'new'
        when total_orders between 2 and 5
        then 'returning'
        when total_orders > 5
        then 'loyal'
    end as customer_type

from base
