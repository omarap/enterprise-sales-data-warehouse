from sqlalchemy import text

from etl.config import get_engine


def main() -> None:
    """Test the PostgreSQL connection."""

    engine = get_engine()

    with engine.connect() as connection:
        result = connection.execute(
            text("SELECT current_database(), version();")
        )

        database_name, postgres_version = result.fetchone()

        print(f"Database: {database_name}")
        print(f"PostgreSQL: {postgres_version}")


if __name__ == "__main__":
    main()