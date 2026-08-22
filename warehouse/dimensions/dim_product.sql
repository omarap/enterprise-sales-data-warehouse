/*
    Project: Enterprise Sales Data Warehouse
    File: dim_product.sql

    Purpose:
        Product dimension.

    Grain:
        One row represents one product.
*/

CREATE TABLE IF NOT EXISTS warehouse.dim_product (
    product_key BIGINT GENERATED ALWAYS AS IDENTITY,
    product_id INTEGER NOT NULL,

    product_name VARCHAR(255) NOT NULL,

    category VARCHAR(100),
    subcategory VARCHAR(100),

    unit_cost NUMERIC(12, 2) NOT NULL,
    unit_price NUMERIC(12, 2) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_dim_product
        PRIMARY KEY (product_key),

    CONSTRAINT uq_dim_product_product_id
        UNIQUE (product_id),

    CONSTRAINT chk_dim_product_unit_cost
        CHECK (unit_cost >= 0),

    CONSTRAINT chk_dim_product_unit_price
        CHECK (unit_price >= 0)
);