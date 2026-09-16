# PACKAGES

install.packages("psych")

library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(psych)
library(car)
library(lmtest)
library(broom)

# IMPORT DATA
data <- read_excel("D:/Online Retail.xlsx")

head(data)
dim(data)
names(data)
str(data)


# DATA PREPARATION AND CLEANING

data$InvoiceNo <- as.character(data$InvoiceNo)
data$StockCode <- as.character(data$StockCode)
data$Description <- as.character(data$Description)
data$Country <- as.character(data$Country)

colSums(is.na(data))

# Remove duplicate records
data <- data[!duplicated(data), ]

# Remove cancelled invoices
data <- data %>%
  filter(!grepl("^C", InvoiceNo))

# Remove invalid quantities
data <- data %>%
  filter(Quantity > 0)

# Remove invalid prices
data <- data %>%
  filter(UnitPrice > 0)

# Create transaction value
data <- data %>%
  mutate(
    TransactionValue = Quantity * UnitPrice
  )

# Convert invoice date
data$InvoiceDate <- as.POSIXct(data$InvoiceDate)

# Create date variables
data <- data %>%
  mutate(
    Year = as.numeric(format(InvoiceDate, "%Y")),
    Month = as.numeric(format(InvoiceDate, "%m")),
    Day = as.numeric(format(InvoiceDate, "%d"))
  )

dim(data)

colSums(is.na(data))



# SAMPLING

set.seed(123)

sample_data <- data %>%
  sample_n(min(10000, nrow(data)))

dim(sample_data)



# DESCRIPTIVE STATISTICS

describe(sample_data$TransactionValue)

describe(sample_data$Quantity)

describe(sample_data$UnitPrice)

summary(sample_data$TransactionValue)

quantile(
  sample_data$TransactionValue,
  probs = c(0, 0.25, 0.50, 0.75, 1)
)



# EXPLORATORY DATA ANALYSIS

# -------------------------------------
# Transaction Value Distribution
# -----------------------------------

ggplot(sample_data, aes(x = TransactionValue)) +
  geom_histogram(
    bins = 50,
    fill = "steelblue",
    colour = "white"
  ) +
  labs(
    title = "Distribution of Transaction Value",
    x = "Transaction Value",
    y = "Frequency"
  ) +
  theme_minimal()

# -------------------------------------
# Monthly Transaction Value
# -----------------------------------

monthly_summary <- sample_data %>%
  group_by(Month) %>%
  summarise(
    Mean_TransactionValue = mean(TransactionValue),
    Median_TransactionValue = median(TransactionValue),
    .groups = "drop"
  )

ggplot(
  monthly_summary,
  aes(
    x = Month,
    y = Mean_TransactionValue
  )
) +
  geom_line(
    linewidth = 1.2,
    colour = "darkorange"
  ) +
  geom_point(
    size = 3,
    colour = "darkorange"
  ) +
  scale_x_continuous(
    breaks = 1:12
  ) +
  labs(
    title = "Average Transaction Value by Month",
    x = "Month",
    y = "Average Transaction Value"
  ) +
  theme_minimal()


# ----------------------------------
# Transaction Value by Year
# ------------------------------

year_summary <- sample_data %>%
  group_by(Year) %>%
  summarise(
    Mean_TransactionValue = mean(TransactionValue),
    Median_TransactionValue = median(TransactionValue),
    .groups = "drop"
  )

ggplot(
  year_summary,
  aes(
    x = factor(Year),
    y = Mean_TransactionValue
  )
) +
  geom_col(
    fill = "mediumpurple",
    colour = "black"
  ) +
  labs(
    title = "Average Transaction Value by Year",
    x = "Year",
    y = "Average Transaction Value"
  ) +
  theme_minimal()


# ------------------------------------
# Quantity and Transaction Value
# ----------------------------

ggplot(
  sample_data,
  aes(
    x = Quantity,
    y = TransactionValue
  )
) +
  geom_point(
    alpha = 0.3,
    colour = "steelblue"
  ) +
  geom_smooth(
    method = "lm",
    se = TRUE,
    colour = "red"
  ) +
  labs(
    title = "Relationship Between Quantity and Transaction Value",
    x = "Quantity Purchased",
    y = "Transaction Value"
  ) +
  theme_minimal()


# TRANSFORMATION

sample_data <- sample_data %>%
  mutate(
    LogTransactionValue = log1p(TransactionValue),
    LogQuantity = log1p(Quantity),
    LogUnitPrice = log1p(UnitPrice)
  )


# --------------------------------------
# Log Transaction Value Distribution
# -----------------------------------

ggplot(
  sample_data,
  aes(x = LogTransactionValue)
) +
  geom_histogram(
    bins = 50,
    fill = "darkorange",
    colour = "white"
  ) +
  labs(
    title = "Distribution of Log Transaction Value",
    x = "Log Transaction Value",
    y = "Frequency"
  ) +
  theme_minimal()


