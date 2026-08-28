# Enterprise Sales Data Warehouse

A production-style enterprise sales data warehouse built with **PostgreSQL, advanced SQL, Python ETL, and Power BI**.

The project demonstrates practical database design, dimensional data warehousing, data quality, ETL development, business analytics, and SQL performance optimization.

---

## Project Status

🟢 **Stage 1 — Database Foundation Complete**

* PostgreSQL database creation
* Database organization
* Schema creation
* Initial project structure

🟢 **Stage 2 — Staging Layer Complete**

The PostgreSQL staging layer has been implemented and tested successfully.

* Customer staging table
* Product staging table
* Location staging table
* Sales staging table
* Data-quality constraints

🟢 **Stage 3 — Data Warehouse Complete**

The dimensional data warehouse has been implemented using a star-schema architecture.

Completed:

* Customer dimension
* Product dimension
* Location dimension
* Date dimension
* Sales fact table
* Star schema
* Surrogate keys
* Primary keys
* Foreign keys
* Data-quality constraints
* Date dimension population
* Sample warehouse data
* Referential-integrity validation
* Revenue and profitability queries

🟢 **Stage 4 — ETL Pipeline Complete**

A Python-based ETL pipeline has been implemented to extract, transform, validate, and load source data into PostgreSQL.

Completed:

* Python ETL pipeline
* CSV extraction
* Pandas transformations
* Data-quality validation
* PostgreSQL staging load
* Dimension loading
* Fact table loading
* Surrogate-key resolution
* Transaction-based warehouse loading
* Repeatable full-refresh pipeline
* Environment-based database configuration

---

## Overview

The goal of this project is to design and implement an enterprise-style sales data warehouse capable of supporting business reporting, analytics, and decision-making.

The system ingests raw sales data from CSV files, performs data cleaning and validation using Python and Pandas, loads the validated data into PostgreSQL staging tables, and then transforms the data into a dimensional data warehouse.

The warehouse is designed to support analytical SQL queries, business intelligence reporting, profitability analysis, customer analysis, product performance analysis, and future predictive analytics.

---

## Business Problem

Businesses often have sales data spread across different operational systems and source files.

This can make it difficult to:

* Analyze revenue trends
* Understand customer behavior
* Identify top-performing products
* Measure profitability
* Track sales growth
* Generate reliable management reports
* Maintain consistent and high-quality data
* Optimize analytical queries

This project addresses these challenges by building a centralized sales data warehouse with a structured ETL pipeline and analytical layer.

---

## Technologies

### Database

* PostgreSQL
* SQL
* SQL constraints
* Foreign keys
* Indexes
* Views
* Stored procedures
* SQL functions

### ETL & Data Processing

* Python
* Pandas
* SQLAlchemy
* psycopg
* python-dotenv

### Business Intelligence

* Power BI

### Development Tools

* Visual Studio Code
* pgAdmin
* Git
* GitHub

---

## Project Architecture

The current ETL and warehouse architecture is:

```text
                    Source Data
                         │
                         ▼
                     CSV Files
                         │
                         ▼
                      Extract
                         │
                         ▼
                     Transform
                         │
                         ▼
                      Validate
                         │
                         ▼
                PostgreSQL Staging
                         │
                         ▼
                  Data Warehouse
                         │
              ┌──────────┴──────────┐
              │                     │
        Fact Tables          Dimension Tables
              │                     │
              └──────────┬──────────┘
                         │
                         ▼
                  Analytics Layer
                         │
                         ▼
                      Power BI
```

---

## ETL Pipeline

The Stage 4 ETL pipeline follows this process:

```text
CSV Files
    │
    ▼
Extract
    │
    ▼
Pandas DataFrames
    │
    ▼
Transform
    │
    ├── Clean column names
    ├── Standardize text
    ├── Convert data types
    ├── Calculate sales amounts
    └── Prepare warehouse-ready data
    │
    ▼
Validate
    │
    ├── Required columns
    ├── Duplicate records
    ├── Invalid quantities
    ├── Negative values
    └── Referential integrity
    │
    ▼
PostgreSQL Staging
    │
    ▼
Warehouse Loading
    │
    ├── Dimensions
    └── Fact table
    │
    ▼
Analytics
```

