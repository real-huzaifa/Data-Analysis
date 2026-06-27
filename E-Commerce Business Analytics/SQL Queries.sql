-- ============================================================
-- CAPSTONE PROJECT — E-Commerce Business Analytics
-- SQL: Metric Extraction & Six Business Questions
-- ============================================================


-- ============================================================
-- KEY METRICS — Headline KPIs
-- ============================================================
SELECT
  COUNT(DISTINCT o.order_id)                                   AS total_orders,
  ROUND(SUM(oi.quantity * oi.unit_price), 2)                   AS total_revenue,
  ROUND(SUM(oi.quantity * (oi.unit_price - p.cost_price)), 2)  AS total_profit,
  ROUND(SUM(oi.quantity * oi.unit_price) * 1.0
        / COUNT(DISTINCT o.order_id), 2)                       AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.status = 'Completed';


-- ============================================================
-- BUSINESS QUESTION 1
-- Which product categories drive the most revenue and profit?
-- ============================================================
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2)                  AS revenue,
       ROUND(SUM(oi.quantity * (oi.unit_price - p.cost_price)), 2) AS profit,
       ROUND(100.0 * SUM(oi.quantity * (oi.unit_price - p.cost_price))
             / SUM(oi.quantity * oi.unit_price), 1)                AS margin_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;


-- ============================================================
-- BUSINESS QUESTION 2
-- How does revenue trend month over month?
-- ============================================================
SELECT substr(o.order_date, 1, 7)                AS month,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
       COUNT(DISTINCT o.order_id)                AS orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY month
ORDER BY month;


-- ============================================================
-- BUSINESS QUESTION 3
-- Which sales channel performs best by revenue and AOV?
-- ============================================================
SELECT o.channel,
       COUNT(DISTINCT o.order_id)                 AS orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
       ROUND(SUM(oi.quantity * oi.unit_price) * 1.0
             / COUNT(DISTINCT o.order_id), 2)     AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.channel
ORDER BY revenue DESC;


-- ============================================================
-- BUSINESS QUESTION 4
-- Who are the top 10 customers by lifetime revenue?
-- ============================================================
SELECT c.customer_id,
       c.customer_name,
       c.country,
       COUNT(DISTINCT o.order_id)                 AS orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS lifetime_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c    ON o.customer_id = c.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.country
ORDER BY lifetime_revenue DESC
LIMIT 10;


-- ============================================================
-- BUSINESS QUESTION 5
-- How much revenue is tied up in cancellations and returns?
-- ============================================================
SELECT o.status,
       COUNT(DISTINCT o.order_id)                 AS orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
       ROUND(100.0 * COUNT(DISTINCT o.order_id)
             / (SELECT COUNT(*) FROM orders), 1)  AS pct_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.status
ORDER BY revenue DESC;


-- ============================================================
-- BUSINESS QUESTION 6
-- Which customer segment + country combinations are most valuable?
-- ============================================================
SELECT c.segment,
       c.country,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c    ON o.customer_id = c.customer_id
WHERE o.status = 'Completed'
GROUP BY c.segment, c.country
ORDER BY revenue DESC
LIMIT 10;


-- ============================================================
-- End of queries
-- ============================================================
