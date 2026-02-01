-- ================================================================================
-- BANKING DATA QUALITY & RECONCILIATION - SQL ANALYSIS
-- ================================================================================
-- Purpose: Comprehensive SQL scripts for data quality, reconciliation, and BI
-- Author: Learning Project Portfolio
-- Date: February 2026
-- 
-- Structure:
-- 1. Data Profiling & Exploration
-- 2. Data Quality Checks
-- 3. Reconciliation Analysis  
-- 4. Business Intelligence Queries
-- 5. Performance Optimization
-- ================================================================================

-- ================================================================================
-- SECTION 1: DATA PROFILING & EXPLORATION
-- ================================================================================
-- Learning Objective: Understand your data before analysis

-- 1.1 Quick Overview of Tables
-- -----------------------------------------------------------------------------
SELECT 
    'Customers' AS table_name,
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customers

UNION ALL

SELECT 
    'Transactions' AS table_name,
    COUNT(*) AS total_records,
    COUNT(DISTINCT transaction_id) AS unique_transactions
FROM transactions;


-- 1.2 Column Profiling - Check Data Types and Samples
-- -----------------------------------------------------------------------------
-- For Customer Table
SELECT 
    'customer_id' AS column_name,
    COUNT(*) AS total_count,
    COUNT(DISTINCT customer_id) AS distinct_count,
    COUNT(customer_id) AS non_null_count,
    MIN(customer_id) AS min_value,
    MAX(customer_id) AS max_value
FROM customers

UNION ALL

SELECT 
    'name' AS column_name,
    COUNT(*) AS total_count,
    COUNT(DISTINCT name) AS distinct_count,
    COUNT(name) AS non_null_count,
    MIN(name) AS min_value,
    MAX(name) AS max_value
FROM customers;


-- 1.3 Transaction Volume by Date Range
-- -----------------------------------------------------------------------------
SELECT 
    MIN(transaction_date) AS earliest_transaction,
    MAX(transaction_date) AS latest_transaction,
    DATEDIFF(day, MIN(transaction_date), MAX(transaction_date)) AS date_range_days,
    COUNT(*) AS total_transactions
FROM transactions;


-- 1.4 Sample Data Review
-- -----------------------------------------------------------------------------
-- Always review actual data to understand patterns
SELECT TOP 10 
    c.customer_id,
    c.name,
    c.account_type,
    t.transaction_id,
    t.transaction_date,
    t.amount,
    t.transaction_type
FROM customers c
LEFT JOIN transactions t ON c.customer_id = t.customer_id
ORDER BY t.transaction_date DESC;


-- ================================================================================
-- SECTION 2: DATA QUALITY CHECKS
-- ================================================================================
-- Learning Objective: Implement SQL-based quality validation

