"""
Utility functions used by the ETL pipeline.
"""

from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = PROJECT_ROOT / "data"


def get_data_path(filename: str) -> Path:
    """Return the full path to a file in the data directory."""

    return DATA_DIR / filename