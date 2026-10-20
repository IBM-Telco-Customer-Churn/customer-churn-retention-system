Customer Churn Intelligence & Retention System

An end-to-end data science and machine learning pipeline designed to analyze customer retention, identify drivers of churn, and predict high-risk subscribers for proactive business intervention.

Project Overview

Customer attrition (churn) directly impacts recurring revenue and increases acquisition costs. This project delivers an end-to-end analytical and predictive solution using subscription data (telco.csv). It integrates SQL database queries, exploratory data analysis (EDA), machine learning classification algorithms, experiment tracking via MLflow, and an interactive business dashboard.

Repository Structure

The repository contains the following core files and assets:

telco.csv: Raw dataset containing customer demographics, subscription details, and status.

clean.csv: Cleaned and preprocessed dataset ready for analysis and modeling.

cleaning.ipynb: Data cleaning notebook (handling missing values, data types, and formatting).

customer_analysis_clean_results.sql: SQL queries and analytics assessing churn patterns and key segments.

eda churn.ipynb: Exploratory Data Analysis notebook visualizing feature relationships and churn drivers.

dashboard-1.ipynb: Interactive Plotly / Dash dashboard notebook for business stakeholders.

mlflow.txt: Logs, metrics, and tracking notes for machine learning experiments.

Tech Stack & Skills

Data Querying & SQL: MySQL / PostgreSQL / SQLite (customer_analysis_clean_results.sql)

Data Manipulation & Cleaning: Python, Pandas, NumPy (cleaning.ipynb)

Exploratory Data Analysis (EDA): Matplotlib, Seaborn, Plotly (eda churn.ipynb)

Machine Learning: Scikit-Learn (Logistic Regression, KNN, Decision Tree, SVM)

Dashboarding & Business Intelligence: Plotly / Dash (dashboard-1.ipynb)

Experiment Tracking: MLflow (mlflow.txt)

Analytical & Modeling Workflow

1. Data Cleaning & Preparation (cleaning.ipynb)

Addressed missing values and adjusted inconsistent feature types.

Standardized numerical columns and encoded categorical attributes.

Generated clean.csv for downstream SQL querying and ML modeling.

2. SQL Analysis (customer_analysis_clean_results.sql)

Evaluated overall customer retention rates.

Segmented churn by contract types (Month-to-Month vs. Annual), payment methods, and charges.

Identified high-value churn risks across customer profiles.

3. Exploratory Data Analysis (eda churn.ipynb)

Visualized correlations between tenure, monthly charges, contract duration, and churn likelihood.

Identified primary churn triggers: short tenure, month-to-month contracts, and higher monthly charges without bundled services.

4. Predictive Modeling & Evaluation

Evaluated multiple classification models to predict customer churn:

Logistic Regression (Baseline model for interpretability)

K-Nearest Neighbors (KNN) (Instance-based classification)

Decision Tree (Non-linear rule extraction)

Support Vector Machine (SVM) (Optimal boundary separation)

Performance metrics (Accuracy, Precision, Recall, F1-Score, ROC-AUC) were tracked and documented in mlflow.txt.

5. Interactive Business Dashboard (dashboard-1.ipynb)

Built a Plotly/Dash interactive interface featuring:

KPI Summary Cards: Total Customers, Active Users, Overall Churn Rate.

Segment Breakdown: Visual churn distribution by contract, payment type, and tenure.

High-Risk List: Filterable view of customers flagged for immediate retention campaigns.

Key Business Recommendations

Contract Incentives: Offer targeted discounts to convert high-risk month-to-month subscribers into 1-year or 2-year commitments.

Early Tenure Engagement: Implement structured onboarding programs for new customers in their first 1–6 months.

Targeted Promotions: Focus retention discounts on customers with high monthly charges showing early warning indicators of churn.

How to Run the Project

Clone the repository:

git clone https://github.com/YourUsername/customer-churn-retention-system.git
cd customer-churn-retention-system


Install required dependencies:

pip install pandas numpy scikit-learn matplotlib seaborn plotly dash mlflow


Explore the Notebooks:

Run cleaning.ipynb to inspect data preprocessing steps.

Run eda churn.ipynb to view statistical charts and feature distributions.

Launch dashboard-1.ipynb to interact with the business dashboard.

Contributors

Ahmed Ali Mohammed (@AhmedAli56u)

Basma Tarek (@basmatarek18)

Eng-KyrillosAdel (@Eng-KyrillosAdel)

Mohamed Gamal (@MohamedGamal6545)

Eng Mohamed Elsaid Sarhan (@mohamedooopp78-rgb)

mosawaf10 (@mosawaf10)