-- 2.1 COMPLETENESS CHECK - Identify Null Values
-- -----------------------------------------------------------------------------
-- Customer Table Completeness
SELECT 
    'customer_id' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_count,
    ROUND(100.0 * SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS null_percentage,
    ROUND(100.0 * SUM(CASE WHEN customer_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS completeness_score
FROM customers

UNION ALL

SELECT 
    'name' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN name IS NULL OR name = '' THEN 1 ELSE 0 END) AS null_count,
    ROUND(100.0 * SUM(CASE WHEN name IS NULL OR name = '' THEN 1 ELSE 0 END) / COUNT(*), 2) AS null_percentage,
    ROUND(100.0 * SUM(CASE WHEN name IS NOT NULL AND name <> '' THEN 1 ELSE 0 END) / COUNT(*), 2) AS completeness_score
FROM customers

UNION ALL

SELECT 
    'age' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_count,
    ROUND(100.0 * SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS null_percentage,
    ROUND(100.0 * SUM(CASE WHEN age IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS completeness_score
FROM customers;


-- Transaction Table Completeness
SELECT 
    'transaction_id' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_count,
    ROUND(100.0 * SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS null_percentage
FROM transactions

UNION ALL

SELECT 
    'customer_id' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_count,
    ROUND(100.0 * SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS null_percentage
FROM transactions

UNION ALL

SELECT 
    'amount' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) AS null_count,
    ROUND(100.0 * SUM(CASE WHEN amount IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS null_percentage
FROM transactions;


-- 2.2 UNIQUENESS CHECK - Detect Duplicates
-- -----------------------------------------------------------------------------
-- Exact Duplicate Customers
SELECT 
    customer_id,
    name,
    age,
    city,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id, name, age, city
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- Duplicate Customer IDs (should be unique)
SELECT 
    customer_id,
    COUNT(*) AS occurrence_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Duplicate Transaction IDs (should be unique)
SELECT 
    transaction_id,
    COUNT(*) AS occurrence_count
FROM transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- 2.3 REFERENTIAL INTEGRITY CHECK
-- -----------------------------------------------------------------------------
-- Find orphaned transactions (customer_id not in customers table)
SELECT 
    COUNT(*) AS orphaned_transactions,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM transactions), 2) AS orphaned_percentage
FROM transactions t
WHERE NOT EXISTS (
    SELECT 1 
    FROM customers c 
    WHERE c.customer_id = t.customer_id
);

-- List orphaned transactions with details
SELECT TOP 100
    t.transaction_id,
    t.customer_id,
    t.transaction_date,
    t.amount,
    t.transaction_type,
    'Orphaned - No Customer' AS issue
FROM transactions t
WHERE NOT EXISTS (
    SELECT 1 
    FROM customers c 
    WHERE c.customer_id = t.customer_id
)
ORDER BY t.transaction_date DESC;


-- 2.4 VALIDITY CHECK - Data Range Validation
-- -----------------------------------------------------------------------------
-- Check for invalid ages
SELECT 
    customer_id,
    name,
    age,
    CASE 
        WHEN age < 18 THEN 'Too Young'
        WHEN age > 120 THEN 'Unrealistic Age'
        ELSE 'Valid'
    END AS age_validity
FROM customers
WHERE age < 18 OR age > 120;


-- Check for negative or zero transaction amounts
SELECT 
    transaction_id,
    customer_id,
    amount,
    transaction_date,
    CASE 
        WHEN amount <= 0 THEN 'Invalid Amount'
        WHEN amount > 1000000 THEN 'Suspiciously High'
        ELSE 'Valid'
    END AS amount_validity
FROM transactions
WHERE amount <= 0 OR amount > 1000000;


-- Check for future-dated transactions
SELECT 
    transaction_id,
    customer_id,
    transaction_date,
    amount,
    'Future Date' AS issue
FROM transactions
WHERE transaction_date > GETDATE();


-- 2.5 OUTLIER DETECTION - Statistical Approach
-- -----------------------------------------------------------------------------
-- Detect outliers in transaction amounts using IQR method
WITH amount_stats AS (
    SELECT 
        AVG(amount) AS mean_amount,
        STDEV(amount) AS std_amount,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY amount) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY amount) OVER () AS Q3
    FROM transactions
),
iqr_bounds AS (
    SELECT DISTINCT
        Q1,
        Q3,
        (Q3 - Q1) AS IQR,
        Q1 - (1.5 * (Q3 - Q1)) AS lower_bound,
        Q3 + (1.5 * (Q3 - Q1)) AS upper_bound,
        mean_amount,
        std_amount
    FROM amount_stats
)
SELECT 
    t.transaction_id,
    t.customer_id,
    t.amount,
    t.transaction_date,
    b.lower_bound,
    b.upper_bound,
    CASE 
        WHEN t.amount < b.lower_bound THEN 'Below Lower Bound'
        WHEN t.amount > b.upper_bound THEN 'Above Upper Bound'
    END AS outlier_type
FROM transactions t
CROSS JOIN iqr_bounds b
WHERE t.amount < b.lower_bound OR t.amount > b.upper_bound
ORDER BY ABS(t.amount - b.mean_amount) DESC;


-- 2.6 DATA QUALITY SUMMARY SCORECARD
-- -----------------------------------------------------------------------------
WITH quality_metrics AS (
    SELECT 
        'Completeness' AS quality_dimension,
        ROUND(100.0 * SUM(CASE WHEN customer_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS score
    FROM transactions
    
    UNION ALL
    
    SELECT 
        'Uniqueness' AS quality_dimension,
        ROUND(100.0 * (1 - CAST(COUNT(*) FILTER (WHERE dup_count > 1) AS FLOAT) / COUNT(*)), 2) AS score
    FROM (
        SELECT transaction_id, COUNT(*) AS dup_count
        FROM transactions
        GROUP BY transaction_id
    ) dup_check
    
    UNION ALL
    
    SELECT 
        'Referential Integrity' AS quality_dimension,
        ROUND(100.0 * SUM(CASE WHEN c.customer_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS score
    FROM transactions t
    LEFT JOIN customers c ON t.customer_id = c.customer_id
)
SELECT 
    quality_dimension,
    score,
    CASE 
        WHEN score >= 95 THEN 'Excellent'
        WHEN score >= 85 THEN 'Good'
        WHEN score >= 70 THEN 'Fair'
        ELSE 'Poor'
    END AS status
FROM quality_metrics
ORDER BY score DESC;


-- ================================================================================
-- SECTION 3: RECONCILIATION ANALYSIS
-- ================================================================================
-- Learning Objective: Compare datasets and identify variances

-- 3.1 Period-Over-Period Comparison
-- -----------------------------------------------------------------------------
-- Monthly transaction volume and variance
WITH monthly_summary AS (
    SELECT 
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        DATENAME(MONTH, transaction_date) AS month_name,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount,
        AVG(amount) AS avg_amount
    FROM transactions
    GROUP BY YEAR(transaction_date), MONTH(transaction_date), DATENAME(MONTH, transaction_date)
),
with_previous AS (
    SELECT 
        year,
        month,
        month_name,
        transaction_count,
        total_amount,
        avg_amount,
        LAG(total_amount) OVER (ORDER BY year, month) AS prev_month_amount,
        LAG(transaction_count) OVER (ORDER BY year, month) AS prev_month_count
    FROM monthly_summary
)
SELECT 
    year,
    month,
    month_name,
    transaction_count,
    ROUND(total_amount, 2) AS total_amount,
    ROUND(avg_amount, 2) AS avg_amount,
    prev_month_amount,
    ROUND(total_amount - prev_month_amount, 2) AS amount_variance,
    ROUND(100.0 * (total_amount - prev_month_amount) / NULLIF(prev_month_amount, 0), 2) AS variance_percentage,
    transaction_count - prev_month_count AS count_variance,
    CASE 
        WHEN ABS(100.0 * (total_amount - prev_month_amount) / NULLIF(prev_month_amount, 0)) > 10 
        THEN 'Significant Change'
        ELSE 'Normal'
    END AS variance_status
FROM with_previous
WHERE prev_month_amount IS NOT NULL
ORDER BY year DESC, month DESC;


-- 3.2 System-to-System Reconciliation (Simulated)
-- -----------------------------------------------------------------------------
-- In real scenarios, you'd compare data from different systems
-- Here we'll simulate by comparing different transaction types

WITH system_a AS (
    SELECT 
        transaction_type,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount
    FROM transactions
    WHERE transaction_type IN ('Deposit', 'Transfer')
    GROUP BY transaction_type
),
system_b AS (
    SELECT 
        transaction_type,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount
    FROM transactions
    WHERE transaction_type IN ('Withdrawal', 'Payment')
    GROUP BY transaction_type
)
SELECT 
    COALESCE(a.transaction_type, b.transaction_type) AS transaction_type,
    COALESCE(a.transaction_count, 0) AS system_a_count,
    COALESCE(b.transaction_count, 0) AS system_b_count,
    COALESCE(a.total_amount, 0) AS system_a_amount,
    COALESCE(b.total_amount, 0) AS system_b_amount,
    COALESCE(a.transaction_count, 0) - COALESCE(b.transaction_count, 0) AS count_variance,
    ROUND(COALESCE(a.total_amount, 0) - COALESCE(b.total_amount, 0), 2) AS amount_variance,
    CASE 
        WHEN a.transaction_type IS NULL THEN 'Only in System B'
        WHEN b.transaction_type IS NULL THEN 'Only in System A'
        ELSE 'In Both Systems'
    END AS match_status
FROM system_a a
FULL OUTER JOIN system_b b ON a.transaction_type = b.transaction_type;


-- 3.3 Daily Reconciliation with Exception Flagging
-- -----------------------------------------------------------------------------
WITH daily_summary AS (
    SELECT 
        CAST(transaction_date AS DATE) AS transaction_date,
        transaction_type,
        COUNT(*) AS transaction_count,
        SUM(amount) AS total_amount,
        MIN(amount) AS min_amount,
        MAX(amount) AS max_amount
    FROM transactions
    GROUP BY CAST(transaction_date AS DATE), transaction_type
),
daily_averages AS (
    SELECT 
        transaction_type,
        AVG(total_amount) AS avg_daily_amount,
        STDEV(total_amount) AS std_daily_amount
    FROM daily_summary
    GROUP BY transaction_type
)
SELECT 
    ds.transaction_date,
    ds.transaction_type,
    ds.transaction_count,
    ROUND(ds.total_amount, 2) AS total_amount,
    ROUND(da.avg_daily_amount, 2) AS expected_amount,
    ROUND(ds.total_amount - da.avg_daily_amount, 2) AS variance,
    ROUND(100.0 * (ds.total_amount - da.avg_daily_amount) / NULLIF(da.avg_daily_amount, 0), 2) AS variance_percentage,
    CASE 
        WHEN ABS(ds.total_amount - da.avg_daily_amount) > (2 * da.std_daily_amount) THEN 'EXCEPTION - Review Required'
        WHEN ABS(ds.total_amount - da.avg_daily_amount) > da.std_daily_amount THEN 'WARNING - Monitor'
        ELSE 'OK'
    END AS exception_status
FROM daily_summary ds
JOIN daily_averages da ON ds.transaction_type = da.transaction_type
WHERE ABS(ds.total_amount - da.avg_daily_amount) > da.std_daily_amount
ORDER BY ABS(ds.total_amount - da.avg_daily_amount) DESC;


-- 3.4 Reconciliation Summary Report
-- -----------------------------------------------------------------------------
SELECT 
    'Total Transactions' AS metric,
    COUNT(*) AS value,
    '' AS status
FROM transactions

UNION ALL

SELECT 
    'Total Transaction Value' AS metric,
    ROUND(SUM(amount), 2) AS value,
    '' AS status
FROM transactions

UNION ALL

SELECT 
    'Transactions with Issues' AS metric,
    COUNT(*) AS value,
    CASE WHEN COUNT(*) > 0 THEN 'Review Required' ELSE 'OK' END AS status
FROM transactions t
WHERE NOT EXISTS (SELECT 1 FROM customers c WHERE c.customer_id = t.customer_id)

UNION ALL

SELECT 
    'Data Quality Score' AS metric,
    ROUND(AVG(score), 2) AS value,
    CASE WHEN AVG(score) >= 90 THEN 'Good' ELSE 'Needs Improvement' END AS status
FROM (
    SELECT ROUND(100.0 * SUM(CASE WHEN customer_id IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS score
    FROM transactions
) quality;


-- ================================================================================
-- SECTION 4: BUSINESS INTELLIGENCE QUERIES
-- ================================================================================
-- Learning Objective: Extract actionable business insights

-- 4.1 Customer Segmentation - RFM Analysis
-- -----------------------------------------------------------------------------
WITH rfm_calculation AS (
    SELECT 
        c.customer_id,
        c.name,
        DATEDIFF(day, MAX(t.transaction_date), GETDATE()) AS recency_days,
        COUNT(t.transaction_id) AS frequency,
        SUM(t.amount) AS monetary_value
    FROM customers c
    LEFT JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name
),
rfm_scores AS (
    SELECT 
        customer_id,
        name,
        recency_days,
        frequency,
        ROUND(monetary_value, 2) AS monetary_value,
        NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary_value DESC) AS m_score
    FROM rfm_calculation
    WHERE monetary_value IS NOT NULL
)
SELECT 
    customer_id,
    name,
    recency_days,
    frequency,
    monetary_value,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS rfm_score,
    CASE 
        WHEN (r_score + f_score + m_score) >= 13 THEN 'Champions'
        WHEN (r_score + f_score + m_score) >= 10 THEN 'Loyal Customers'
        WHEN (r_score + f_score + m_score) >= 7 THEN 'Potential Loyalists'
        WHEN (r_score + f_score + m_score) >= 5 THEN 'At Risk'
        ELSE 'Lost'
    END AS customer_segment
FROM rfm_scores
ORDER BY rfm_score DESC;


-- 4.2 Top Customers by Revenue
-- -----------------------------------------------------------------------------
SELECT TOP 20
    c.customer_id,
    c.name,
    c.city,
    c.account_type,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_revenue,
    ROUND(AVG(t.amount), 2) AS avg_transaction_value,
    MIN(t.transaction_date) AS first_transaction,
    MAX(t.transaction_date) AS last_transaction,
    DATEDIFF(day, MIN(t.transaction_date), MAX(t.transaction_date)) AS customer_tenure_days
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name, c.city, c.account_type
ORDER BY total_revenue DESC;


-- 4.3 Transaction Trend Analysis
-- -----------------------------------------------------------------------------
SELECT 
    DATENAME(WEEKDAY, transaction_date) AS day_of_week,
    DATEPART(HOUR, transaction_date) AS hour_of_day,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS avg_amount
FROM transactions
GROUP BY DATENAME(WEEKDAY, transaction_date), DATEPART(HOUR, transaction_date)
ORDER BY 
    CASE DATENAME(WEEKDAY, transaction_date)
        WHEN 'Monday' THEN 1
        WHEN 'Tuesday' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4
        WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6
        WHEN 'Sunday' THEN 7
    END,
    hour_of_day;


-- 4.4 Customer Lifetime Value (CLV) Calculation
-- -----------------------------------------------------------------------------
WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.name,
        COUNT(t.transaction_id) AS total_transactions,
        SUM(t.amount) AS total_spent,
        AVG(t.amount) AS avg_transaction_value,
        DATEDIFF(day, MIN(t.transaction_date), MAX(t.transaction_date)) AS active_days,
        DATEDIFF(day, MAX(t.transaction_date), GETDATE()) AS days_since_last_transaction
    FROM customers c
    LEFT JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT 
    customer_id,
    name,
    total_transactions,
    ROUND(total_spent, 2) AS total_spent,
    ROUND(avg_transaction_value, 2) AS avg_transaction_value,
    active_days,
    days_since_last_transaction,
    CASE 
        WHEN active_days > 0 THEN ROUND(total_transactions * 1.0 / (active_days / 30.0), 2)
        ELSE 0
    END AS transactions_per_month,
    ROUND(total_spent * 12 / NULLIF(active_days / 30.0, 0), 2) AS projected_annual_value,
    CASE 
        WHEN days_since_last_transaction <= 30 THEN 'Active'
        WHEN days_since_last_transaction <= 90 THEN 'Moderate'
        WHEN days_since_last_transaction <= 180 THEN 'At Risk'
        ELSE 'Churned'
    END AS customer_status
FROM customer_metrics
WHERE total_spent IS NOT NULL
ORDER BY total_spent DESC;


-- 4.5 Monthly Performance Dashboard
-- -----------------------------------------------------------------------------
WITH monthly_metrics AS (
    SELECT 
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        DATENAME(MONTH, transaction_date) AS month_name,
        COUNT(DISTINCT customer_id) AS unique_customers,
        COUNT(*) AS total_transactions,
        SUM(amount) AS total_revenue,
        AVG(amount) AS avg_transaction_value,
        MAX(amount) AS largest_transaction
    FROM transactions
    GROUP BY YEAR(transaction_date), MONTH(transaction_date), DATENAME(MONTH, transaction_date)
)
SELECT 
    year,
    month,
    month_name,
    unique_customers,
    total_transactions,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(avg_transaction_value, 2) AS avg_transaction_value,
    ROUND(total_revenue / NULLIF(unique_customers, 0), 2) AS revenue_per_customer,
    ROUND(total_transactions * 1.0 / NULLIF(unique_customers, 0), 2) AS transactions_per_customer,
    ROUND(largest_transaction, 2) AS largest_transaction
FROM monthly_metrics
ORDER BY year DESC, month DESC;


-- ================================================================================
-- SECTION 5: ADVANCED QUERIES & PERFORMANCE OPTIMIZATION
-- ================================================================================
-- Learning Objective: Write efficient queries for large datasets

-- 5.1 Indexed View for Faster Reporting
-- -----------------------------------------------------------------------------
-- Create indexed view for customer transaction summary
-- Note: Adjust based on your SQL Server edition
CREATE VIEW vw_customer_transaction_summary
WITH SCHEMABINDING
AS
SELECT 
    c.customer_id,
    COUNT_BIG(*) AS transaction_count,
    SUM(t.amount) AS total_amount,
    AVG(t.amount) AS avg_amount
FROM dbo.customers c
JOIN dbo.transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id;
GO

-- Create unique clustered index on view
-- CREATE UNIQUE CLUSTERED INDEX IX_CustomerSummary 
-- ON vw_customer_transaction_summary(customer_id);


-- 5.2 Common Table Expressions (CTEs) for Complex Analysis
-- -----------------------------------------------------------------------------
WITH customer_activity AS (
    -- Step 1: Calculate customer metrics
    SELECT 
        customer_id,
        COUNT(*) AS txn_count,
        SUM(amount) AS total_spent,
        AVG(amount) AS avg_spent
    FROM transactions
    GROUP BY customer_id
),
customer_ranking AS (
    -- Step 2: Rank customers
    SELECT 
        customer_id,
        txn_count,
        total_spent,
        avg_spent,
        ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS revenue_rank,
        PERCENT_RANK() OVER (ORDER BY total_spent) AS revenue_percentile
    FROM customer_activity
)
-- Step 3: Final output with customer details
SELECT 
    c.customer_id,
    c.name,
    c.city,
    cr.txn_count,
    ROUND(cr.total_spent, 2) AS total_spent,
    ROUND(cr.avg_spent, 2) AS avg_spent,
    cr.revenue_rank,
    ROUND(cr.revenue_percentile * 100, 2) AS revenue_percentile,
    CASE 
        WHEN cr.revenue_percentile >= 0.9 THEN 'Top 10%'
        WHEN cr.revenue_percentile >= 0.75 THEN 'Top 25%'
        WHEN cr.revenue_percentile >= 0.5 THEN 'Top 50%'
        ELSE 'Bottom 50%'
    END AS customer_tier
FROM customer_ranking cr
JOIN customers c ON cr.customer_id = c.customer_id
ORDER BY cr.revenue_rank;


-- 5.3 Window Functions for Advanced Analytics
-- -----------------------------------------------------------------------------
-- Running totals and moving averages
SELECT 
    transaction_date,
    transaction_id,
    amount,
    SUM(amount) OVER (ORDER BY transaction_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
    AVG(amount) OVER (ORDER BY transaction_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_7day,
    ROW_NUMBER() OVER (PARTITION BY CAST(transaction_date AS DATE) ORDER BY amount DESC) AS daily_rank,
    NTILE(4) OVER (ORDER BY amount) AS quartile
FROM transactions
ORDER BY transaction_date;


-- ================================================================================
-- SUMMARY & BEST PRACTICES
-- ================================================================================
/*
KEY LEARNINGS FROM THIS SQL SCRIPT:

1. DATA PROFILING
   - Always start by understanding your data structure
   - Check for nulls, duplicates, and data types
   - Sample data to verify your assumptions

2. DATA QUALITY
   - Implement systematic checks (completeness, uniqueness, validity, integrity)
   - Use statistical methods (IQR) for outlier detection
   - Create quality scorecards for ongoing monitoring

3. RECONCILIATION
   - Compare datasets across different dimensions
   - Calculate variances and set tolerance thresholds
   - Flag exceptions for investigation

4. BUSINESS INTELLIGENCE
   - RFM analysis for customer segmentation
   - Trend analysis for pattern identification
   - CLV calculation for customer value assessment

5. PERFORMANCE OPTIMIZATION
   - Use CTEs for complex queries
   - Leverage window functions for analytics
   - Consider indexed views for frequently-run reports
   - Partition large queries for better performance

NEXT STEPS:
- Implement these queries with your actual data
- Adjust column names to match your schema
- Create scheduled jobs for automated quality checks
- Build Power BI dashboards using these queries
- Document data dictionaries and business rules
*/

-- ================================================================================
-- END OF SQL ANALYSIS SCRIPT
-- ================================================================================
