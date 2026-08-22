/*
    Project: Enterprise Sales Data Warehouse
    File: fact_sales.sql

    Purpose:
        Central sales transaction fact table.

    Grain:
        One row represents one sales transaction
        for one product purchased by one customer
        at one location on one date.
*/

CREATE TABLE IF NOT EXISTS warehouse.fact_sales (
    sales_key BIGINT GENERATED ALWAYS AS IDENTITY,

    sale_id BIGINT NOT NULL,

    customer_key BIGINT NOT NULL,
    product_key BIGINT NOT NULL,
    location_key BIGINT NOT NULL,
    date_key INTEGER NOT NULL,

    quantity INTEGER NOT NULL,

    unit_price NUMERIC(12, 2) NOT NULL,

    discount_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,

    gross_sales_amount NUMERIC(14, 2) NOT NULL,

    net_sales_amount NUMERIC(14, 2) NOT NULL,

    cost_amount NUMERIC(14, 2) NOT NULL,

    profit_amount NUMERIC(14, 2) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_fact_sales
        PRIMARY KEY (sales_key),

    CONSTRAINT uq_fact_sales_sale_id
        UNIQUE (sale_id),

    CONSTRAINT fk_fact_sales_customer
        FOREIGN KEY (customer_key)
        REFERENCES warehouse.dim_customer(customer_key),

    CONSTRAINT fk_fact_sales_product
        FOREIGN KEY (product_key)
        REFERENCES warehouse.dim_product(product_key),

    CONSTRAINT fk_fact_sales_location
        FOREIGN KEY (location_key)
        REFERENCES warehouse.dim_location(location_key),

    CONSTRAINT fk_fact_sales_date
        FOREIGN KEY (date_key)
        REFERENCES warehouse.dim_date(date_key),

    CONSTRAINT chk_fact_sales_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_fact_sales_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT chk_fact_sales_discount
        CHECK (discount_amount >= 0),

    CONSTRAINT chk_fact_sales_gross_sales
        CHECK (gross_sales_amount >= 0),

    CONSTRAINT chk_fact_sales_net_sales
        CHECK (net_sales_amount >= 0),

    CONSTRAINT chk_fact_sales_cost
        CHECK (cost_amount >= 0)
);