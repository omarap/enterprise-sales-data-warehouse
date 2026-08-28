"""
Transform and validate source datasets.
"""

import pandas as pd


def clean_columns(df: pd.DataFrame) -> pd.DataFrame:
    """
    Standardize column names.
    """

    result = df.copy()

    result.columns = (
        result.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    return result


def transform_customers(df: pd.DataFrame) -> pd.DataFrame:
    """Clean customer data."""

    result = clean_columns(df)

    date_columns = [
        "date_of_birth",
        "registration_date",
    ]

    for column in date_columns:
        result[column] = pd.to_datetime(
            result[column],
            errors="coerce",
        )

    result["email"] = result["email"].str.strip().str.lower()

    result["first_name"] = result["first_name"].str.strip()

    result["last_name"] = result["last_name"].str.strip()

    return result


def transform_products(df: pd.DataFrame) -> pd.DataFrame:
    """Clean product data."""

    result = clean_columns(df)

    numeric_columns = [
        "unit_cost",
        "unit_price",
    ]

    for column in numeric_columns:
        result[column] = pd.to_numeric(
            result[column],
            errors="coerce",
        )

    result["product_name"] = result["product_name"].str.strip()

    result["category"] = result["category"].str.strip()

    result["subcategory"] = result["subcategory"].str.strip()

    return result


def transform_locations(df: pd.DataFrame) -> pd.DataFrame:
    """Clean location data."""

    result = clean_columns(df)

    text_columns = [
        "country",
        "region",
        "city",
        "postal_code",
    ]

    for column in text_columns:
        result[column] = result[column].astype("string").str.strip()

    return result


def transform_sales(
    df: pd.DataFrame,
    products: pd.DataFrame,
) -> pd.DataFrame:
    """Clean sales data and calculate sales amount."""

    result = clean_columns(df)

    result["sale_date"] = pd.to_datetime(
        result["sale_date"],
        errors="coerce",
    )

    numeric_columns = [
        "quantity",
        "discount_amount",
    ]

    for column in numeric_columns:
        result[column] = pd.to_numeric(
            result[column],
            errors="coerce",
        )

    product_prices = products[
        ["product_id", "unit_price"]
    ].rename(
        columns={"unit_price": "product_unit_price"}
    )

    result = result.merge(
        product_prices,
        on="product_id",
        how="left",
    )

    result["sales_amount"] = (
        result["quantity"] * result["product_unit_price"]
        - result["discount_amount"]
    )

    result = result.rename(
        columns={
            "product_unit_price": "unit_price",
        }
    )

    return result