{{ config(materialized="table") }}

with base as (select * from {{ ref("stg_products") }})

select

    product_id,
    supplier_id,
    product_name,
    category,
    subcategory,
    brand,
    is_active,
    weight_kg,
    rating,
    base_price,
    cost_price,
    case
        when base_price < 20
        then 'budget'
        when base_price between 20 and 100
        then 'mid_range'
        when base_price > 100
        then 'premium'
    end as price_tier,
    case
        when stock_quantity = 0
        then 'out_of_stock'
        when stock_quantity < 10
        then 'low_stock'
        else 'in_stock'
    end as stock_status,
    created_at

from base
