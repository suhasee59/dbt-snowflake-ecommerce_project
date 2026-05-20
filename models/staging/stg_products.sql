select
    product_id,
    initcap(trim(product_name)) as product_name,
    lower(trim(category)) as category,
    lower(trim(subcategory)) as subcategory,
    initcap(trim(brand)) as brand,
    base_price as base_price,
    cost_price as cost_price,
    stock_quantity as stock_quantity,
    is_active as is_active,
    supplier_id as supplier_id,
    launch_date as lunch_date,
    round(weight_kg::float, 3) as weight_kg,
    rating as rating,
    created_at as created_at
from {{ source("e_raw", "raw_products") }}
