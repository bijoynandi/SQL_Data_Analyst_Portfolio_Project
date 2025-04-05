/*
===================================================================================
Customer Report
===================================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors.

Highlights:
    1. Gather essential fields such as names, ages, and transaction details.
    2. Segment customers into categories (VIP, Regular, and New) and age groups.
    3. Aggregate customer-level metrics:
        - Total Orders
        - Total Sales
        - Total Quantity Purchased
        - Total Products
        - Lifespan (In Months)
    4. Calculate valuable KPIs:
        - Recency (Months Since Last Order)
        - Average Order Value (AOV)
        - Average Monthly Spend
===================================================================================
*/
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
DROP VIEW gold.report_customers;
GO
CREATE VIEW gold.report_customers AS
WITH base_query AS (
/*-----------------------------------------------------------------------------------
1) Base Query: Retrieve core columns from tables
-----------------------------------------------------------------------------------*/
SELECT
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON f.customer_key = c.customer_key
WHERE f.order_date IS NOT NULL -- only consider valid sales date
),
/*-----------------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
-----------------------------------------------------------------------------------*/
customer_aggregate AS (
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months
FROM base_query -- CTE base_query
GROUP BY
    customer_key,
    customer_number,
    customer_name,
    age
)
/*-----------------------------------------------------------------------------------
3) Final Query: Combines all customer results into one output
-----------------------------------------------------------------------------------*/
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age >= 50 THEN 'Above 50'
        ELSE 'n/a'
    END AS age_group,
    CASE
        WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_months,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan_months,
    -- Calculate Average Order Value (AOV)
    CASE -- Handling Divide By Zero Situations
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,
    -- Calculate Average Monthly Spend
    CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE total_sales / lifespan_months
    END AS avg_monthly_spend
FROM customer_aggregate;