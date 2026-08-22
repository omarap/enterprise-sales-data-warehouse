/*
    Project: Enterprise Sales Data Warehouse
    File: dim_customer.sql

    Purpose:
        Customer dimension for the sales data warehouse.

    Grain:
        One row represents one customer.
*/

CREATE TABLE IF NOT EXISTS warehouse.dim_customer (
    customer_key BIGINT GENERATED ALWAYS AS IDENTITY,
    customer_id INTEGER NOT NULL,

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,

    email VARCHAR(255),
    phone VARCHAR(50),

    gender VARCHAR(20),
    date_of_birth DATE,
    registration_date DATE,

    location_key BIGINT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_dim_customer
        PRIMARY KEY (customer_key),

    CONSTRAINT uq_dim_customer_customer_id
        UNIQUE (customer_id)
);