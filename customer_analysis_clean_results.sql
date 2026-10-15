-- =====================================================
-- Customer Churn Analysis (MySQL 8+) - CLEANED DATA VERSION
-- Table: telco (load clean.csv into it; one row per customer, no Customer ID column)
-- Churn flag: `Churn Label` = 'Yes' means the customer left
-- =====================================================

CREATE DATABASE IF NOT EXISTS customer_churn;
USE customer_churn;

-- NOTE: the results under each query were computed on clean.csv (7043 rows).
-- Run the queries in MySQL and you should get the same numbers.

-- Q0: Preview the data
SELECT *
FROM telco
LIMIT 10;
-- RESULT: first 10 customers (44 columns, too wide to show here)

-- Q1: Data quality check (rows vs unique rows)
-- Customer ID was removed in the cleaned data, so we compare total rows vs fully-distinct rows
SELECT COUNT(*) AS total_rows,
       (SELECT COUNT(*) FROM (SELECT DISTINCT * FROM telco) AS d) AS unique_rows
FROM telco;
-- RESULT:
-- total_rows unique_rows
--       7043        7043

-- Q2: Overall churn rate (baseline for every other result)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN `Churn Label` = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco;
-- RESULT:
-- total_customers churned_customers churn_rate
--            7043              1869      26.54

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
-- RESULT:
--       Contract total_customers churned_customers churn_rate
-- Month-to-Month            3610              1655      45.84
--       One Year            1550               166      10.71
--       Two Year            1883                48       2.55

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
-- RESULT:
--  Payment Method total_customers churned_customers churn_rate
--    Mailed Check             385               142      36.88
-- Bank Withdrawal            3909              1329       34.0
--     Credit Card            2749               398      14.48

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
-- RESULT:
-- Internet Type total_customers churned_customers churn_rate
--   Fiber Optic            3035              1236      40.72
--         Cable             830               213      25.66
--           DSL            1652               307      18.58
--          NULL            1526               113        7.4

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
-- RESULT:
-- Premium Tech Support customers churn_rate_pct
--                   No      3473          41.64
--                  Yes      2044          15.17

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
-- RESULT:
-- tenure_group total_customers churned_customers churn_rate
--  0-12 Months            2186              1037      47.44
-- 13-24 Months            1024               294      28.71
-- 25-48 Months            1594               325      20.39
--   49+ Months            2239               213       9.51

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
-- RESULT:
--    charge_group total_customers churned_customers churn_rate
--    High (60-90)            2392               807      33.74
-- Very High (90+)            1744               573      32.86
--  Medium (30-60)            1254               327      26.08
--       Low (<30)            1653               162        9.8

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
-- RESULT:
-- age_group total_customers churned_customers churn_rate
--       60+            1782               631      35.41
--     30-44            1943               475      24.45
--     45-59            1917               459      23.94
--  Under 30            1401               304       21.7

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
-- RESULT:
-- Gender total_customers churned_customers churn_rate
-- Female            3488               939      26.92
--   Male            3555               930      26.16

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
-- RESULT:
--                              Churn Reason churned_customers percentage_of_churn
--             Competitor had better devices               313               16.75
--              Competitor made better offer               311               16.64
--                Attitude of support person               220               11.77
--                                Don't know               130                6.96
--              Competitor offered more data               117                6.26
-- Competitor offered higher download speeds               100                5.35
--              Attitude of service provider                94                5.03
--                            Price too high                78                4.17
--                   Product dissatisfaction                77                4.12
--                       Network reliability                72                3.85
--                     Long distance charges                64                3.42
--                   Service dissatisfaction                63                3.37
--                                     Moved                46                2.46
--                        Extra data charges                39                2.09
--                 Limited range of services                37                1.98
--          Poor expertise of online support                31                1.66
--  Lack of affordable download/upload speed                30                1.61
--           Lack of self-service on Website                29                1.55
--           Poor expertise of phone support                12                0.64
--                                  Deceased                 6                0.32

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
-- RESULT:
-- monthly_revenue_lost total_monthly_revenue pct_revenue_lost
--            139130.85              456116.6             30.5

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
-- RESULT:
--       Contract Internet Type customers churn_rate risk_rank
-- Month-to-Month   Fiber Optic      1882      58.82         1
-- Month-to-Month         Cable       423      44.21         2
-- Month-to-Month           DSL       787      33.29         3
-- Month-to-Month          NULL       518      19.11         4
--       One Year   Fiber Optic       587       16.7         5
--       One Year         Cable       191      12.04         6
--       One Year           DSL       406       8.87         7
--       Two Year   Fiber Optic       566       5.48         8
--       One Year          NULL       366       2.46         9
--       Two Year           DSL       459       1.96        10
--       Two Year         Cable       216       1.39        11
--       Two Year          NULL       642       0.78        12

