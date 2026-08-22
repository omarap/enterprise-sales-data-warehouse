SELECT COUNT(*) AS orphaned_sales
FROM warehouse.fact_sales AS f
LEFT JOIN warehouse.dim_customer AS c
    ON c.customer_key = f.customer_key
LEFT JOIN warehouse.dim_product AS p
    ON p.product_key = f.product_key
LEFT JOIN warehouse.dim_location AS l
    ON l.location_key = f.location_key
LEFT JOIN warehouse.dim_date AS d
    ON d.date_key = f.date_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL
   OR l.location_key IS NULL
   OR d.date_key IS NULL;