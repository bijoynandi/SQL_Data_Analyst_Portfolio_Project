-- Calculate the total sales per month
-- And the running total sales over time
SELECT
    order_month,
    total_sales_amount,
    SUM(total_sales_amount) OVER (ORDER BY order_month ASC) AS cumulative_sales_amount, -- Default behavior is also ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW if not specified
    SUM(total_sales_amount) OVER (PARTITION BY YEAR(order_month) ORDER BY order_month ASC) AS cumulative_sales_amount_year -- Cumulative value by year
    
FROM
    (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales_amount
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)) t

-- Calculate the average sales per month
-- And the moving average sales over time
SELECT
    order_month,
    total_sales_amount,
    average_price,
    SUM(total_sales_amount) OVER (ORDER BY order_month ASC) AS cumulative_sales_amount, -- Default behavior is also ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW if not specified
    AVG(average_price) OVER (ORDER BY order_month ASC) moving_average_price
FROM
    (
    SELECT
        DATETRUNC(MONTH, order_date) AS order_month,
        SUM(sales_amount) AS total_sales_amount,
        AVG(price) AS average_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(MONTH, order_date)) t