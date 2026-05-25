select

    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.warehouse_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,
    p.cost_price,
    oi.quantity,
    oi.unit_price,
    oi.discount_amount,
    oi.gross_item_amount,
    oi.net_item_amount,
    oi.total_price,
    round(oi.net_item_amount - (p.cost_price * oi.quantity), 2) as item_margin,
    oi.fulfillment_status,
    oi.shipped_date,
    oi.shipping_delay_days,
    oi.is_late_shipment,
    oi.created_at

from {{ ref("stg_order_items") }} oi
left join {{ ref("stg_products") }} p on oi.product_id = p.product_id
