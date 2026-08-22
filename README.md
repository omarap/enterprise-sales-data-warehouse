# Enterprise Sales Data Warehouse

A production-style enterprise sales data warehouse built with PostgreSQL, advanced SQL, Python ETL, and Power BI.

The project demonstrates practical database design, data warehousing, data quality, analytics, ETL development, and SQL performance optimization.

---

## Project Status

🟢 **Stage 2 — Staging Layer Complete**

The PostgreSQL database foundation and staging layer have been implemented and tested successfully.

---

## Overview

The goal of this project is to design and implement an enterprise-style sales data warehouse capable of supporting business reporting, analytics, and decision-making.

The system will ingest raw sales data, validate and transform it, load it into a dimensional data warehouse, and provide analytical queries and business intelligence reporting.

---

## Business Problem

Businesses often have sales data spread across different operational systems and source files.

This can make it difficult to:

- Analyze revenue trends
- Understand customer behavior
- Identify top-performing products
- Measure profitability
- Track sales growth
- Generate reliable management reports
- Maintain consistent and high-quality data

This project addresses these challenges by building a centralized sales data warehouse.

---

## Project Architecture

The planned architecture is:

```text
                 Source Data
                     │
                     ▼
              CSV / Raw Data
                     │
                     ▼
                  Staging
                     │
              Data Validation
                     │
              Data Transformation
                     │
                     ▼
             Data Warehouse
                     │
              ┌──────┴──────┐
              │             │
         Fact Tables    Dimensions
              │             │
              └──────┬──────┘
                     │
                     ▼
              Analytics Layer
                     │
                     ▼
                 Power BI