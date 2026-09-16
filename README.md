# Statistical Modelling of Transaction Value and Geographical Differences in Online Retail Sales

This repository contains an **Applied Statistical Modelling** project that investigates the factors associated with online retail transaction values and examines whether transaction behaviour differs across geographical markets.

The analysis uses the **Online Retail dataset** from the UCI Machine Learning Repository, containing transactional data from a UK-based non-store retailer between December 2010 and December 2011. The dataset includes information such as invoice details, product information, quantities, unit prices, transaction dates, customer identifiers, and countries.

## Project Objectives

The main objectives of this study are to:

- Analyse the distribution and characteristics of online retail transaction values.
- Investigate the relationship between **Transaction Value**, **Quantity**, and **Unit Price**.
- Compare transaction values between the **United Kingdom** and other countries.
- Examine geographical differences across selected countries.
- Evaluate the impact of quantity, unit price, country group, and month on transaction value.
- Build and evaluate a multiple regression model.
- Test statistical assumptions and assess model limitations.

## Dataset

**Dataset:** Online Retail Dataset  
**Source:** UCI Machine Learning Repository

[View the UCI Online Retail Dataset](https://uci-ics-mlr-prod.aws.uci.edu/dataset/352/online%2Bretail?utm_source=chatgpt.com)

The original dataset contains **541,909 transactional observations** and includes variables related to invoices, products, quantities, prices, customers, transaction dates, and countries.

## Data Preparation

The dataset was cleaned and prepared using reproducible statistical analysis techniques.

The preprocessing process includes:

- Checking and handling missing values.
- Removing duplicate records.
- Filtering cancelled transactions.
- Removing zero or invalid quantities.
- Filtering negative prices.
- Creating a new **TransactionValue** variable.
- Converting transaction dates into an appropriate date-time format.
- Creating additional **Year**, **Month**, and **Day** variables.
- Creating geographical groups for the **United Kingdom** and **Other Countries**.
- Randomly sampling **10,000 observations** for statistical analysis using a fixed random seed.



## Statistical Methods

The project applies a range of descriptive, inferential, and modelling techniques, including:

- Descriptive statistics
- Exploratory Data Analysis
- Logarithmic transformation
- Pearson correlation analysis
- Welch two-sample t-test
- One-way ANOVA
- Welch ANOVA
- Pairwise Welch t-tests with Bonferroni correction
- Tukey HSD post-hoc analysis
- Multiple linear regression
- Shapiro-Wilk normality testing
- Breusch-Pagan heteroscedasticity testing
- Residual diagnostics
- Confidence interval analysis
- Actual vs predicted value analysis

## Research Question

The primary research question is:

> **Is there a significant difference in transaction value between transactions originating from the United Kingdom and those from other countries, after considering quantity, unit price, and month?**

The analysis uses a regression-based hypothesis testing framework to examine the relationship between geographical location and log-transformed transaction value.

## Key Findings

The analysis identified substantial variation in transaction values across geographical markets.

Key results include:

- The multiple regression model achieved an **R² of approximately 0.9641**, indicating that the included predictors explain a large proportion of variation in log-transformed transaction value.
- **Quantity** and **Unit Price** showed statistically significant positive relationships with transaction value.
- The geographical grouping variable showed a statistically significant relationship with transaction value after controlling for quantity, unit price, and month.
- The Welch two-sample t-test found a statistically significant difference between the mean log transaction values of UK and non-UK transactions.
- Country-level analysis using Welch ANOVA identified statistically significant differences among the selected countries.
- Pearson correlation analysis found a moderate positive relationship between quantity and transaction value.

These findings should be interpreted alongside the model diagnostics and the fact that TransactionValue is derived from Quantity and UnitPrice.

## Model Validation and Diagnostics

Statistical assumption testing identified several limitations:

- The log-transformed transaction values did not fully satisfy normality assumptions.
- Regression residuals showed evidence of non-normality.
- The Breusch-Pagan test indicated heteroscedasticity.
- Diagnostic plots suggested the presence of influential observations and increased uncertainty for extreme transaction values.

These results indicate that conventional statistical inference should be interpreted carefully and motivate the use of robust modelling approaches in future work.

## Technologies and Tools

- **R**
- **RStudio**
- **dplyr**
- Statistical modelling and regression techniques
- Hypothesis testing
- Data visualisation
- UCI Online Retail Dataset

## Project Workflow

```text
Online Retail Dataset
        │
        ▼
Data Cleaning & Preprocessing
        │
        ▼
Feature Engineering
        │
        ├── TransactionValue
        ├── Year
        ├── Month
        ├── Day
        └── CountryGroup
        │
        ▼
Exploratory Data Analysis
        │
        ▼
Statistical Hypothesis Testing
        │
        ├── t-Test
        ├── ANOVA
        ├── Welch ANOVA
        └── Post-Hoc Tests
        │
        ▼
Multiple Regression Modelling
        │
        ▼
Assumption Testing & Diagnostics
        │
        ├── Normality Testing
        ├── Residual Analysis
        └── Heteroscedasticity Testing
        │
        ▼
Results & Business Insights
```

## Limitations

The study has several limitations:

- A random sample of **10,000 observations** was used instead of the complete dataset.
- The dataset contains a substantial number of missing `CustomerID` values.
- Normality assumptions were not fully satisfied.
- Heteroscedasticity was detected in the regression model.
- TransactionValue is mathematically derived from Quantity and UnitPrice, which affects interpretation of their statistical relationship.



## Future Improvements

Possible future enhancements include:

- Analysing the complete dataset of 541,909 transactions.
- Applying robust regression techniques.
- Exploring additional customer-level variables.
- Investigating product-level and time-based factors.
- Testing alternative transformations and statistical models.
- Validating the regression model using different samples or validation methods.



## Conclusion

This project demonstrates the application of statistical modelling techniques to a real-world online retail dataset. By combining data cleaning, exploratory analysis, hypothesis testing, regression modelling, and diagnostic evaluation, the study investigates how transaction value is associated with quantity, unit price, time, and geographical location.

The project also highlights the importance of validating statistical assumptions and interpreting model results in the context of data limitations. The findings provide a foundation for further analysis of retail transaction behaviour and geographical market differences.

## Academic Module

**Module:** B105 Applied Statistical Modelling

**Project Title:** *Statistical Modelling of Transaction Value and Geographical Differences in Online Retail Sales*