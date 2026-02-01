# Banking Data Quality & Reconciliation Learning Project

A hands-on learning project demonstrating data quality assessment, reconciliation analysis, and business intelligence using **Python, SQL, and Power BI**.

> **My Approach**: This project showcases my real-world workflow - importing libraries as needed, solving problems incrementally, and documenting the learning journey. It demonstrates both technical proficiency and practical problem-solving skills.

## 🎯 What This Project Demonstrates

- ✅ **Data Quality Engineering**: Systematic assessment across multiple quality dimensions
- ✅ **Reconciliation Frameworks**: Period-over-period and system-to-system variance analysis
- ✅ **SQL Proficiency**: Complex queries with CTEs, window functions, and statistical methods
- ✅ **Python Analytics**: pandas, numpy, statistical analysis, and visualization
- ✅ **Business Intelligence**: Customer segmentation, KPIs, and dashboard preparation
- ✅ **Professional Documentation**: Clear, educational, portfolio-ready code

## 📂 Project Structure

```
├── Datasets/                           # Raw data files (download from Kaggle)
├── notebooks/
│   └── comprehensive_analysis.ipynb    # Complete Python analysis (one notebook)
├── sql/
│   └── comprehensive_analysis.sql      # Complete SQL analysis (one file)
├── outputs/                            # Auto-generated reports and exports
│   ├── data_quality_summary.csv
│   ├── reconciliation_results.csv
│   ├── customer_rfm_analysis.csv
│   └── powerbi_export.xlsx
├── docs/
│   └── QUICK_START.md                  # 5-minute quick start guide
```

## 🎓 Learning Journey

This project is structured to show **how I work and learn**:

### **Step 1: Data Exploration** 
- Load and profile datasets
- Understand structure and relationships
- Import only essential libraries (pandas, pathlib)

### **Step 2: Data Quality Assessment**
- Implement completeness, uniqueness, validity checks
- Import numpy for statistical outlier detection
- Build referential integrity validation

### **Step 3: Reconciliation Analysis**
- Period-over-period variance tracking
- System-to-system comparisons
- Exception flagging with tolerance thresholds

### **Step 4: Customer Analytics**
- RFM segmentation (Recency, Frequency, Monetary)
- Customer lifetime value calculations
- Import matplotlib/seaborn when visualization is needed

### **Step 5: Business Intelligence**
- Create executive dashboards
- Prepare optimized datasets for Power BI
- Generate actionable insights and recommendations

## 🗄️ Datasets Used

