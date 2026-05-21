select
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price as gross_item_amount,
    (quantity * unit_price) - coalesce(discount_amount, 0) as net_item_amount,
    discount_amount,
    total_price,
    fulfillment_status,
    warehouse_id,
    shipped_date,
    created_at,
    datediff('day', created_at, shipped_date) as shipping_delay_days,
    case
        when datediff('day', created_at, shipped_date) >= 3 then true else false
    end as is_late_shipment
from {{ source("e_raw", "raw_order_items") }}
