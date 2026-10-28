-- Retail Sales Performance Dashboard — SQL Analysis
-- Dataset: Superstore (Kaggle), loaded as table `superstore`
-- Tested on SQLite (DB Browser for SQLite); works on MySQL/PostgreSQL with minor tweaks.

-- 1. Overall KPIs
SELECT
    ROUND(SUM(Sales), 2)                        AS total_sales,
    ROUND(SUM(Profit), 2)                       AS total_profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)  AS profit_margin_pct,
    COUNT(DISTINCT "Order ID")                  AS total_orders,
    COUNT(DISTINCT "Customer ID")               AS total_customers
FROM superstore;

-- 2. Sales & profit by Category
SELECT Category,
       ROUND(SUM(Sales), 2)  AS sales,
       ROUND(SUM(Profit), 2) AS profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS margin_pct
FROM superstore
GROUP BY Category
ORDER BY sales DESC;

-- 3. Loss-making sub-categories
SELECT "Sub-Category",
       ROUND(SUM(Sales), 2)  AS sales,
       ROUND(SUM(Profit), 2) AS profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS margin_pct
FROM superstore
GROUP BY "Sub-Category"
HAVING SUM(Profit) < 0
ORDER BY profit;

-- 4. Discount impact on profit margin
SELECT
    CASE
        WHEN Discount = 0        THEN '0%'
        WHEN Discount <= 0.2     THEN '1-20%'
        WHEN Discount <= 0.4     THEN '21-40%'
        ELSE                          '40%+'
    END AS discount_band,
    COUNT(*)                                    AS orders,
    ROUND(AVG(Profit), 2)                       AS avg_profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2)  AS margin_pct
FROM superstore
GROUP BY discount_band
ORDER BY MIN(Discount);

-- 5. Year-over-Year sales growth (window function)
WITH yearly AS (
    SELECT SUBSTR("Order Date", 7, 4) AS yr,   -- adjust if date format differs
           SUM(Sales) AS sales
    FROM superstore
    GROUP BY yr
)
SELECT yr, ROUND(sales, 2) AS sales,
       ROUND(LAG(sales) OVER (ORDER BY yr), 2) AS prev_year_sales,
       ROUND((sales - LAG(sales) OVER (ORDER BY yr)) * 100.0
             / LAG(sales) OVER (ORDER BY yr), 2) AS yoy_growth_pct
FROM yearly;

-- 6. Top 10 products by sales
SELECT "Product Name",
       ROUND(SUM(Sales), 2)  AS sales,
       ROUND(SUM(Profit), 2) AS profit
FROM superstore
GROUP BY "Product Name"
ORDER BY sales DESC
LIMIT 10;

-- 7. Region x Segment performance
SELECT Region, Segment,
       ROUND(SUM(Sales), 2)  AS sales,
       ROUND(SUM(Profit), 2) AS profit,
       RANK() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS rank_in_region
FROM superstore
GROUP BY Region, Segment
ORDER BY Region, rank_in_region;

-- 8. High sales but low margin products (discount problem)
SELECT "Product Name",
       ROUND(SUM(Sales), 2)   AS sales,
       ROUND(SUM(Profit), 2)  AS profit,
       ROUND(AVG(Discount), 2) AS avg_discount
FROM superstore
GROUP BY "Product Name"
HAVING SUM(Sales) > 5000 AND SUM(Profit) < 0
ORDER BY sales DESC;
