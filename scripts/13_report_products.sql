/*
===================================================================================
Product Report
===================================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gather essential fields such as product name, category, subcategory and cost.
    2. Segment Products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregate product-level metrics:
        - Total Orders
        - Total Sales
        - Total Quantity Sold
        - Total Customers (Unique)
        - Lifespan (In Months)
    4. Calculate valuable KPIs:
        - Recency (Months Since Last Sale)
        - Average Order Revenue (AOR)
        - Average Monthly Revenue
===================================================================================
*/
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
DROP VIEW gold.report_products;
GO
CREATE VIEW gold.report_products AS
WITH base_query AS (
/*-----------------------------------------------------------------------------------
1) Base Query: Retrieve core columns from tables
-----------------------------------------------------------------------------------*/
SELECT
    f.order_number,
    f.order_date,
    f.customer_key,
    f.sales_amount,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL -- only consider valid sales date
),
/*-----------------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
-----------------------------------------------------------------------------------*/
product_aggregations AS (
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity_sold,
    CASE
        WHEN SUM(quantity) = 0 THEN 0
        ELSE ROUND(AVG(CAST(sales_amount AS FLOAT) / quantity), 1)
    END AS avg_selling_price
FROM base_query -- CTE base_query
GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)
/*-----------------------------------------------------------------------------------
3) Final Query: Combines all product results into one output
-----------------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,    
    lifespan_months,    
    total_orders,
    total_sales,
    total_quantity_sold,
    total_customers,
    avg_selling_price,
    -- Average Order Revenue (AOR)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,
    -- Average Monthly Revenue
    CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE total_sales / lifespan_months
    END AS avg_monthly_revenue
FROM product_aggregations;