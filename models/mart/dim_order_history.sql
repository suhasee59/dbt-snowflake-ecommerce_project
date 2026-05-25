{{ config(materialized='table') }}

select
    order_id,
    order_status                    as status_value,
    dbt_valid_from                  as valid_from,
    dbt_valid_to                    as valid_to,
    case
        when dbt_valid_to is null then true
        else false
    end                             as is_current,
    datediff(
        'day',
        dbt_valid_from,
        coalesce(dbt_valid_to, current_timestamp)
    )                               as days_in_status

from {{ ref('orders_snapshot') }}