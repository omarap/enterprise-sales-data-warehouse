SELECT
    d.year_number,
    d.month_name,
    SUM(f.net_sales_amount) AS revenue
FROM warehouse.fact_sales AS f
JOIN warehouse.dim_date AS d
    ON d.date_key = f.date_key
GROUP BY
    d.year_number,
    d.month_number,
    d.month_name
ORDER BY
    d.year_number,
    d.month_number;