"""
Load transformed data into PostgreSQL staging and warehouse tables.
"""

import pandas as pd
from sqlalchemy import text

from etl.config import get_engine


STAGING_TABLES = {
    "customers": "customers",
    "products": "products",
    "locations": "locations",
    "sales": "sales",
}


def truncate_staging_tables() -> None:
    """Clear staging tables before a full refresh."""

    engine = get_engine()

    with engine.begin() as connection:
        connection.execute(
            text(
                """
                TRUNCATE TABLE
                    staging.sales,
                    staging.products,
                    staging.customers,
                    staging.locations;
                """
            )
        )


def load_dataframe(
    dataframe: pd.DataFrame,
    table_name: str,
) -> None:
    """Load a DataFrame into a staging table."""

    engine = get_engine()

    dataframe.to_sql(
        name=table_name,
        schema="staging",
        con=engine,
        if_exists="append",
        index=False,
        method="multi",
    )


def load_staging(
    dataframes: dict[str, pd.DataFrame],
) -> None:
    """Load all transformed datasets into staging."""

    truncate_staging_tables()

    for dataset_name, dataframe in dataframes.items():
        load_dataframe(
            dataframe,
            STAGING_TABLES[dataset_name],
        )


def refresh_warehouse() -> None:
    """
    Clear warehouse transaction data and dimensions
    before reloading the current dataset.
    """

    engine = get_engine()

    with engine.begin() as connection:
        connection.execute(
            text(
                """
                TRUNCATE TABLE
                    warehouse.fact_sales,
                    warehouse.dim_customer,
                    warehouse.dim_product,
                    warehouse.dim_location
                RESTART IDENTITY CASCADE;
                """
            )
        )


def load_locations() -> None:
    """Load locations from staging into the warehouse."""

    engine = get_engine()

    query = """
        INSERT INTO warehouse.dim_location (
            location_id,
            country,
            region,
            city,
            postal_code
        )
        SELECT
            location_id,
            country,
            region,
            city,
            postal_code
        FROM staging.locations
        ORDER BY location_id;
    """

    with engine.begin() as connection:
        connection.execute(text(query))


def load_products() -> None:
    """Load products from staging into the warehouse."""

    engine = get_engine()

    query = """
        INSERT INTO warehouse.dim_product (
            product_id,
            product_name,
            category,
            subcategory,
            unit_cost,
            unit_price
        )
        SELECT
            product_id,
            product_name,
            category,
            subcategory,
            unit_cost,
            unit_price
        FROM staging.products
        ORDER BY product_id;
    """

    with engine.begin() as connection:
        connection.execute(text(query))


def load_customers() -> None:
    """Load customers and resolve location surrogate keys."""

    engine = get_engine()

    query = """
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
            c.customer_id,
            c.first_name,
            c.last_name,
            c.email,
            c.phone,
            c.gender,
            c.date_of_birth,
            c.registration_date,
            l.location_key
        FROM staging.customers AS c
        JOIN warehouse.dim_location AS l
            ON l.location_id = c.location_id
        ORDER BY c.customer_id;
    """

    with engine.begin() as connection:
        connection.execute(text(query))


def load_sales() -> None:
    """Load sales facts using warehouse surrogate keys."""

    engine = get_engine()

    query = """
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
            s.sale_id,

            c.customer_key,

            p.product_key,

            l.location_key,

            d.date_key,

            s.quantity,

            p.unit_price,

            s.discount_amount,

            s.quantity * p.unit_price
                AS gross_sales_amount,

            (
                s.quantity * p.unit_price
                - s.discount_amount
            ) AS net_sales_amount,

            s.quantity * p.unit_cost
                AS cost_amount,

            (
                s.quantity * p.unit_price
                - s.discount_amount
                - s.quantity * p.unit_cost
            ) AS profit_amount

        FROM staging.sales AS s

        JOIN warehouse.dim_customer AS c
            ON c.customer_id = s.customer_id

        JOIN warehouse.dim_product AS p
            ON p.product_id = s.product_id

        JOIN warehouse.dim_location AS l
            ON l.location_id = s.location_id

        JOIN warehouse.dim_date AS d
            ON d.full_date = s.sale_date

        ORDER BY s.sale_id;
    """

    with engine.begin() as connection:
        connection.execute(text(query))


def load_warehouse() -> None:
    """Execute the complete warehouse loading process."""

    refresh_warehouse()

    load_locations()
    load_products()
    load_customers()
    load_sales()