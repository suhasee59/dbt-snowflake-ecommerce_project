{{
    config(
        materialized="incremental",
        unique_key="order_id",
        on_schema_change="sync_all_columns",
    )
}}


with
    orders as (

        select *
        from {{ ref("int_order_payment") }}
        -- incremental filter: only pick up new/updated rows
        {% if is_incremental() %}
            where updated_at > (select max(updated_at) from {{ this }})
        {% endif %}

    ),

    items_summary as (

        select
            order_id,
            count(order_item_id) as total_items,
            sum(quantity) as total_quantity,
            sum(net_item_amount) as total_net_amount,
            sum(case when is_late_shipment then 1 else 0 end) as late_items
        from {{ ref("int_order_item_product") }}
        group by 1

    ),


 currency as (
        select * from {{ ref('currency_mapping') }}
    )

select

    -- identifiers
    o.order_id,
    o.customer_id,
    o.session_id,
    o.payment_id,
    o.transaction_id,

    -- dates
    o.order_date,
    o.processed_at,

    -- order info
    o.order_status,
    o.currency,
    o.device_type,
    o.referrer_source,

    -- shipping
    o.shipping_method,
    o.shipping_cost,

    -- payment
    o.payment_method,
    o.payment_status,
    o.gateway_response_code,
    o.processing_time_sec,

    -- amounts
    o.subtotal,
    o.discount_amount,
    o.tax_amount,
    o.total_amount,
    {{ convert_to_usd('o.total_amount', 'o.currency') }} as total_amount_usd,
    o.payment_amount,

    -- items summary (from order_items)
    i.total_items,
    i.total_quantity,
    i.total_net_amount,
    i.late_items,

    -- derived: was fully paid?
    case
        when o.payment_status = 'completed' and o.payment_amount >= o.total_amount
        then true
        else false
    end as is_fully_paid,

    -- metadata
    o.created_at,
    o.updated_at

from orders o
left join items_summary i on o.order_id = i.order_id
left join currency c      on o.currency = c.currency_code
