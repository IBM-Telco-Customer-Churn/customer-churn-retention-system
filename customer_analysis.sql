-- =====================================================
-- Customer Churn Analysis (MySQL 8+)
-- Source: telco_raw.csv -> cleaning.ipynb -> clean_churn.csv
-- Table: telco (one row per customer, 7,043 rows)
-- Churn flag: churn = 1 means the customer left (0 = stayed)
-- Cleaned-data conventions (from cleaning.ipynb):
--   * columns are snake_case
--   * senior_citizen is 'Yes'/'No'
--   * 'No internet service' / 'No phone service' were replaced by 'No'
--   * blank total_charges (11 new customers, tenure = 0) were set to 0
-- =====================================================

CREATE DATABASE IF NOT EXISTS customer_churn;
USE customer_churn;

-- Setup: create the table and load clean_churn.csv
DROP TABLE IF EXISTS telco;
CREATE TABLE telco (
    customer_id        VARCHAR(20) PRIMARY KEY,
    gender             VARCHAR(10),
    senior_citizen     VARCHAR(3),
    partner            VARCHAR(3),
    dependents         VARCHAR(3),
    tenure             INT,
    phone_service      VARCHAR(3),
    multiple_lines     VARCHAR(3),
    internet_service   VARCHAR(20),
    online_security    VARCHAR(3),
    online_backup      VARCHAR(3),
    device_protection  VARCHAR(3),
    tech_support       VARCHAR(3),
    streaming_tv       VARCHAR(3),
    streaming_movies   VARCHAR(3),
    contract           VARCHAR(20),
    paperless_billing  VARCHAR(3),
    payment_method     VARCHAR(30),
    monthly_charges    DECIMAL(8,2),
    total_charges      DECIMAL(10,2),
    churn              TINYINT
);

-- Update the path to where clean_churn.csv is saved.
-- (Or use the Table Data Import Wizard in MySQL Workbench.)
LOAD DATA LOCAL INFILE 'clean_churn.csv'
INTO TABLE telco
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Q0: Preview the data
SELECT *
FROM telco
LIMIT 10;

-- Q1: Data quality check (rows vs unique customers)
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM telco;

-- Q2: Overall churn rate (baseline for every other result)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco;

-- Q3: Churn by contract type
SELECT
    contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY contract
ORDER BY churn_rate DESC;

-- Q4: Churn by payment method
SELECT
    payment_method,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY payment_method
ORDER BY churn_rate DESC;

-- Q5: Churn by internet service (DSL / Fiber optic / No)
-- (the original "Internet Type" is the same as internet_service in this data)
SELECT
    internet_service,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY internet_service
ORDER BY churn_rate DESC;

-- Q6: Churn by tech support (internet customers only)
SELECT
    tech_support,
    COUNT(*) AS customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco
WHERE internet_service <> 'No'
GROUP BY tech_support
ORDER BY churn_rate_pct DESC;

-- Q7: Churn by tenure group (shown in time order; same bins as eda.ipynb)
SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 Months'
        WHEN tenure <= 24 THEN '13-24 Months'
        WHEN tenure <= 48 THEN '25-48 Months'
        ELSE '49+ Months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY tenure_group
ORDER BY MIN(tenure);

-- Q8: Churn by monthly charge group
SELECT
    CASE
        WHEN monthly_charges < 30 THEN 'Low (<30)'
        WHEN monthly_charges < 60 THEN 'Medium (30-60)'
        WHEN monthly_charges < 90 THEN 'High (60-90)'
        ELSE 'Very High (90+)'
    END AS charge_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY charge_group
ORDER BY churn_rate DESC;

-- Q9: Churn by age group -> CHANGED: this data has no exact age,
-- only senior_citizen (Yes/No), so we compare seniors vs non-seniors
SELECT
    senior_citizen,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY senior_citizen
ORDER BY churn_rate DESC;

-- Q10: Churn by gender
SELECT
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY gender
ORDER BY churn_rate DESC;

-- Q11: Why customers left (churn reasons) -> CHANGED: this data has no
-- churn reason column, so this query now shows WHO the churners are:
-- each contract type's share of all churners (matches eda.ipynb section 8)
SELECT
    contract,
    COUNT(*) AS churned_customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM telco WHERE churn = 1),
        2
    ) AS percentage_of_churn
FROM telco
WHERE churn = 1
GROUP BY contract
ORDER BY churned_customers DESC;

-- Q12: Revenue lost to churn
SELECT
    ROUND(SUM(CASE WHEN churn = 1 THEN monthly_charges END), 2) AS monthly_revenue_lost,
    ROUND(SUM(monthly_charges), 2) AS total_monthly_revenue,
    ROUND(
        100 * SUM(CASE WHEN churn = 1 THEN monthly_charges END)
        / SUM(monthly_charges),
        2
    ) AS pct_revenue_lost
FROM telco;

-- Q13: Riskiest segments ranked (window function)
SELECT
    contract,
    internet_service,
    COUNT(*) AS customers,
    ROUND(100 * AVG(churn), 2) AS churn_rate,
    RANK() OVER (ORDER BY AVG(churn) DESC) AS risk_rank
FROM telco
GROUP BY contract, internet_service
ORDER BY risk_rank;

-- Q14: Active high-risk customers (rule-based list)
-- Month-to-month + fiber + first year + no tech support, still active
SELECT
    customer_id,
    tenure,
    contract,
    internet_service,
    monthly_charges
FROM telco
WHERE churn = 0
  AND contract = 'Month-to-month'
  AND internet_service = 'Fiber optic'
  AND tenure <= 12
  AND tech_support = 'No'
ORDER BY monthly_charges DESC
LIMIT 50;

-- Q15: How many active customers match the Q14 rules (Q14 shows only 50)
SELECT COUNT(*) AS high_risk_active_customers
FROM telco
WHERE churn = 0
  AND contract = 'Month-to-month'
  AND internet_service = 'Fiber optic'
  AND tenure <= 12
  AND tech_support = 'No';
