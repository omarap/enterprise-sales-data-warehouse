"""
Data-quality validation for the ETL pipeline.
"""

import pandas as pd


def validate_customers(df: pd.DataFrame) -> None:
    """Validate customer records."""

    required_columns = {
        "customer_id",
        "first_name",
        "last_name",
        "email",
        "location_id",
    }

    missing_columns = required_columns - set(df.columns)

    if missing_columns:
        raise ValueError(
            f"Customer data is missing columns: {missing_columns}"
        )

    if df["customer_id"].duplicated().any():
        raise ValueError("Duplicate customer_id values found.")

    if df["customer_id"].isna().any():
        raise ValueError("customer_id cannot contain NULL values.")


def validate_products(df: pd.DataFrame) -> None:
    """Validate product records."""

    required_columns = {
        "product_id",
        "product_name",
        "unit_cost",
        "unit_price",
    }

    missing_columns = required_columns - set(df.columns)

    if missing_columns:
        raise ValueError(
            f"Product data is missing columns: {missing_columns}"
        )

    if df["product_id"].duplicated().any():
        raise ValueError("Duplicate product_id values found.")

    if (df["unit_cost"] < 0).any():
        raise ValueError("Product unit_cost cannot be negative.")

    if (df["unit_price"] < 0).any():
        raise ValueError("Product unit_price cannot be negative.")


def validate_locations(df: pd.DataFrame) -> None:
    """Validate location records."""

    required_columns = {
        "location_id",
        "country",
        "city",
    }

    missing_columns = required_columns - set(df.columns)

    if missing_columns:
        raise ValueError(
            f"Location data is missing columns: {missing_columns}"
        )

    if df["location_id"].duplicated().any():
        raise ValueError("Duplicate location_id values found.")


def validate_sales(
    sales: pd.DataFrame,
    customers: pd.DataFrame,
    products: pd.DataFrame,
    locations: pd.DataFrame,
) -> None:
    """Validate sales records and their references."""

    required_columns = {
        "sale_id",
        "customer_id",
        "product_id",
        "location_id",
        "sale_date",
        "quantity",
        "discount_amount",
    }

    missing_columns = required_columns - set(sales.columns)

    if missing_columns:
        raise ValueError(
            f"Sales data is missing columns: {missing_columns}"
        )

    if sales["sale_id"].duplicated().any():
        raise ValueError("Duplicate sale_id values found.")

    if (sales["quantity"] <= 0).any():
        raise ValueError("Sales quantity must be greater than zero.")

    if (sales["discount_amount"] < 0).any():
        raise ValueError("Discount amount cannot be negative.")

    customer_ids = set(customers["customer_id"])
    product_ids = set(products["product_id"])
    location_ids = set(locations["location_id"])

    missing_customers = (
        set(sales["customer_id"]) - customer_ids
    )

    missing_products = (
        set(sales["product_id"]) - product_ids
    )

    missing_locations = (
        set(sales["location_id"]) - location_ids
    )

    if missing_customers:
        raise ValueError(
            f"Sales reference unknown customers: {missing_customers}"
        )

    if missing_products:
        raise ValueError(
            f"Sales reference unknown products: {missing_products}"
        )

    if missing_locations:
        raise ValueError(
            f"Sales reference unknown locations: {missing_locations}"
        )