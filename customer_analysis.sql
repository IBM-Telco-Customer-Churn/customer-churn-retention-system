CREATE DATABASE customer_churn;
USE customer_churn;
SELECT *
FROM telco
LIMIT 10;
SELECT COUNT(*) AS total_customers
FROM telco;


SELECT COUNT(*) AS churned_customers
FROM telco
WHERE `Churn Label` = 'Yes';

SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco;

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
ORDER BY churn_rate DESC;

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