-- Q14: Active high-risk customers (rule-based list)
-- Month-to-month + fiber + first year + no tech support, still active
-- (no Customer ID in cleaned data, so City and Age are shown to help identify rows)
SELECT
    City,
    Age,
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
-- RESULT:
--                   City Age Tenure in Months       Contract Internet Service Monthly Charge
--              Richgrove  57                3 Month-to-Month              Yes         107.95
--            Santa Maria  34                5 Month-to-Month              Yes          105.3
--          San Francisco  62               12 Month-to-Month              Yes          105.3
--              San Diego  32                9 Month-to-Month              Yes          102.6
--         Olympic Valley  49                2 Month-to-Month              Yes          100.2
--        Manhattan Beach  30                9 Month-to-Month              Yes           99.3
--           Copperopolis  40                2 Month-to-Month              Yes           97.1
-- Palos Verdes Peninsula  40                5 Month-to-Month              Yes          96.55
--            Diamond Bar  22                7 Month-to-Month              Yes           96.2
--        Rough And Ready  52                3 Month-to-Month              Yes           95.4
--                 Julian  35               10 Month-to-Month              Yes          95.25
--                 Downey  51                3 Month-to-Month              Yes           94.9
--                  Essex  26                8 Month-to-Month              Yes          94.75
--            Chula Vista  38               12 Month-to-Month              Yes          94.55
--            Santa Maria  55                7 Month-to-Month              Yes           94.1
--              Crestline  40                9 Month-to-Month              Yes          94.05
--                 Perris  39                6 Month-to-Month              Yes          94.05
--               El Monte  58                3 Month-to-Month              Yes           92.0
--          Pacific Grove  39                2 Month-to-Month              Yes          91.45
--       Santa Fe Springs  36                2 Month-to-Month              Yes          91.15
--                Daggett  55                2 Month-to-Month              Yes          90.75
--                 Fresno  56                6 Month-to-Month              Yes          90.75
--               Temecula  47                3 Month-to-Month              Yes           90.7
--          Clipper Mills  43                4 Month-to-Month              Yes          90.65
--                Lemoore  44               11 Month-to-Month              Yes           90.6
--                Fortuna  22                3 Month-to-Month              Yes           90.4
--               Temecula  19                2 Month-to-Month              Yes          90.35
--           Newbury Park  33                5 Month-to-Month              Yes          90.35
--            Davis Creek  66                9 Month-to-Month              Yes           90.1
--              San Diego  20                1 Month-to-Month              Yes           90.1
--               Whittier  38                3 Month-to-Month              Yes          89.85
--      Belvedere Tiburon  23                6 Month-to-Month              Yes          89.75
--                 Irvine  60               12 Month-to-Month              Yes          89.55
--     Desert Hot Springs  38                1 Month-to-Month              Yes          89.35
--               Glendale  49                1 Month-to-Month              Yes          89.25
--               Torrance  60               11 Month-to-Month              Yes           89.2
--                Gardena  52               12 Month-to-Month              Yes          89.15
--                Oakland  33                5 Month-to-Month              Yes          89.15
--                   Anza  45               10 Month-to-Month              Yes          88.85
--              San Diego  23                9 Month-to-Month              Yes           88.4
--                 Orinda  49                9 Month-to-Month              Yes          88.05
--             Santa Cruz  80                8 Month-to-Month              Yes           87.1
--              San Lucas  33               12 Month-to-Month              Yes          86.55
--            Canoga Park  31               11 Month-to-Month              Yes           86.2
--                Menifee  63                4 Month-to-Month              Yes          86.05
--            San Joaquin  54                3 Month-to-Month              Yes          86.05
--            Winterhaven  20               10 Month-to-Month              Yes          85.95
--                Salinas  28                6 Month-to-Month              Yes          85.95
--                Escalon  21                3 Month-to-Month              Yes           85.7
--              Miramonte  62                8 Month-to-Month              Yes          85.65

-- Q15: How many active customers match the Q14 rules (Q14 shows only 50)
SELECT COUNT(*) AS high_risk_active_customers
FROM telco
WHERE `Churn Label` = 'No'
  AND Contract = 'Month-to-Month'
  AND `Internet Type` = 'Fiber Optic'
  AND `Tenure in Months` <= 12
  AND `Premium Tech Support` = 'No';
-- RESULT:
-- high_risk_active_customers
--                        196
