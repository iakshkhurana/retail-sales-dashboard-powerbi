# Retail Sales Performance Dashboard (Power BI)

Interactive Power BI dashboard on the Superstore dataset (~10K orders) analyzing revenue, profit, margin and growth across regions, categories and segments.

## Data Model
Star schema built in Power Query: `Fact_Sales` + `Dim_Product`, `Dim_Customer`, `Dim_Date` (DAX calendar table).

## DAX Measures
Total Sales, Total Profit, Profit Margin %, YoY Growth %, YTD Sales, MoM Growth %, Top-N Products.

## Key Insights
- Technology drives highest revenue; Furniture has lowest margin
- Tables, Bookcases and Supplies are loss-making sub-categories
- High discounts (>30%) sharply reduce profit margins
- Q4 (Nov–Dec) shows peak sales every year

## Files
- `Retail_Sales_Dashboard.pbix` — Power BI file
- `dashboard_overview.png` — screenshot

Dataset: [Kaggle Superstore](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
