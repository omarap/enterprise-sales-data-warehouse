SELECT
    date_key,
    full_date,
    month_name,
    quarter_name,
    year_number,
    day_name,
    is_weekend
FROM warehouse.dim_date
ORDER BY full_date
LIMIT 10;