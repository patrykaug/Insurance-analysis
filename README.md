
# Insurance Portfolio Analysis — SQL

## Project Overview

This project presents basic SQL analysis of a synthetic insurance portfolio using PostgreSQL.

The database was designed as a relational model containing information about insurance policies, claims, policy and claim payments, insured companies, insurers, insurance products, geographical locations, and exchange rates.

The main objective of the project is to demonstrate practical SQL skills in the context of insurance data, including data modelling, aggregation, multi-table joins, Common Table Expressions (CTEs), window functions, currency conversion, and insurance-related KPIs.

> **Note:** All data used in this project is synthetic and does not represent real customers, insurers, policies, or claims.

---

## Database Structure

The database consists of the following tables:

| Table | Description |
|---|---|
| `policies` | Insurance policy information including premium, currency, dates, insured, insurer and product |
| `policy_payments` | Initial and additional premium payment positions |
| `claims` | Claims associated with insurance policies |
| `claim_payments` | Initial and additional claim payment positions |
| `insured_info` | Information about insured companies |
| `insurer_info` | Information about insurers |
| `insurance_products` | Insurance products and business lines |
| `locations` | Geographical information related to policies and insureds |
| `exchange_rates` | Daily synthetic exchange rates used to convert financial values to GBP |

Primary and foreign keys are used to maintain relationships between the tables.

The complete database structure can be recreated using:

`database creation.sql`

---

## Data

The dataset contains approximately:

- 3,500 insurance policies
- 2,350 claims
- 5,600 policy payment records
- 5,500 claim payment records
- 1,500 insured companies
- multiple insurance products, insurers and geographical locations

The portfolio contains policies denominated in multiple currencies.

To make financial values comparable, daily exchange rates are used to convert amounts into GBP.

All data and exchange rates were synthetically generated for portfolio purposes.

---

## SQL Analysis

### 1. Premium Analysis

Total premium is calculated by insurance product and converted into GBP using the exchange rate corresponding to the payment date.

This analysis demonstrates:

- multi-table joins
- aggregation
- currency conversion
- grouping and sorting

---

### 2. Geographic Portfolio Analysis

The portfolio is analysed by country to identify the geographical distribution of policies and premium.

Metrics include:

- number of policies
- total premium
- premium converted to GBP

`COUNT(DISTINCT policy_id)` is used to prevent duplicated policy counts caused by joining policies with multiple payment records.

---

### 3. Claim Frequency

Claim frequency is calculated by insurance product and country as:

**Claim Frequency = Number of Claims / Number of Policies**

The analysis uses `COUNT(DISTINCT ...)` to account for different table granularities.

---

### 4. Loss Ratio

Loss ratio is calculated at policy level as:

**Loss Ratio = Incurred Claims / Written Premium**

Claims are first aggregated at policy level using a Common Table Expression (CTE).

This prevents duplication of premium values for policies associated with multiple claims.

---

### 5. Largest Claims by Insurance Product

The largest claims within each insurance product are identified using a window function.

The analysis uses:

- `RANK()`
- `PARTITION BY`
- CTEs

This allows claims to be ranked independently within each insurance product.

---

### 6. Claim Payment Development

Claim payments are analysed chronologically using a running total.

The analysis uses:

```sql
SUM(payment_amount) OVER (
    PARTITION BY claim_id
    ORDER BY payment_date
)
```

This makes it possible to observe how the total amount paid for an individual claim develops over time.

---

### 7. Year-over-Year Premium Analysis

Annual premium development is analysed using the `LAG()` window function.

This allows the current year's premium to be compared with the previous year's premium within the same portfolio segment.


## Tools

- PostgreSQL
- Supabase
- SQL
- GitHub
