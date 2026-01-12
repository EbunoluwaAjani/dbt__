{% docs __overview__ %}

# Webshop Analytics Overview

This solution transforms raw webshop data into **clean, reliable, and analytics-ready dbt models** that support **order fulfillment reporting**, **customer behavior and session analysis**, and **pricing and discount insights**, in line with the assessment requirements.

---

## Purpose

The purpose of this solution is to enable the business to answer key analytical questions related to **order processing performance**, **customer behavior**, and **pricing effectiveness**.

Specifically, the following assessment questions are addressed:

- **Order Fulfillment Performance**
  - What is the average time between *placed* and *shipped* orders, aggregated weekly?

- **Customer Behavior & Session Analysis**
  - What is the cart value of items added during a customer’s **most recent session**, for customers who placed an order during that same session?

- **Pricing & Discounts**
  - What is the total amount of discount granted each week?

---

## High-Level Data Flow

The project follows a layered dbt architecture that incrementally refines raw source data into business-ready analytics models.

### 1. Source Layer (`public`)

Data is ingested from the webshop source system into the `public` schema. The source tables include:

- **customer** — customer profile and contact information
- **orders** — order-level transactional data
- **order_item** — product-level details per order
- **event** — user behavior and session activity
- **product** — product catalog and discount attributes

Source freshness tests are applied to key fact tables to detect delayed or missing upstream data.

---

### 2. Staging Layer

Raw source tables are standardized into staging models in the `default` schema.
This layer focuses on:

- Renaming columns to consistent naming conventions
- Preserving source-level granularity
- Applying basic schema validation and accepted-values tests

Staging models serve as a clean and reliable foundation for downstream transformations.

---

### 3. Analytics Models

#### Dimensions

- **`dim_customer`**
  Curated customer dimension containing validated email addresses, unique customer identifiers, and lifecycle timestamps.
  Includes tests for uniqueness, nullability, and email format validation.

- **`dim_product`**
  Product dimension containing product identifiers, descriptive attributes, and pricing information used for sales and discount analysis.

---

#### Fact Models

- **`fct_orders`**
  Order-level fact table capturing order status timestamps, customer relationships, and monetary values.
  Referential integrity is enforced against customer and product dimensions.

- **`fct_events`**
  Event-level fact table capturing user actions and session-related activity.
  Includes accepted-values tests for event types and freshness checks to ensure timely data availability.

---

## Business Logic Highlights

Key business rules and validations applied across the project include:

- Enforcing unique customer and product identifiers
- Validating customer email formats using regular expressions
- Ensuring critical timestamps (e.g. `created_at`, `modified_at`) are always present
- Maintaining referential integrity between fact and dimension models
- Applying source freshness checks on orders and events data
- Standardizing pricing, discount, and cart value calculations
- Preventing negative cart values and unrealistic fulfillment durations

These rules ensure consistent, trustworthy, and explainable analytical outputs.

---

## Final Outputs

The final mart-level models produced for reporting and analysis are:

- **`order_fulfillment`** — weekly analysis of order processing time from placement to shipment
- **`mart_sales`** — weekly sales and discount aggregation
- **`mart_cart_value`** — cart value from the most recent session for customers who placed an order during that session

---

## Input Schema

The diagram below illustrates the structure of the source data used in this project:

![input schema](assets/schema.png)

---

## Navigating the Documentation

- **Sources** — raw input tables and freshness checks
- **Staging Models** — cleaned and standardized source data
- **Dimensions** — descriptive business entities
- **Fact Models** — transactional and event-level data
- **Mart Models** — business-ready outputs for reporting

Each section includes documented models with relevant data quality tests applied.

{% enddocs %}
