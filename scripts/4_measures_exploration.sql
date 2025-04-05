-- Find the Total Sales
SELECT
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Find how many items are sold
SELECT
    SUM(quantity) total_quantity
FROM  gold.fact_sales;

-- Find the average selling price
SELECT
    AVG(price) AS avg_price
FROM gold.fact_sales;

-- Find the total number of orders
SELECT
    COUNT(order_number) AS total_orders
FROM gold.fact_sales;

-- Find the total number of distinct orders
SELECT
    COUNT(DISTINCT order_number) AS total_distinct_orders
FROM gold.fact_sales;

-- Checking the discrepancy between the total number of orders and the total number of distinct orders
SELECT *
FROM gold.fact_sales;

-- Find the total number of products
SELECT
    COUNT(product_key) AS total_products
FROM gold.dim_products;

SELECT
    COUNT(product_name) AS total_products
FROM gold.dim_products;

SELECT
    COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products;

SELECT
    COUNT(DISTINCT product_name) AS total_products
FROM gold.dim_products;

-- Find the total number of customers
SELECT
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers;

SELECT
    COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers;

-- Find the total number of customers than has placed an order
SELECT
    COUNT(DISTINCT customer_key) AS total_customers_with_orders
FROM gold.fact_sales;

-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. of Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. of Products', COUNT(product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. of Customers', COUNT(customer_key) FROM gold.dim_customers;