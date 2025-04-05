-- Analyze sales performance over time
-- Changes over year (A high-level overview insights that helps with strategic decision-making)
SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales_amount,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year ASC;

-- Changes over month (Detailed insight to discover seasonality in your data)
SELECT
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales_amount,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY order_month ASC;

-- Changes over year and the specific month of the year
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales_amount,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date), YEAR(order_date)
ORDER BY order_year ASC, order_month ASC;

-- Using DATETRUNC function to group by month and year in a single column
SELECT
    DATETRUNC(MONTH, order_date) AS order_month,
    SUM(sales_amount) AS total_sales_amount,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date) ASC;

-- Using DATETRUNC function to group by year
SELECT
    DATETRUNC(YEAR, order_date) AS order_month,
    SUM(sales_amount) AS total_sales_amount,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
ORDER BY DATETRUNC(YEAR, order_date) ASC;