# ---------------------------------------
# Log Quantity Distribution
# ------------------------------------

ggplot(
  sample_data,
  aes(x = LogQuantity)
) +
  geom_histogram(
    bins = 50,
    fill = "seagreen",
    colour = "white"
  ) +
  labs(
    title = "Distribution of Log Quantity",
    x = "Log Quantity",
    y = "Frequency"
  ) +
  theme_minimal()


# ---------------------------------------
# Log Unit Price Distribution
# ------------------------------------

ggplot(
  sample_data,
  aes(x = LogUnitPrice)
) +
  geom_histogram(
    bins = 50,
    fill = "orchid",
    colour = "white"
  ) +
  labs(
    title = "Distribution of Log Unit Price",
    x = "Log Unit Price",
    y = "Frequency"
  ) +
  theme_minimal()



# BUSINESS QUESTION 1
# ------------------------------------
# Does average transaction value differ between the UK
# and other countries?


sample_data <- sample_data %>%
  mutate(
    CountryGroup = ifelse(
      Country == "United Kingdom",
      "United Kingdom",
      "Other Countries"
    )
  )

table(sample_data$CountryGroup)


# ------------------------------------------
# Descriptive Statistics
# ---------------------------------

country_group_summary <- sample_data %>%
  group_by(CountryGroup) %>%
  summarise(
    n = n(),
    Mean = mean(LogTransactionValue),
    Median = median(LogTransactionValue),
    SD = sd(LogTransactionValue),
    .groups = "drop"
  )

country_group_summary


# Visualisation
# --------------------

ggplot(
  sample_data,
  aes(
    x = CountryGroup,
    y = LogTransactionValue,
    fill = CountryGroup
  )
) +
  geom_boxplot() +
  labs(
    title = "Transaction Value by Country Group",
    x = "Country Group",
    y = "Log Transaction Value"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none"
  )



# ASSUMPTION CHECKS FOR QUESTION 1

qqnorm(sample_data$LogTransactionValue)
qqline(sample_data$LogTransactionValue)

set.seed(123)

normality_sample <- sample(
  sample_data$LogTransactionValue,
  size = min(5000, length(sample_data$LogTransactionValue))
)

shapiro.test(normality_sample)



# WELCH TWO-SAMPLE T-TEST

t_test_result <- t.test(
  LogTransactionValue ~ CountryGroup,
  data = sample_data,
  var.equal = FALSE
)

t_test_result


t_test_summary <- data.frame(
  Test = "Welch Two-Sample t-test",
  Statistic = as.numeric(t_test_result$statistic),
  DF = as.numeric(t_test_result$parameter),
  P_Value = t_test_result$p.value,
  CI_Lower = t_test_result$conf.int[1],
  CI_Upper = t_test_result$conf.int[2]
)

t_test_summary



# BUSINESS QUESTION 2

# What factors are associated with transaction value?

# ------------------------
# The original TransactionValue ~ Quantity model is not used
# as the main model because TransactionValue is directly
# calculated as Quantity * UnitPrice.


# -----------------------------
# Multiple Regression Model
# -------------------------

regression_model <- lm(
  LogTransactionValue ~
    LogQuantity +
    LogUnitPrice +
    CountryGroup +
    factor(Month),
  data = sample_data
)

summary(regression_model)


# -----------------------------------
# Regression Coefficients
# --------------------------

coef(regression_model)

confint(regression_model)


# --------------------------------
# Tidy Regression Results
# ---------------------------

regression_summary <- tidy(
  regression_model,
  conf.int = TRUE
)

regression_summary



# REGRESSION PREDICTIONS

predictions <- predict(
  regression_model,
  interval = "confidence"
)

head(predictions)



# REGRESSION MODEL PERFORMANCE

model_summary <- summary(regression_model)

cat(
  "R-squared:",
  model_summary$r.squared,
  "\n"
)

cat(
  "Adjusted R-squared:",
  model_summary$adj.r.squared,
  "\n"
)

cat(
  "Residual Standard Error:",
  model_summary$sigma,
  "\n"
)

cat(
  "AIC:",
  AIC(regression_model),
  "\n"
)

cat(
  "BIC:",
  BIC(regression_model),
  "\n"
)


# REGRESSION ASSUMPTION CHECKS

# ------------------------------
# Diagnostic Plots
# ----------------------------------------

par(mfrow = c(2, 2))

plot(regression_model)

par(mfrow = c(1, 1))


# --------------------------------
# Residual Normality
# ---------------------

qqnorm(residuals(regression_model))
qqline(residuals(regression_model))

set.seed(123)

residual_sample <- sample(
  residuals(regression_model),
  size = min(5000, length(residuals(regression_model)))
)

shapiro.test(residual_sample)


# -------------------------------
# Homoscedasticity
# --------------------------

bptest(regression_model)


# ----------------------------
# Residuals vs Fitted
# ----------------------

