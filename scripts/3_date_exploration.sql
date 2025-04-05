-- Find the date of first and last orders
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM gold.fact_sales;

-- How many years of sales are available?
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- Find the youngest and oldest customers
SELECT
    MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_customer_age,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers;

-- Finding the youngest and oldest customers with customer name, birthdate and age
SELECT 
    (SELECT TOP 1 first_name FROM gold.dim_customers WHERE birthdate IS NOT NULL ORDER BY birthdate ASC) AS oldest_customer_name,
    (SELECT MIN(birthdate) FROM gold.dim_customers) AS oldest_birthdate,
    DATEDIFF(YEAR, (SELECT MIN(birthdate) FROM gold.dim_customers), GETDATE()) AS oldest_customer_age,

    (SELECT TOP 1 first_name FROM gold.dim_customers ORDER BY birthdate DESC) AS youngest_customer_name,
    (SELECT MAX(birthdate) FROM gold.dim_customers) AS youngest_birthdate,
    DATEDIFF(YEAR, (SELECT MAX(birthdate) FROM gold.dim_customers), GETDATE()) AS youngest_customer_age;