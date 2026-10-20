Customer Churn Intelligence & Retention System

An end-to-end data science and machine learning pipeline built to analyze customer retention, identify drivers of churn, and predict high-risk subscribers for proactive business intervention.

📌 Project Overview

Customer attrition (churn) directly impacts recurring revenue and increases acquisition costs. This project delivers an end-to-end analytical and predictive solution using telecom subscription data (telco.csv).

It integrates:

🗄️ SQL Database Queries (customer_analysis_clean_results.sql)

🧹 Data Cleaning & Preprocessing (cleaning.ipynb & clean.csv)

🔍 Exploratory Data Analysis (eda churn.ipynb)

🤖 Machine Learning Classification (Logistic Regression, KNN, Decision Tree, SVM)

📊 Interactive Business Dashboard (dashboard-1.ipynb)

🧪 Experiment Tracking (mlflow.txt)

📁 Repository Structure

customer-churn-retention-system/
│
├── telco.csv                            # Raw dataset
├── clean.csv                            # Cleaned and processed dataset
├── cleaning.ipynb                       # Data cleaning notebook
├── eda churn.ipynb                      # Exploratory Data Analysis notebook
├── customer_analysis_clean_results.sql  # SQL queries and analytics
├── dashboard-1.ipynb                    # Interactive Plotly/Dash notebook
└── mlflow.txt                           # Experiment tracking logs


🛠️ Tech Stack & Skills

Data Querying & SQL: MySQL / PostgreSQL / SQLite

Data Manipulation & Cleaning: Python, Pandas, NumPy

Exploratory Data Analysis (EDA): Matplotlib, Seaborn, Plotly

Machine Learning: Scikit-Learn (Logistic Regression, KNN, Decision Trees, SVM)

Dashboarding & Business Intelligence: Plotly / Dash

Experiment Tracking: MLflow

🔄 Analytical & Modeling Workflow

1. Data Cleaning & Preparation (cleaning.ipynb)

Handled missing values and adjusted inconsistent data types.

Standardized numerical features and encoded categorical variables.

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

Logistic Regression: Baseline model for interpretability.

K-Nearest Neighbors (KNN): Distance-based instance classification.

Decision Tree: Non-linear rule extraction.

Support Vector Machine (SVM): Optimal boundary separation.

Performance metrics (Accuracy, Precision, Recall, F1-Score, ROC-AUC) were tracked and logged using MLflow (mlflow.txt).

5. Interactive Dashboard (dashboard-1.ipynb)

Built a Plotly / Dash application features:

Key Business Performance Metrics (KPIs).

Churn breakdown by customer segment and subscription plan.

Filterable table of high-risk customers requiring immediate intervention.

👥 Project Team & Contributors

👨‍💻 Ahmed Ali Mohammed - @AhmedAli56u

👩‍💻 Basma Tarek - @basmatarek18

👨‍💻 Eng-KyrillosAdel - @Eng-KyrillosAdel

👨‍💻 Mohamed Gamal - @MohamedGamal6545

👨‍💻 Eng Mohamed Elsaid Sarhan - @mohamedooopp78-rgb

👨‍💻 mosawaf10 - @mosawaf10

🔗 Repository Link

GitHub Repository: https://github.com/IBM-Telco-Customer-Churn/customer-churn-retention-system
