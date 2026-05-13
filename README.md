# 🛒 Customer Segmentation & RFM Analysis

[![Python](https://img.shields.io/badge/Python-3.10%2B-blue?logo=python)](https://www.python.org/)
[![SQL](https://img.shields.io/badge/SQL-SQLite%20%2F%20PostgreSQL-lightblue?logo=postgresql)]()
[![Power BI](https://img.shields.io/badge/Dashboard-Power%20BI-F2C811?logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![Jupyter](https://img.shields.io/badge/Notebook-Jupyter-orange?logo=jupyter)](https://jupyter.org/)

Segmenting **400+ retail customers** into behavioural cohorts using **RFM analysis** (Recency · Frequency · Monetary), powered by SQL window functions and visualised in a 4-page Power BI dashboard.

---

## 📌 Project Overview

| | |
|---|---|
| **Objective** | Identify high-value, loyal, and at-risk customer cohorts to inform targeted retention strategies |
| **Dataset** | 1 000+ retail transactions across 400+ customers |
| **SQL Engine** | SQLite (NTILE window functions) — portable to PostgreSQL / MySQL 8 with no changes |
| **Segments** | Champions · Loyal · At-Risk |
| **Key Insight** | Top ~20% of customers drive ~60% of total revenue |

---

## 🧮 RFM Framework

| Dimension | Definition | Score Rule |
|---|---|---|
| **Recency** | Days since last purchase | Lower days → higher score |
| **Frequency** | Total number of orders | More orders → higher score |
| **Monetary** | Total spend in period | Higher spend → higher score |

Each dimension is scored **1–5** using SQL `NTILE(5)` window functions.  
The composite `avg_rfm_score = (R + F + M) / 3` determines segment assignment:

```
Champions  →  R ≥ 4  AND  F ≥ 4  AND  M ≥ 4
Loyal      →  (R ≥ 3 AND F ≥ 3)  OR  (R ≥ 4 AND M ≥ 3)
At-Risk    →  everything else
```

---

## 📊 Dashboard Highlights

> *(Upload `Dashboard.png` to see the preview here)*

The Power BI report includes 4 interactive pages:

| Page | Content |
|---|---|
| **Segment Overview** | Customer count, revenue contribution, avg RFM scores |
| **Revenue Contribution** | Lorenz curve — top 20% customer concentration |
| **Segment Deep-Dive** | RFM boxplots, recency vs monetary scatter, drill-through |
| **Monthly Trend** | Revenue time-series with segment breakdown slicer |

---

## 🗂️ Project Structure

```
Customer-Segmentation-RFM-Analysis/
│
├── rfm_segmentation.ipynb        # Full Python analysis pipeline
├── generate_data.py              # Synthetic dataset generator
├── sql/
│   └── rfm_analysis.sql          # Pure SQL RFM scoring (NTILE window functions)
├── data/
│   └── retail_transactions.csv   # Source transactions (generated or replaced with real data)
├── requirements.txt
└── .gitignore
```

---

## 🚀 Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/Customer-Segmentation-RFM-Analysis.git
cd Customer-Segmentation-RFM-Analysis
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Generate the dataset (skip if using real data)

```bash
python generate_data.py
```

### 4. Run the notebook

```bash
jupyter notebook rfm_segmentation.ipynb
```

Run all cells. Output CSVs will be created in `data/`:

- `rfm_customers.csv` — one row per customer with scores & segment
- `rfm_segmented_export.csv` — transactions joined with segment data
- `segment_summary.csv` — aggregate KPIs per segment

### 5. Power BI

Open the `.pbix` file in Power BI Desktop and point its data source to `data/rfm_segmented_export.csv`.

---

## 📈 Key Results

| Segment | ~Customers | ~Revenue % | Strategy |
|---|---|---|---|
| **Champions** | 80 (18%) | 42% | Reward & retain — loyalty program, early access |
| **Loyal** | 140 (31%) | 38% | Upsell — personalised bundles, frequency nudges |
| **At-Risk** | 230 (51%) | 20% | Win-back — discount re-engagement campaigns |

> The top ~20% of customers by spend account for **≈60% of total revenue** — identified and flagged for prioritised retention.

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Data generation | Python (NumPy, Pandas) |
| RFM computation | SQL — NTILE window functions |
| Analysis & plots | Python (Pandas, Matplotlib, Seaborn) |
| Dashboard | Microsoft Power BI |

---

## 📬 Contact

**Ish**  
📧 your-email@example.com  
🔗 [LinkedIn](https://linkedin.com/in/your-profile)
