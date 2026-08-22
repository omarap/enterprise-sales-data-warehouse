SELECT
    customer_key,
    customer_id,
    first_name,
    last_name,
    location_key
FROM warehouse.dim_customer
ORDER BY customer_key;