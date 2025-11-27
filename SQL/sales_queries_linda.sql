-- ================================================
--  Sales Analytics SQL Queries — Portfolio (Linda)
--  Fictional retail dataset for data analysis practice
-- ================================================

-- 1) Total Revenue and Total Orders
SELECT
    SUM(o.total_amount)        AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
WHERE o.status IN ('Completed', 'Shipped', 'Delivered');

-- 2) Monthly Sales Trend
SELECT
    c.year_month,
    SUM(o.total_amount) AS revenue
FROM orders o
JOIN calendar c
    ON c.date = o.order_date
WHERE o.status IN ('Completed', 'Shipped', 'Delivered')
GROUP BY c.year_month
ORDER BY c.year_month;

-- 3) Top 10 Products by Revenue
SELECT
    ol.product_id,
    p.product_name,
    p.category,
    SUM(ol.line_total) AS revenue
FROM order_lines ol
JOIN products p
    ON p.product_id = ol.product_id
JOIN orders o
    ON o.order_id = ol.order_id
WHERE o.status IN ('Completed', 'Shipped', 'Delivered')
GROUP BY ol.product_id, p.product_name, p.category
ORDER BY revenue DESC
LIMIT 10;

-- 4) Revenue by Country and Channel
SELECT
    o.country,
    o.channel,
    SUM(o.total_amount)           AS revenue,
    COUNT(DISTINCT o.order_id)    AS orders
FROM orders o
WHERE o.status IN ('Completed', 'Shipped', 'Delivered')
GROUP BY o.country, o.channel
ORDER BY revenue DESC;

-- 5) New vs Returning Customers per Month
WITH first_order AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    WHERE status IN ('Completed', 'Shipped', 'Delivered')
    GROUP BY customer_id
)
SELECT
    c.year_month,
    SUM(CASE WHEN o.order_date = f.first_order_date
             THEN o.total_amount ELSE 0 END) AS new_customer_revenue,
    SUM(CASE WHEN o.order_date > f.first_order_date
             THEN o.total_amount ELSE 0 END) AS returning_customer_revenue
FROM orders o
JOIN first_order f
    ON f.customer_id = o.customer_id
JOIN calendar c
    ON c.date = o.order_date
WHERE o.status IN ('Completed', 'Shipped', 'Delivered')
GROUP BY c.year_month
ORDER BY c.year_month;

-- 6) Average Order Value (AOV) by Channel
SELECT
    o.channel,
    SUM(o.total_amount) / NULLIF(COUNT(DISTINCT o.order_id), 0) AS avg_order_value
FROM orders o
WHERE o.status IN ('Completed', 'Shipped', 'Delivered')
GROUP BY o.channel
ORDER BY avg_order_value DESC;

-- 7) Top 10 Customers by Revenue
SELECT
    o.customer_id,
    c.full_name,
    SUM(o.total_amount) AS customer_revenue,
    COUNT(DISTINCT o.order_id) AS orders_count
FROM orders o
JOIN customers c
    ON c.customer_id = o.customer_id
WHERE o.status IN ('Completed', 'Shipped', 'Delivered')
GROUP BY o.customer_id, c.full_name
ORDER BY customer_revenue DESC
LIMIT 10;

-- 8) Revenue by Product Category
SELECT
    p.category,
    SUM(ol.line_total) AS revenue,
    COUNT(DISTINCT ol.product_id) AS distinct_products
FROM order_lines ol
JOIN products p
    ON p.product_id = ol.product_id
JOIN orders o
    ON o.order_id = ol.order_id
WHERE o.status IN ('Completed', 'Shipped', 'Delivered')
GROUP BY p.category
ORDER BY revenue DESC;
