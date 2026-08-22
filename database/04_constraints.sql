/*
    Project: Enterprise Sales Data Warehouse
    File: 04_constraints.sql

    Purpose:
        Add data-quality constraints to staging tables.

    Note:
        Staging tables are intentionally more permissive than
        warehouse tables because source data may require cleaning
        before it can be loaded into the warehouse.
*/

-- ============================================================
-- Customers
-- ============================================================

ALTER TABLE staging.customers
    ADD CONSTRAINT chk_customer_gender
    CHECK (
        gender IS NULL
        OR gender IN ('Male', 'Female', 'Other')
    );


-- ============================================================
-- Products
-- ============================================================

ALTER TABLE staging.products
    ADD CONSTRAINT chk_product_unit_cost
    CHECK (
        unit_cost IS NULL
        OR unit_cost >= 0
    );

ALTER TABLE staging.products
    ADD CONSTRAINT chk_product_unit_price
    CHECK (
        unit_price IS NULL
        OR unit_price >= 0
    );


-- ============================================================
-- Sales
-- ============================================================

ALTER TABLE staging.sales
    ADD CONSTRAINT chk_sales_quantity
    CHECK (
        quantity IS NULL
        OR quantity > 0
    );

ALTER TABLE staging.sales
    ADD CONSTRAINT chk_sales_unit_price
    CHECK (
        unit_price IS NULL
        OR unit_price >= 0
    );

ALTER TABLE staging.sales
    ADD CONSTRAINT chk_sales_discount
    CHECK (
        discount_amount IS NULL
        OR discount_amount >= 0
    );

ALTER TABLE staging.sales
    ADD CONSTRAINT chk_sales_amount
    CHECK (
        sales_amount IS NULL
        OR sales_amount >= 0
    );