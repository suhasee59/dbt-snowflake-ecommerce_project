with
    customers as (select * from {{ ref("stg_customers") }}),

    orders as (select * from {{ ref("stg_orders") }}),

    order_summary as (

        select
            customer_id,
            count(order_id) as total_orders,
            sum(total_amount) as totalorder_value,
            min(order_date) as first_order_date,
            max(order_date) as last_order_date,
            sum(
                case when order_status = 'completed' then 1 else 0 end
            ) as completed_orders,
            sum(
                case when order_status = 'cancelled' then 1 else 0 end
            ) as cancelled_orders
        from orders
        group by 1

    ),

    joined as (

        select

            -- customer info
            c.customer_id,
            c.full_name,
            c.email,
            c.city,
            c.state,
            c.customer_segment,
            c.is_active,

            -- order summary
            o.total_orders,
            o.totalorder_value,
            o.first_order_date,
            o.last_order_date,
            o.completed_orders,
            o.cancelled_orders

        from customers c
        left join order_summary o on c.customer_id = o.customer_id
    )

select *
from joined
