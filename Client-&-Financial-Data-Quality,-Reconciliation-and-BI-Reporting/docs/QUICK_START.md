# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies
```bash
pip install -r requirements.txt
```

### Step 2: Download Datasets
Download at least one dataset from:
- [Financial Transactions Dataset](https://www.kaggle.com/datasets/cankatsrc/financial-transactions-dataset)
- [Banking & Customer Data](https://www.kaggle.com/datasets/yogeshtekawade/banking-and-customer-transaction-data)

Place CSV files in the `Datasets/` folder.

### Step 3: Run the Analysis

#### Option A: Python Notebook (Recommended)
```bash
jupyter notebook
```
Then open: `notebooks/comprehensive_analysis.ipynb`

Work through the notebook cells sequentially to learn:
- Data exploration techniques
- Quality assessment methods
- Reconciliation analysis
- Customer segmentation
- Power BI preparation

#### Option B: SQL Analysis
1. Import your data into a SQL database (SQL Server, PostgreSQL, MySQL, or SQLite)
2. Update table names in `sql/comprehensive_analysis.sql`
3. Run the SQL scripts in your database client

### Step 4: Review Outputs
All results are saved to the `outputs/` folder:
- Quality reports
- Reconciliation results
- Customer analytics
- Power BI export file

### Step 5: Create Dashboard (Optional)
Import `outputs/powerbi_export.xlsx` into Power BI Desktop to create visualizations.

---

## 📁 Project Files

**Main Analysis:**
- `notebooks/comprehensive_analysis.ipynb` - Complete Python analysis
- `sql/comprehensive_analysis.sql` - Complete SQL analysis

**Documentation:**
- `README.md` - Full project overview
- `docs/QUICK_START.md` - This file

**Outputs:**
- `outputs/` - All generated reports and exports

---

## 💡 Tips for Learning

1. **Start with the notebook** - It's interactive and educational
2. **Read the comments** - Each section explains what you're learning
3. **Modify the code** - Experiment with different parameters
4. **Check the outputs** - Review generated reports to understand results
5. **Try SQL queries** - Complement Python analysis with SQL skills

---

## 🆘 Troubleshooting

**Problem:** Dataset not found
- **Solution:** Ensure CSV files are in the `Datasets/` folder with correct names

**Problem:** Missing libraries
- **Solution:** Run `pip install -r requirements.txt`

**Problem:** Jupyter not opening
- **Solution:** Run `pip install jupyter notebook` first

**Problem:** SQL table not found
- **Solution:** Update table names in SQL script to match your database schema

---

## 📚 What You'll Learn

✅ Data profiling and exploration  
✅ Comprehensive quality checks  
✅ Reconciliation methodologies  
✅ Customer analytics (RFM, CLV)  
✅ Data visualization  
✅ SQL and Python integration  
✅ Power BI data preparation  

Happy Learning! 🎓
