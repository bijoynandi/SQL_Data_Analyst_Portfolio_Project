/* Segment products into cost ranges and 
count how many products fall into each segment */
WITH product_segments AS (
SELECT
    product_key,
    product_name,
    cost,
    CASE
        WHEN cost < 100 THEN 'Below 100'
        WHEN cost BETWEEN 100 AND 500 THEN 'Between 100 and 500'
        WHEN cost BETWEEN 501 AND 1000 THEN 'Between 501 and 1000'
        ELSE 'Above 1000'
    END AS cost_range
FROM gold.dim_products
)

SELECT
    cost_range,
    COUNT(*) AS product_count
FROM product_segments
GROUP BY cost_range
ORDER BY product_count DESC;