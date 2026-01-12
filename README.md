# Xccelerated Data Assessment – Webshop Analytics

## Overview
This project demonstrates a production-style analytics engineering approach using **SQL and dbt** to transform raw webshop data into **trusted, business-ready insights**.

The solution is designed to be:
- **Explainable** – business logic is transparent and well-documented
- **Tested** – data quality is validated at every layer
- **Scalable** – modular models that follow dbt best practices

The models directly answer the business questions outlined in the assessment and are structured to reflect how analytics engineering is applied in real client projects at Xccelerated.

## Business Use Case

This assessment is based on a fictional Xccelerated webshop that sells a playful mix of tech‑inspired products. The data model and transformations in this project are built around the webshop’s customers, orders, and product catalog.

The goal of the analytics model is to answer key business questions, including:

- **Weekly order processing time**
  Calculate the average time between when an order is placed and when it is shipped, aggregated per week.

- **Customer session value**
  Provide a list of customer emails and the total cart value from their most recent session, but only for customers who placed an order during that session.

- **Weekly discount totals**
  Determine the total amount of discount given each week.

The project uses a **staging → intermediate → mart** layering approach in dbt, ensuring clean ingestion, structured transformations, and analytics‑ready models.
---

## Tech Stack
The project is implemented using the following tools and technologies:
- SQL
- dbt
- PostgreSQL
- Git

---

## Technical Approach & Design Decisions

The solution was developed using a structured analytics engineering workflow:

1. **Source analysis**
   - Raw tables in the **public** schema were analyzed to understand data structure, relationships, and quality.

2. **Environment setup**
   - A **default** development schema was configured for dbt to isolate transformations from raw source data.

3. **Modeling approach**
   - The project follows a **layered dbt architecture** to separate concerns and keep transformations maintainable:
     - **Staging models** standardize raw source data without applying business logic
     - **Intermediate models** implement reusable transformations, facts, dimensions, and session logic
     - **Mart models** provide business-ready outputs aligned with specific analytics questions

**Key design choices**
- All joins are performed on **business-meaningful keys and timestamps**
- Session logic is centralized to avoid duplication
- Complex calculations (e.g. cart value, fulfillment time) are tested and validated

---

## Architecture

The solution follows a layered dbt architecture designed for clarity, modularity, and scalability. Each layer has a distinct purpose, ensuring that raw data is incrementally refined into analytics‑ready models.

