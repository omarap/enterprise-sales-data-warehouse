/*
    Project: Enterprise Sales Data Warehouse
    File: 03_create_staging_tables.sql

    Purpose:
        Create staging tables used to temporarily store
        raw source data before it is transformed and loaded
        into the dimensional warehouse.

    Schema:
        staging
*/

-- ============================================================
-- 1. Customers
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.customers (
    customer_id INTEGER,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255),
    phone VARCHAR(50),
    gender VARCHAR(20),
    date_of_birth DATE,
    registration_date DATE,
    location_id INTEGER
);


-- ============================================================
-- 2. Products
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.products (
    product_id INTEGER,
    product_name VARCHAR(255),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    unit_cost NUMERIC(12, 2),
    unit_price NUMERIC(12, 2)
);


-- ============================================================
-- 3. Locations
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.locations (
    location_id INTEGER,
    country VARCHAR(100),
    region VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20)
);


-- ============================================================
-- 4. Sales
-- ============================================================

CREATE TABLE IF NOT EXISTS staging.sales (
    sale_id BIGINT,
    customer_id INTEGER,
    product_id INTEGER,
    location_id INTEGER,
    sale_date DATE,
    quantity INTEGER,
    unit_price NUMERIC(12, 2),
    discount_amount NUMERIC(12, 2),
    sales_amount NUMERIC(14, 2)
);