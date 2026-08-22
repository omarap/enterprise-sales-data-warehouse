SELECT
    p.product_name,
    p.category,
    SUM(f.quantity) AS units_sold,
    SUM(f.net_sales_amount) AS revenue,
    SUM(f.profit_amount) AS profit
FROM warehouse.fact_sales AS f
JOIN warehouse.dim_product AS p
    ON p.product_key = f.product_key
GROUP BY
    p.product_name,
    p.category
ORDER BY revenue DESC;