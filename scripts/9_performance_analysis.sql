/* Analyze the yearly performance of products by comparing each products sales 
to both its average sales performance and its previous year's sales. */
WITH yearly_product_sales AS (
SELECT
    YEAR(f.order_date) AS order_year,
    p.product_name,
    SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY 
    YEAR(f.order_date), 
    p.product_name
)

SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales_per_product,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg_sales,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg.'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg.'
        ELSE 'Equal to Avg.'        
    END AS avg_change,
    -- Year-Over-Year Analysis
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) AS prev_year_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) AS diff_prev_year_sales,
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) > 0 THEN 'Increased'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year ASC) < 0 THEN 'Decreased'
        ELSE 'No Change'        
    END AS previous_year_change
FROM yearly_product_sales
ORDER BY product_name ASC, order_year ASC;


/* Analyze the monthly performance of products by comparing each products sales 
to both its average sales performance and its previous month's sales. */
WITH monthly_product_sales AS (
SELECT
    DATETRUNC(MONTH, f.order_date) AS order_month,
    p.product_name,
    SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY 
    DATETRUNC(MONTH, f.order_date), 
    p.product_name
)

SELECT
    order_month,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales_per_product,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg_sales,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg.'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg.'
        ELSE 'Equal to Avg.'        
    END AS avg_change,
    -- Month-Over-Month Analysis
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month ASC) AS prev_month_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month ASC) AS diff_prev_month_sales,
    CASE
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month ASC) > 0 THEN 'Increased'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month ASC) < 0 THEN 'Decreased'
        ELSE 'No Change'        
    END AS previous_month_change
FROM monthly_product_sales
ORDER BY product_name ASC, order_month ASC;