---

## Database Design

The warehouse uses a **star schema** designed for analytical workloads.

### Dimension Tables

#### `warehouse.dim_customer`

Stores customer information.

Key attributes include:

* Customer ID
* Customer name
* Email
* Phone
* Gender
* Date of birth
* Registration date
* Location

#### `warehouse.dim_product`

Stores product information.

Key attributes include:

* Product ID
* Product name
* Category
* Subcategory
* Unit cost
* Unit price

#### `warehouse.dim_location`

Stores geographical information.

Key attributes include:

* Location ID
* Country
* Region
* City
* Postal code

#### `warehouse.dim_date`

Provides calendar-based analytical attributes.

Key attributes include:

* Date key
* Full date
* Day
* Month
* Quarter
* Year
* Week
* Day of week
* Weekend indicator

### Fact Table

#### `warehouse.fact_sales`

Stores measurable sales transactions.

Key measures include:

* Quantity
* Unit price
* Discount amount
* Gross sales amount
* Net sales amount
* Cost amount
* Profit amount

---

## Star Schema

The warehouse follows this structure:

```text
                    dim_customer
                         │
                         │
                         ▼
dim_location ─────── fact_sales ─────── dim_product
                         │
                         │
                         ▼
                     dim_date
```

The fact table contains foreign keys to the relevant dimensions and stores measurable business events.

---

## Staging Layer

The staging layer provides an intermediate area between source files and the warehouse.

```text
staging
│
├── customers
├── products
├── locations
└── sales
```

The staging layer allows the ETL process to separate:

1. Raw source extraction
2. Data transformation
3. Data validation
4. Warehouse loading

This separation makes the pipeline easier to maintain and troubleshoot.

---

## Data Quality

Data validation is performed before data is loaded into the warehouse.

The ETL pipeline checks for:

* Missing required columns
* Duplicate customer IDs
* Duplicate product IDs
* Duplicate location IDs
* Duplicate sale IDs
* Invalid quantities
* Negative discounts
* Negative product prices
* Missing customer references
* Missing product references
* Missing location references

Invalid data causes the ETL process to stop rather than silently loading bad records into the warehouse.

---

## Surrogate Keys

The warehouse uses surrogate keys for dimensional tables.

For example:

```text
Source customer_id
        │
        ▼
dim_customer
        │
        ▼
customer_key
```

The source/business identifier remains available as `customer_id`, while the warehouse uses `customer_key` to establish relationships with the fact table.

This approach provides flexibility for future Slowly Changing Dimension implementations.

---

## Transaction Management

Warehouse loading uses database transactions to help maintain data consistency.

The general process is:

```text
BEGIN TRANSACTION
       │
       ├── Load locations
       ├── Load products
       ├── Load customers
       └── Load sales
       │
       ▼
     COMMIT
```

If an error occurs during a transactional operation, the affected transaction can be rolled back instead of leaving partially loaded data.

---

## ETL Configuration

Database connection details are stored in environment variables rather than hard-coded into Python source code.

Example:

```text
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sales_dw
DB_USER=postgres
DB_PASSWORD=your_password
```

Sensitive credentials are stored in `.env`.

The `.env` file is excluded from Git using `.gitignore`.

A `.env.example` file is provided to document the required configuration without exposing credentials.

---

## Project Structure

