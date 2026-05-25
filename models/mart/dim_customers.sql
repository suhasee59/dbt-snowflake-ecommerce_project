{{ config(materialized="table") }}

with base as (select * from {{ ref("int_orders_customer") }})

select

    customer_id,
    full_name,
    email,
    city,
    state,
    customer_segment,
    is_active,
    total_orders,
    completed_orders,
    cancelled_orders,
    first_order_date,
    last_order_date,
    datediff('day', last_order_date, current_date()) as days_since_last_order,
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
