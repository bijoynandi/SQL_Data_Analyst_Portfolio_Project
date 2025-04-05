/* Group customers into three segments based on their spending behavior.
    - VIP: Customers with at least 12 months of history and spending more than €5,000.
    - Regular: Customers with at least 6 months of history but €5,000 or less.
    - New: Customers with lifespan less than 12 months.
And find the total number of customers of each group.
*/
WITH customer_spending AS (
SELECT
    c.customer_key,
    SUM(f.sales_amount) AS total_spending,
    MIN(f.order_date) AS first_order_date,
    MAX(f.order_date) AS last_order_date,
    DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan_in_months
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
-- Main query to calculate customer segments and their counts
SELECT
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM
-- Subquery to assign customer segments
(
SELECT
    customer_key,
    total_spending,
    lifespan_in_months,
    CASE
        WHEN lifespan_in_months >= 12 AND total_spending > 5000 THEN 'VIP'
        WHEN lifespan_in_months >= 12 AND total_spending <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment
FROM customer_spending
) AS t
GROUP BY customer_segment;