```text
enterprise-sales-data-warehouse/
│
├── .env
├── .env.example
├── .gitignore
├── README.md
├── requirements.txt
│
├── database/
│   ├── 01_create_database.sql
│   ├── 02_create_schemas.sql
│   ├── 03_create_staging_tables.sql
│   └── 04_constraints.sql
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   ├── locations.csv
│   └── sales.csv
│
├── etl/
│   ├── __init__.py
│   ├── config.py
│   ├── extract.py
│   ├── transform.py
│   ├── validate.py
│   ├── load.py
│   ├── main.py
│   ├── test_connection.py
│   └── utils.py
│
└── warehouse/
    │
    ├── dimensions/
    │   ├── dim_customer.sql
    │   ├── dim_product.sql
    │   ├── dim_location.sql
    │   ├── dim_date.sql
    │   └── populate_dim_date.sql
    │
    └── facts/
        └── fact_sales.sql
```

---

## Running the ETL Pipeline

### 1. Create the virtual environment

```bash
python -m venv .venv
```

### 2. Activate the environment

Windows:

```bash
.venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure the database

Create a `.env` file:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sales_dw
DB_USER=postgres
DB_PASSWORD=your_password
```

### 5. Test the PostgreSQL connection

```bash
python -m etl.test_connection
```

### 6. Run the ETL pipeline

```bash
python -m etl.main
```

Expected output:

```text
============================================================
ENTERPRISE SALES DATA WAREHOUSE ETL
============================================================

[1/5] Extracting source data...
[2/5] Transforming source data...
[3/5] Validating data...
[4/5] Loading staging tables...
[5/5] Loading warehouse...

ETL pipeline completed successfully.
============================================================
```

---

## SQL Capabilities Demonstrated

The project is designed to demonstrate practical SQL skills including:

* Complex joins
* Aggregations
* GROUP BY
* HAVING
* Common Table Expressions (CTEs)
* Subqueries
* Window functions
* Ranking
* Running totals
* Revenue analysis
* Profitability analysis
* Customer segmentation
* Cohort analysis
* Growth analysis
* Date-based analysis
* Query optimization
* Execution-plan analysis

Advanced analytical SQL will be expanded in the next project stage.

---

## Performance Optimization

The project will include SQL performance optimization using:

* Appropriate indexes
* Query refactoring
* CTE optimization
* Join optimization
* `EXPLAIN`
* `EXPLAIN ANALYZE`
* Execution-plan comparison
* Index usage analysis

The objective is to understand not only how to write SQL queries, but also how PostgreSQL executes and optimizes them.

---

## Business Analytics

The warehouse will support analysis such as:

### Revenue Analysis

* Total revenue
* Monthly revenue
* Quarterly revenue
* Year-over-year growth
* Running revenue totals

### Customer Analysis

* Top customers
* Customer lifetime value
* Customer purchase frequency
* Customer segmentation
* Customer retention

### Product Analysis

* Best-selling products
* Product revenue
* Product profitability
* Category performance
* Units sold

### Profitability Analysis

* Gross revenue
* Net revenue
* Cost
* Profit
* Profit margin
* Most profitable products

---

## Future Improvements

Planned future stages include:

* Advanced analytical SQL
* Customer cohort analysis
* Customer segmentation
* Revenue growth analysis
* SQL performance optimization
* Query execution-plan analysis
* Incremental ETL processing
* Slowly Changing Dimensions
* ETL logging
* Automated data-quality reporting
* Automated testing
* Power BI dashboard
* Additional business intelligence metrics
* Deployment and production-style orchestration

---

## Project Goals

The primary goal of this project is to demonstrate practical skills required for modern SQL and data engineering roles.

The project focuses on:

```text
Database Design
       │
       ▼
PostgreSQL
       │
       ▼
Data Warehousing
       │
       ▼
ETL Development
       │
       ▼
Data Quality
       │
       ▼
Advanced SQL
       │
       ▼
Performance Optimization
       │
       ▼
Business Analytics
       │
       ▼
Power BI
```

---

## Author

**Patrick Omara**

SQL Developer | Database Developer | Data & AI Engineer

GitHub: `https://github.com/omarap`

LinkedIn: `https://linkedin.com/in/patrick-omara-463815127`
