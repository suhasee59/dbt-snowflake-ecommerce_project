with
    source as (select * from {{ source("e_raw", "raw_customers") }}),

    renamed as (

        select

            -- identifiers
            customer_id,

            -- name
            initcap(trim(first_name)) as first_name,
            initcap(trim(last_name)) as last_name,
            concat(
                initcap(trim(first_name)), ' ', initcap(trim(last_name))
            ) as full_name,

            -- contact
            lower(trim(email)) as email,
            nullif(trim(phone), '') as phone_no,

            -- location
            initcap(trim(city)) as city,
            upper(trim(state)) as state,
            trim(zip_code) as zip_code,

            -- customer info
            lower(trim(customer_segment)) as customer_segment,
            registration_date::date as registration_date,
            is_active::boolean as is_active,

            -- metadata
            created_at::timestamp_ntz as created_at,
            updated_at::timestamp_ntz as updated_at

        from source

    )

select *
from renamed
