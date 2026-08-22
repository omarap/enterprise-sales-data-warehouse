/*
    Project: Enterprise Sales Data Warehouse
    File: dim_date.sql

    Purpose:
        Date dimension used for time-based analysis.

    Grain:
        One row represents one calendar date.
*/

CREATE TABLE IF NOT EXISTS warehouse.dim_date (
    date_key INTEGER NOT NULL,

    full_date DATE NOT NULL,

    day_number INTEGER NOT NULL,
    month_number INTEGER NOT NULL,
    month_name VARCHAR(20) NOT NULL,

    quarter_number INTEGER NOT NULL,
    quarter_name VARCHAR(10) NOT NULL,

    year_number INTEGER NOT NULL,

    week_number INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL,
    day_name VARCHAR(20) NOT NULL,

    is_weekend BOOLEAN NOT NULL,

    CONSTRAINT pk_dim_date
        PRIMARY KEY (date_key),

    CONSTRAINT uq_dim_date_full_date
        UNIQUE (full_date)
);