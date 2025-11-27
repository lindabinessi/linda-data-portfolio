-- customer_analysis_linda.sql
-- Simple queries for customer segmentation and behavior

-- 1) Number of customers by segment
SELECT
    segment,
    COUNT(*) AS customer_count
FROM customers
GROUP BY segment
ORDER BY customer_count DESC;

-- 2) Top 5 countries by number of customers
SELECT
    country,
    COUNT(*) AS customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC
LIMIT 5;
