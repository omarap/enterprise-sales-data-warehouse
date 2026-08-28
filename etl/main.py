"""
Main ETL pipeline.
"""

from etl.extract import extract_all
from etl.load import load_staging, load_warehouse
from etl.transform import (
    transform_customers,
    transform_locations,
    transform_products,
    transform_sales,
)
from etl.validate import (
    validate_customers,
    validate_locations,
    validate_products,
    validate_sales,
)


def main() -> None:
    """Run the complete ETL pipeline."""

    print("=" * 60)
    print("ENTERPRISE SALES DATA WAREHOUSE ETL")
    print("=" * 60)

    # ----------------------------------------------------------
    # Extract
    # ----------------------------------------------------------

    print("\n[1/5] Extracting source data...")

    raw_data = extract_all()

    # ----------------------------------------------------------
    # Transform
    # ----------------------------------------------------------

    print("[2/5] Transforming source data...")

    customers = transform_customers(
        raw_data["customers"]
    )

    products = transform_products(
        raw_data["products"]
    )

    locations = transform_locations(
        raw_data["locations"]
    )

    sales = transform_sales(
        raw_data["sales"],
        products,
    )

    # ----------------------------------------------------------
    # Validate
    # ----------------------------------------------------------

    print("[3/5] Validating data...")

    validate_customers(customers)
    validate_products(products)
    validate_locations(locations)

    validate_sales(
        sales,
        customers,
        products,
        locations,
    )

    transformed_data = {
        "customers": customers,
        "products": products,
        "locations": locations,
        "sales": sales,
    }

    # ----------------------------------------------------------
    # Load staging
    # ----------------------------------------------------------

    print("[4/5] Loading staging tables...")

    load_staging(transformed_data)

    # ----------------------------------------------------------
    # Load warehouse
    # ----------------------------------------------------------

    print("[5/5] Loading warehouse...")

    load_warehouse()

    print("\nETL pipeline completed successfully.")
    print("=" * 60)


if __name__ == "__main__":
    main()