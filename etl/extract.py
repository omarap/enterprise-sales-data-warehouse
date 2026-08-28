"""
Extract source data from CSV files.
"""

import pandas as pd

from etl.utils import get_data_path


def extract_csv(filename: str) -> pd.DataFrame:
    """
    Read a CSV file into a Pandas DataFrame.
    """

    file_path = get_data_path(filename)

    if not file_path.exists():
        raise FileNotFoundError(
            f"Source file not found: {file_path}"
        )

    return pd.read_csv(file_path)


def extract_all() -> dict[str, pd.DataFrame]:
    """Extract all source datasets."""

    return {
        "customers": extract_csv("customers.csv"),
        "products": extract_csv("products.csv"),
        "locations": extract_csv("locations.csv"),
        "sales": extract_csv("sales.csv"),
    }