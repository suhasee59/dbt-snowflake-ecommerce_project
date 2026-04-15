SELECT
    customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name,
    LOWER(email)                   AS email,
    country
FROM {{ source('raw', 'customers') }}