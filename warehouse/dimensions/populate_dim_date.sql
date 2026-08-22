/*
    Project: Enterprise Sales Data Warehouse
    File: populate_dim_date.sql

    Purpose:
        Populate the date dimension with calendar dates.

    Date range:
        2025-01-01 through 2027-12-31
*/

INSERT INTO warehouse.dim_date (
    date_key,
    full_date,
    day_number,
    month_number,
    month_name,
    quarter_number,
    quarter_name,
    year_number,
    week_number,
    day_of_week,
    day_name,
    is_weekend
)
SELECT
    TO_CHAR(calendar_date, 'YYYYMMDD')::INTEGER AS date_key,
    calendar_date AS full_date,

    EXTRACT(DAY FROM calendar_date)::INTEGER AS day_number,

    EXTRACT(MONTH FROM calendar_date)::INTEGER AS month_number,

    TO_CHAR(calendar_date, 'Month') AS month_name,

    EXTRACT(QUARTER FROM calendar_date)::INTEGER AS quarter_number,

    'Q' || EXTRACT(QUARTER FROM calendar_date)::INTEGER AS quarter_name,

    EXTRACT(YEAR FROM calendar_date)::INTEGER AS year_number,

    EXTRACT(WEEK FROM calendar_date)::INTEGER AS week_number,

    EXTRACT(ISODOW FROM calendar_date)::INTEGER AS day_of_week,

    TO_CHAR(calendar_date, 'Day') AS day_name,

    EXTRACT(ISODOW FROM calendar_date)::INTEGER IN (6, 7)
        AS is_weekend

FROM generate_series(
    DATE '2025-01-01',
    DATE '2027-12-31',
    INTERVAL '1 day'
) AS calendar(calendar_date)

ON CONFLICT (date_key) DO NOTHING;