### Architecture Diagram
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                               DATA SOURCE                                   │
│                          ┌────────────────────┐                             │
│                          │   PostgreSQL DB    │                             │
│                          │     public.*       │                             │
│                          │  (raw source data) │                             │
│                          └──────────┬─────────┘                             │
└──────────────────────────────────────┼──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                               STAGING LAYER                                 │
│       Schema: default                                                      │
│       Purpose: Light cleaning, renaming, and standardization                │
│                                                                             │
│   ┌────────────────────┐  ┌────────────────────┐  ┌────────────────────┐   │
│   │  stg_customer.sql  │  │   stg_orders.sql   │  │ stg_orderitem.sql  │   │
│   ├────────────────────┤  ├────────────────────┤  ├────────────────────┤   │
│   │   stg_events.sql   │  │  stg_product.sql   │  │        ...         │   │
│   └────────────────────┘  └────────────────────┘  └────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           INTERMEDIATE LAYER                                 │
│     Business logic, dimensional models, facts, sessions, and fulfillment    │
│                                                                             │
│   ┌────────────────────┐   ┌────────────────────┐   ┌────────────────────┐ │
│   │     DIMENSIONS     │   │        FACTS        │   │      SESSIONS      │ │
│   │────────────────────│   │────────────────────│   │────────────────────│ │
│   │ dim_customer       │   │ fct_orders         │   │ int_session         │ │
│   │ dim_product        │   │ fct_orderitem      │   │ int_session_bounds  │ │
│   │                    │   │ fct_events         │   │ int_last_session_   │ │
│   │                    │   │                    │   │ per_customer        │ │
│   │                    │   │                    │   │ int_cart_value      │ │
│   │                    │   │                    │   │ int_check_order     │ │
│   └────────────────────┘   └────────────────────┘   └────────────────────┘ │
│                                                                             │
│                         ┌────────────────────────────┐                      │
│                         │        FULFILLMENT         │                      │
│                         │────────────────────────────│                      │
│                         │ int_order_fulfillment      │                      │
│                         └────────────────────────────┘                      │
└─────────────────────────────────────────────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                                 MARTS LAYER                                 │
│                     Business-ready, analytics-focused models                │
│                                                                             │
│     ┌────────────────────┐   ┌────────────────────┐   ┌──────────────────┐ │
│     │   mart_sales       │   │ mart_cart_value     │   │ order_fulfillment│ │
│     └────────────────────┘   └────────────────────┘   └──────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                     PROJECT METADATA & DOCUMENTATION                        │
│                                                                             │
│   ┌────────────────────┐   ┌────────────────────┐   ┌────────────────────┐ │
│   │ schema.yml          │   │ sources.yml         │   │ overview.md        │ │
│   │ (tests + contracts) │   │ (source configs)    │   │ docs.md            │ │
│   └────────────────────┘   └────────────────────┘   └────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```
---

## Testing & Data Quality Strategy

Data quality is treated as a **first-class concern** in this project. Tests are intentionally applied at multiple layers to detect issues as early as possible which are also configured with store_failures: true, ensuring that failing rows are persisted for inspection.

### Staging Layer – Source Validation

- `not_null` and `unique` tests on primary keys
- Accepted values tests for enums (e.g. `order_status`, `event_type`)
- **Source freshness tests on fact tables** to detect delayed or missing upstream data

**Goal:** Prevent malformed source data from propagating downstream.

---

### Intermediate Layer – Business Logic Validation

- Referential integrity tests between facts and dimensions
- Custom generic tests for email and phone number formats
- Singular tests for invalid customer, order fulfillment logic and validation of cart value calculations (no negative values)

**Goal:** Ensure transformations reflect correct business logic.

---

### Mart Layer – Business Rule Enforcement

- No negative cart or discount totals
- Fulfillment durations must fall within realistic bounds
- Weekly aggregations validated for consistency

**Goal:** Guarantee trust in analytics consumed by stakeholders.

---

## Assumptions
- Only `ADD_PRODUCT_TO_CART` events contribute to cart value calculations
- Order status values are limited to `PLACED`, `PAID`, and `SHIPPED`
- Sessions are defined using a 30-minute inactivity window
- Phone numbers are standardized to a 10-digit format; non-numeric characters and extensions are removed, and numbers that do not resolve to exactly 10 digits are treated as invalid
- Cart values must always be non‑negative; a custom SQL test enforces this business rule
- Order fulfillment durations must fall within realistic bounds; shipments occurring more than 90 days after placement are treated as invalid and flagged by a consistency check
- Discount calculations only apply to positively priced order items; negative oi.price values (assumed to be returns or any other adjustments) are intentionally excluded to prevent distortion of weekly discount totals.


---

## Data Quality Findings & Limitations

During development, the following data quality issues were identified:

- Duplicate `product_id` values in the source product table
  → Resolved by keeping the most recently updated record

- Duplicate customer emails remain present in `dim_customer`
  → Intentionally surfaced by tests rather than silently deduplicated

- Highly imbalanced order status distribution
  (`PLACED`: 18, `PAID`: 119, `SHIPPED`: 26,089)
  → Limits the reliability of fulfillment-related metrics

These issues are documented and surfaced through dbt tests to maintain transparency.

---

## Next Steps

If extended beyond the assessment, the next steps would include:

- Integrating dbt tests into CI/CD pipelines so data quality checks run automatically on every pull request
- Extending existing incremental fact and mart models with **controlled historical backfilling** using explicit start and end date filters for selective reprocessing
  - Ensures late-arriving or corrected data can be safely reprocessed without full table refreshes
- Adding dbt exposures for BI tools to formalize downstream dependencies
- Collaborating with business stakeholders to further refine metrics, assumptions, and definitions