plot(
  fitted(regression_model),
  residuals(regression_model),
  xlab = "Fitted Values",
  ylab = "Residuals",
  main = "Residuals vs Fitted Values"
)

abline(
  h = 0,
  lty = 2
)


# MODEL PREDICTED VS ACTUAL VISUALISATION

prediction_data <- data.frame(
  Actual = sample_data$LogTransactionValue,
  Predicted = fitted(regression_model)
)

ggplot(
  prediction_data,
  aes(
    x = Actual,
    y = Predicted
  )
) +
  geom_point(
    alpha = 0.3,
    colour = "steelblue"
  ) +
  geom_abline(
    intercept = 0,
    slope = 1,
    colour = "red",
    linewidth = 1
  ) +
  labs(
    title = "Actual vs Predicted Log Transaction Value",
    x = "Actual Log Transaction Value",
    y = "Predicted Log Transaction Value"
  ) +
  theme_minimal()



# BUSINESS QUESTION 3

# Does average transaction value differ across selected
# countries?
# -----------------------

country_counts <- sample_data %>%
  count(Country) %>%
  arrange(desc(n))

head(country_counts, 10)


top_countries <- country_counts %>%
  slice_head(n = 5) %>%
  pull(Country)


anova_data <- sample_data %>%
  filter(Country %in% top_countries) %>%
  droplevels()



# DESCRIPTIVE STATISTICS FOR COUNTRY ANALYSIS

anova_summary <- anova_data %>%
  group_by(Country) %>%
  summarise(
    n = n(),
    Mean = mean(LogTransactionValue),
    Median = median(LogTransactionValue),
    SD = sd(LogTransactionValue),
    .groups = "drop"
  )

anova_summary



# COUNTRY VISUALISATION

ggplot(
  anova_data,
  aes(
    x = Country,
    y = LogTransactionValue,
    fill = Country
  )
) +
  geom_boxplot() +
  labs(
    title = "Transaction Value Across Selected Countries",
    x = "Country",
    y = "Log Transaction Value"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    )
  )



# ORIGINAL ONE-WAY ANOVA

anova_model <- aov(
  LogTransactionValue ~ Country,
  data = anova_data
)

summary(anova_model)



# ANOVA ASSUMPTION CHECKS

anova_residuals <- residuals(anova_model)


# ------------------------
# Normality
# ---------------------

qqnorm(anova_residuals)
qqline(anova_residuals)

set.seed(123)

anova_residual_sample <- sample(
  anova_residuals,
  size = min(5000, length(anova_residuals))
)

shapiro.test(anova_residual_sample)


# ------------------------------------
# Equal Variance
# ------------------------

leveneTest(
  LogTransactionValue ~ Country,
  data = anova_data
)



# WELCH ANOVA

welch_anova <- oneway.test(
  LogTransactionValue ~ Country,
  data = anova_data,
  var.equal = FALSE
)

welch_anova



# PAIRWISE WELCH TESTS

# Pairwise comparisons with Bonferroni correction.
# ----------------

pairwise_welch <- pairwise.t.test(
  anova_data$LogTransactionValue,
  anova_data$Country,
  p.adjust.method = "bonferroni",
  pool.sd = FALSE
)

pairwise_welch



# TUKEY POST-HOC TEST

# Retained for comparison with the original ANOVA analysis.

tukey_result <- TukeyHSD(anova_model)

tukey_result

plot(tukey_result)


# COUNTRY MODEL MEANS

model.tables(
  anova_model,
  type = "means"
)



# CORRELATION ANALYSIS

correlation_result <- cor.test(
  sample_data$Quantity,
  sample_data$TransactionValue,
  method = "pearson"
)

correlation_result


correlation_summary <- data.frame(
  Test = "Pearson Correlation",
  Correlation = as.numeric(correlation_result$estimate),
  P_Value = correlation_result$p.value,
  CI_Lower = correlation_result$conf.int[1],
  CI_Upper = correlation_result$conf.int[2]
)

correlation_summary



# CORRELATION MATRIX

correlation_data <- sample_data %>%
  select(
    TransactionValue,
    Quantity,
    UnitPrice,
    LogTransactionValue,
    LogQuantity,
    LogUnitPrice
  )

correlation_matrix <- cor(
  correlation_data,
  use = "complete.obs"
)

round(
  correlation_matrix,
  3
)


# RESULTS TABLES

regression_summary <- tidy(
  regression_model,
  conf.int = TRUE
)

regression_summary


anova_table <- tidy(
  anova_model
)

anova_table


# Welch ANOVA summary

welch_summary <- data.frame(
  Test = "Welch One-Way ANOVA",
  Statistic = as.numeric(welch_anova$statistic),
  Num_DF = as.numeric(welch_anova$parameter[1]),
  Denom_DF = as.numeric(welch_anova$parameter[2]),
  P_Value = welch_anova$p.value
)

welch_summary

