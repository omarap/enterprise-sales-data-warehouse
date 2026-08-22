SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(f.net_sales_amount) AS total_revenue
FROM warehouse.fact_sales AS f
JOIN warehouse.dim_customer AS c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;