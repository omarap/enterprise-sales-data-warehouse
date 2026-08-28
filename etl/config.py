"""
Database configuration for the ETL pipeline.
"""

import os

from dotenv import load_dotenv
from sqlalchemy import create_engine


load_dotenv()


DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "sales_dw")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD")


def get_database_url() -> str:
    """Build the PostgreSQL SQLAlchemy connection URL."""

    if not DB_PASSWORD:
        raise ValueError(
            "DB_PASSWORD is not configured. "
            "Set it in the .env file."
        )

    return (
        f"postgresql+psycopg://"
        f"{DB_USER}:{DB_PASSWORD}@"
        f"{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )


def get_engine():
    """Create and return a SQLAlchemy database engine."""

    return create_engine(
        get_database_url(),
        pool_pre_ping=True,
    )