{{ config(materialized="view") }}

with
    orders as (select * from {{ ref("stg_orders") }}),

    -- deduplicate payments → keep latest payment per order
    payments as (

        select *
        from
            (
                select
                    *,
                    row_number() over (
                        partition by order_id order by processed_at desc nulls last
                    ) as rn
                from {{ ref("stg_payments") }}
            )
        where rn = 1

    ),

    joined as (

        select

            o.order_id,
            o.customer_id,
            o.session_id,
            o.order_date,
            o.order_status,
            o.currency,
            o.device_type,
            o.referrer_source,
            o.shipping_method,
            o.shipping_cost,
            o.subtotal,
            o.discount_amount,
            o.tax_amount,
            o.total_amount,
            p.payment_id,
            p.payment_method,
            p.payment_status,
            p.transaction_id,
            p.amount as payment_amount,
            p.gateway_response_code,
            p.processed_at,
            p.processing_time_sec,
            o.created_at,
            o.updated_at

        from orders o
        left join payments p on o.order_id = p.order_id

    )

select *
from joined