### 1. **Financial Transactions Dataset**
- Source: [Kaggle](https://www.kaggle.com/datasets/cankatsrc/financial-transactions-dataset)
- Contains: Transaction records with amounts, dates, types

### 2. **Banking & Customer Transaction Data**
- Source: [Kaggle](https://www.kaggle.com/datasets/yogeshtekawade/banking-and-customer-transaction-data)
- Contains: Customer demographics + transaction history

### 3. **Transaction Data for Banking Operations**
- Source: [Kaggle](https://www.kaggle.com/datasets/ziya07/transaction-data-for-banking-operations)
- Contains: Various transaction types (deposits, transfers, withdrawals)

## 🚀 Quick Start (5 Minutes)

### Option A: Python Notebook (Recommended for Learning)

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Download at least one dataset** (optional - sample data auto-generated):
   - [Financial Transactions Dataset](https://www.kaggle.com/datasets/cankatsrc/financial-transactions-dataset)
   - [Banking & Customer Data](https://www.kaggle.com/datasets/yogeshtekawade/banking-and-customer-transaction-data)
   - Place CSV files in `Datasets/` folder

3. **Launch Jupyter:**
   ```bash
   jupyter notebook
   ```

4. **Open and run:** `notebooks/comprehensive_analysis.ipynb`
   - Work through cells sequentially
   - Read explanations in markdown cells
   - Run code cells to see results
   - Outputs auto-saved to `outputs/` folder

### Option B: SQL Analysis

1. **Set up database** (SQL Server, PostgreSQL, MySQL, or SQLite)

2. **Import your data** into tables named `customers` and `transactions`

3. **Open:** `sql/comprehensive_analysis.sql`

4. **Run queries** in your preferred SQL client:
   - Section 1: Data Profiling
   - Section 2: Quality Checks
   - Section 3: Reconciliation
   - Section 4: Business Intelligence
   - Section 5: Advanced Analytics

### Option C: Both (Shows Full Skillset)
- Use Python notebook for exploratory analysis and visualization
- Use SQL for database operations and complex joins
- Compare approaches and document findings

## 📊 What's Inside

### **Python Notebook** (`comprehensive_analysis.ipynb`)

A complete, educational analysis covering:

**Part 1: Data Loading**
- Progressive library imports (pandas → numpy → matplotlib as needed)
- Sample data generation for immediate hands-on learning
- Real-world file handling and error management

**Part 2: Data Quality Assessment**
- Completeness checks (null values, missing data)
- Uniqueness validation (duplicate detection)
- Referential integrity (foreign key validation)
- Outlier detection using IQR statistical method
- Data type validation and recommendations
- Quality scorecard generation

**Part 3: Reconciliation Analysis**
- Period-over-period variance tracking
- System-to-system comparisons
- Automated exception flagging
- Variance percentage calculations
- Tolerance threshold management

**Part 4: Customer Analytics**
- RFM Analysis (Recency, Frequency, Monetary)
- Customer segmentation (Champions, Loyal, At Risk, Lost)
- Behavioral pattern identification
- Customer lifetime value projections

**Part 5: Visualization & Dashboards**
- Transaction volume trends
- Amount distribution histograms
- Type breakdown pie charts
- Monthly performance bars
- High-resolution exports for presentations

**Part 6: Power BI Preparation**
- Multi-sheet Excel exports
- Date dimension enrichment
- Pre-calculated KPIs
- Optimized data models

### **SQL Script** (`comprehensive_analysis.sql`)

Production-ready SQL queries organized into:

**Section 1: Data Profiling**
- Table overviews and record counts
- Column profiling and data type checks
- Date range analysis
- Sample data review

**Section 2: Data Quality Checks**
- Completeness analysis with null percentages
- Duplicate detection queries
- Referential integrity validation
- Validity checks (ranges, formats)
- Statistical outlier detection using PERCENTILE_CONT
- Comprehensive quality scorecards

**Section 3: Reconciliation**
- Period-over-period with LAG functions
- System-to-system comparisons
- Daily reconciliation with exception flagging
- Variance tracking with tolerance thresholds
- Summary reports

**Section 4: Business Intelligence**
- RFM segmentation with NTILE
- Customer lifetime value calculations
- Top customers by revenue
- Transaction trend analysis
- Monthly performance dashboards

**Section 5: Advanced Techniques**
- Common Table Expressions (CTEs)
- Window functions (ROW_NUMBER, RANK, PERCENT_RANK)
- Running totals and moving averages
- Indexed views for performance
- Query optimization patterns

## 🛠️ Technologies Used

- **Python**: pandas, numpy, matplotlib, seaborn, plotly
- **SQL**: Complex queries, CTEs, window functions, aggregations
- **Jupyter**: Interactive analysis and documentation
- **Power BI**: Data visualization and dashboard creation
- **Git**: Version control and portfolio showcase

## 📈 Sample Outputs

All analysis outputs are saved to the `outputs/` directory:
- `data_quality_report.csv` - Complete quality assessment
- `reconciliation_results.csv` - Variance analysis details
- `exceptions_flagged.csv` - High-priority issues
- `customer_segments.csv` - Customer analytics
- `monthly_trends.csv` - Time-series analysis

## 💼 Skills Demonstrated

**Technical Skills:**
- Data wrangling and transformation
- Statistical analysis and outlier detection
- SQL query optimization
- Data visualization best practices
- ETL pipeline development

**Business Skills:**
- Data quality frameworks
- Reconciliation methodologies
- Financial data analysis
- Exception management processes
- Stakeholder reporting

**Soft Skills:**
- Problem-solving approach
- Clear documentation
- Attention to detail
- Analytical thinking

## 📝 Notes on Learning Process

Each notebook includes:
- **Context**: Why this analysis matters
- **Methodology**: How I approached the problem
- **Code**: Well-commented, production-ready code
- **Insights**: What the data reveals
- **Next Steps**: How this connects to the bigger picture

## 🤝 About This Project

Created as part of my data analytics portfolio to demonstrate expertise in:
- Financial data analysis
- Data quality engineering
- SQL proficiency
- Python programming
- Business intelligence

---

**Author**: Data Analytics Portfolio Project  
**Last Updated**: February 2026  
**Status**: Active Learning Project

