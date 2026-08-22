/*
    Project: Enterprise Sales Data Warehouse
    File: dim_location.sql

    Purpose:
        Geographic location dimension.

    Grain:
        One row represents one location.
*/

CREATE TABLE IF NOT EXISTS warehouse.dim_location (
    location_key BIGINT GENERATED ALWAYS AS IDENTITY,
    location_id INTEGER NOT NULL,

    country VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_dim_location
        PRIMARY KEY (location_key),

    CONSTRAINT uq_dim_location_location_id
        UNIQUE (location_id)
);