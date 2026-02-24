# Multi-Channel Marketing Attribution & Performance Dashboard

## Project Overview

This project simulates a real-world marketing analytics workflow to answer a key business question:

> If we invest the next $1M in marketing, which channel deserves the budget?

The project includes:

- SQL-based KPI aggregation
- Multi-touch attribution modeling
- Marketing performance metrics (CTR, CVR, CPA, ROAS)
- Funnel drop-off analysis
- Executive-style Tableau dashboard

---

## 🛠 Tech Stack

- PostgreSQL (Docker)
- SQL
- Python (Pandas)
- Tableau Public
- Git & GitHub

---

## 📁 Project Structure

marketing-attribution-dashboard/
│
├── data/
│ ├── raw/
│ ├── processed/
│
├── notebooks/
│
├── dashboard/
│ ├── tableau/
│ └── screenshots/
│
├── sql/
└── README.md


---

## Key Metrics Implemented

- Revenue
- CTR (Click Through Rate)
- CVR (Conversion Rate)
- CPA (Cost Per Acquisition)
- ROAS (Return on Ad Spend)

---

## Dashboard Components

### KPI Overview
High-level performance summary including Total Revenue, ROAS, CPA, and CVR.

### Revenue by Channel
Identifies top revenue-driving channels.

### ROAS by Channel
Compares efficiency of marketing spend.

### Channel Funnel
Visualizes drop-off from:
- Clicks
- Add to Cart
- Purchases

---

## Business Insights (Example)

- Email shows highest ROAS despite lower traffic volume.
- Paid Search drives strong revenue but at lower efficiency.
- Major funnel drop-off occurs between Add To Cart and Purchase.

---

## How to Reproduce

1. Load dataset into PostgreSQL
2. Run KPI aggregation queries
3. Export processed CSV
4. Connect Tableau to processed data
5. Rebuild dashboard using provided structure

---

## Future Improvements

- Implement time-series trend analysis
- Add budget reallocation simulation
- Introduce customer segmentation
- Deploy dashboard to Tableau Public

---

## Author

Sireesha Gurram  
MS Computer Science  
Aspiring Data Analyst | Marketing Analytics
