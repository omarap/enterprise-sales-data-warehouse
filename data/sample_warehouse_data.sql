/*
    Sample warehouse data
    Used for Stage 3 validation.
*/

-- ============================================================
-- Locations
-- ============================================================

INSERT INTO warehouse.dim_location (
    location_id,
    country,
    region,
    city,
    postal_code
)
VALUES
    (1, 'Uganda', 'Central', 'Kampala', '256'),
    (2, 'Kenya', 'Nairobi', 'Nairobi', '00100'),
    (3, 'Rwanda', 'Kigali', 'Kigali', '00000'),
    (4, 'Tanzania', 'Dar es Salaam', 'Dar es Salaam', '11101');

    -- ============================================================
-- Products
-- ============================================================

INSERT INTO warehouse.dim_product (
    product_id,
    product_name,
    category,
    subcategory,
    unit_cost,
    unit_price
)
VALUES
    (101, 'Business Laptop', 'Electronics', 'Computers', 650.00, 950.00),
    (102, 'Wireless Mouse', 'Electronics', 'Accessories', 12.00, 25.00),
    (103, 'Office Monitor', 'Electronics', 'Monitors', 180.00, 275.00),
    (104, 'Office Chair', 'Furniture', 'Chairs', 90.00, 160.00),
    (105, 'Mechanical Keyboard', 'Electronics', 'Accessories', 45.00, 85.00);

-- ============================================================
-- Customers
-- ============================================================

INSERT INTO warehouse.dim_customer (
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    gender,
    date_of_birth,
    registration_date,
    location_key
)
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    gender,
    date_of_birth,
    registration_date,
    location_key
FROM (
    VALUES
        (
            1001,
            'Patrick',
            'Okello',
            'patrick.okello@example.com',
            '+256700000001',
            'Male',
            DATE '1992-05-12',
            DATE '2024-01-15',
            1::BIGINT
        ),
        (
            1002,
            'Sarah',
            'Achieng',
            'sarah.achieng@example.com',
            '+254700000002',
            'Female',
            DATE '1990-08-21',
            DATE '2024-02-10',
            2::BIGINT
        ),
        (
            1003,
            'David',
            'Mugisha',
            'david.mugisha@example.com',
            '+250700000003',
            'Male',
            DATE '1988-03-18',
            DATE '2024-03-05',
            3::BIGINT
        ),
        (
            1004,
            'Amina',
            'Juma',
            'amina.juma@example.com',
            '+255700000004',
            'Female',
            DATE '1995-11-02',
            DATE '2024-04-20',
            4::BIGINT
        ),
        (
            1005,
            'John',
            'Kato',
            'john.kato@example.com',
            '+256700000005',
            'Male',
            DATE '1985-07-09',
            DATE '2024-05-11',
            1::BIGINT
        )
) AS customers (
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    gender,
    date_of_birth,
    registration_date,
    location_key
);

-- ============================================================
-- Sales fact records
-- ============================================================

INSERT INTO warehouse.fact_sales (
    sale_id,
    customer_key,
    product_key,
    location_key,
    date_key,
    quantity,
    unit_price,
    discount_amount,
    gross_sales_amount,
    net_sales_amount,
    cost_amount,
    profit_amount
)
SELECT
    sales.sale_id,
    customer.customer_key,
    product.product_key,
    location.location_key,
    date_dim.date_key,
    sales.quantity,
    product.unit_price,
    sales.discount_amount,

    sales.quantity * product.unit_price
        AS gross_sales_amount,

    (sales.quantity * product.unit_price)
        - sales.discount_amount
        AS net_sales_amount,

    sales.quantity * product.unit_cost
        AS cost_amount,

    (
        (sales.quantity * product.unit_price)
        - sales.discount_amount
        - (sales.quantity * product.unit_cost)
    ) AS profit_amount

FROM (
    VALUES
        (5001, 1001, 101, 1, DATE '2025-01-15', 1, 50.00),
        (5002, 1002, 102, 2, DATE '2025-01-20', 3, 0.00),
        (5003, 1003, 103, 3, DATE '2025-02-05', 2, 25.00),
        (5004, 1004, 104, 4, DATE '2025-02-15', 1, 10.00),
        (5005, 1005, 105, 1, DATE '2025-03-10', 2, 15.00),
        (5006, 1001, 103, 1, DATE '2025-03-20', 1, 0.00),
        (5007, 1002, 101, 2, DATE '2025-04-12', 1, 75.00),
        (5008, 1003, 102, 3, DATE '2025-04-25', 5, 10.00)
) AS sales (
    sale_id,
    customer_id,
    product_id,
    location_id,
    sale_date,
    quantity,
    discount_amount
)

JOIN warehouse.dim_customer AS customer
    ON customer.customer_id = sales.customer_id

JOIN warehouse.dim_product AS product
    ON product.product_id = sales.product_id

JOIN warehouse.dim_location AS location
    ON location.location_id = sales.location_id

JOIN warehouse.dim_date AS date_dim
    ON date_dim.full_date = sales.sale_date;