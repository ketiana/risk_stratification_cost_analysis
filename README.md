# Member Risk Stratification & Cost Concentration Analysis

Analysis of cost concentration in a synthetic health insurance population of 50,000 members.
The top 10% of members account for approximately 21% of total payer spend.

📊 [View Full Project Writeup](https://ketiana-portfolio.netlify.app/projects/member-risk-stratification-cost-analysis/)

**Tools:** SQL (DuckDB) · Python (pandas, matplotlib, seaborn)  
**Data:** Synthea synthetic EHR data — not real patient records

## What This Project Does

Segments members into four risk tiers based on total cost, then quantifies cost concentration
across the population. Includes utilization patterns by tier, demographic breakdowns, and
a cost concentration curve.

## Repository Structure

```
member-risk-stratification/
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_explore_data.sql
│   ├── 03_member_cost_summary.sql
│   ├── 04_risk_tiers.sql
│   └── 05_cost_concentration.sql
├── notebooks/
│   └── risk_stratification_analysis.ipynb
└── outputs/
```

## How to Run

1. Generate Synthea data (50k patients, Florida, seed `-s 12345`)
2. Load CSVs into DuckDB via DataGrip
3. Run SQL files in order
4. Open the notebook in Google Colab and point `DATA_PATH` to your exported CSV

Visuals, key findings, and full analysis are available at:
👉 [https://ketiana-portfolio.netlify.app/projects/member-risk-stratification-cost-analysis/](https://ketiana-portfolio.netlify.app/projects/member-risk-stratification-cost-analysis/)
