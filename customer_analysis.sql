-- =====================================================
-- Customer Churn Analysis (MySQL 8+)
-- Table: telco (one row per customer)
-- Churn flag: `Churn Label` = 'Yes' means the customer left
-- =====================================================

CREATE DATABASE IF NOT EXISTS customer_churn;
USE customer_churn;

-- Q0: Preview the data
SELECT *
FROM telco
LIMIT 10;

-- Q1: Data quality check (rows vs unique customers)
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT `Customer ID`) AS unique_customers
FROM telco;

-- Q2: Overall churn rate (baseline for every other result)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco;

-- Q3: Churn by contract type
SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY Contract
ORDER BY churn_rate DESC;

-- Q4: Churn by payment method
SELECT
    `Payment Method`,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY `Payment Method`
ORDER BY churn_rate DESC;

-- Q5: Churn by internet type (plan)
SELECT
    `Internet Type`,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY `Internet Type`
ORDER BY churn_rate DESC;

-- Q6: Churn by premium tech support (internet customers only)
SELECT
    `Premium Tech Support`,
    COUNT(*) AS customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM telco
WHERE `Internet Service` <> 'No'
GROUP BY `Premium Tech Support`
ORDER BY churn_rate_pct DESC;

-- Q7: Churn by tenure group (shown in time order)
SELECT
    CASE
        WHEN `Tenure in Months` <= 12 THEN '0-12 Months'
        WHEN `Tenure in Months` <= 24 THEN '13-24 Months'
        WHEN `Tenure in Months` <= 48 THEN '25-48 Months'
        ELSE '49+ Months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY tenure_group
ORDER BY MIN(`Tenure in Months`);

-- Q8: Churn by monthly charge group
SELECT
    CASE
        WHEN `Monthly Charge` < 30 THEN 'Low (<30)'
        WHEN `Monthly Charge` < 60 THEN 'Medium (30-60)'
        WHEN `Monthly Charge` < 90 THEN 'High (60-90)'
        ELSE 'Very High (90+)'
    END AS charge_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY charge_group
ORDER BY churn_rate DESC;

-- Q9: Churn by age group
SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age < 45 THEN '30-44'
        WHEN Age < 60 THEN '45-59'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY age_group
ORDER BY churn_rate DESC;

-- Q10: Churn by gender
SELECT
    Gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco
GROUP BY Gender
ORDER BY churn_rate DESC;

-- Q11: Why customers left (churn reasons)
SELECT
    `Churn Reason`,
    COUNT(*) AS churned_customers,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM telco WHERE `Churn Label` = 'Yes'),
        2
    ) AS percentage_of_churn
FROM telco
WHERE `Churn Label` = 'Yes'
GROUP BY `Churn Reason`
ORDER BY churned_customers DESC;

-- Q12: Revenue lost to churn
SELECT
    ROUND(SUM(CASE WHEN `Churn Label` = 'Yes' THEN `Monthly Charge` END), 2) AS monthly_revenue_lost,
    ROUND(SUM(`Monthly Charge`), 2) AS total_monthly_revenue,
    ROUND(
        100 * SUM(CASE WHEN `Churn Label` = 'Yes' THEN `Monthly Charge` END)
        / SUM(`Monthly Charge`),
        2
    ) AS pct_revenue_lost
FROM telco;

-- Q13: Riskiest segments ranked (window function)
SELECT
    Contract,
    `Internet Type`,
    COUNT(*) AS customers,
    ROUND(100 * AVG(`Churn Label` = 'Yes'), 2) AS churn_rate,
    RANK() OVER (ORDER BY AVG(`Churn Label` = 'Yes') DESC) AS risk_rank
FROM telco
GROUP BY Contract, `Internet Type`
ORDER BY risk_rank;

-- Q14: Active high-risk customers (rule-based list)
-- Month-to-month + fiber + first year + no tech support, still active
SELECT
    `Customer ID`,
    `Tenure in Months`,
    Contract,
    `Internet Service`,
    `Monthly Charge`
FROM telco
WHERE `Churn Label` = 'No'
  AND Contract = 'Month-to-Month'
  AND `Internet Type` = 'Fiber Optic'
  AND `Tenure in Months` <= 12
  AND `Premium Tech Support` = 'No'
ORDER BY `Monthly Charge` DESC
LIMIT 50;

-- Q15: How many active customers match the Q14 rules (Q14 shows only 50)
SELECT COUNT(*) AS high_risk_active_customers
FROM telco
WHERE `Churn Label` = 'No'
  AND Contract = 'Month-to-Month'
  AND `Internet Type` = 'Fiber Optic'
  AND `Tenure in Months` <= 12
  AND `Premium Tech Support` = 'No';