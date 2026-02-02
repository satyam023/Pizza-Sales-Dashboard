/* =========================================================
   PIZZA SALES ANALYTICS – MYSQL VERSION
   ========================================================= */
USE pizza_db;

/* =========================
   A. KPI’s
   ========================= */

-- 1. Total Revenue 
SELECT 
    SUM(total_price) AS total_revenue
FROM pizza_sales_data;


-- 2. Average Order Value
SELECT 
    ROUND(SUM(total_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM pizza_sales_data;


-- 3. Total Pizzas Sold
SELECT 
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales_data;


-- 4. Total Orders
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_data;


-- 5. Average Pizzas Per Order
SELECT 
    ROUND(SUM(quantity) / COUNT(DISTINCT order_id), 2) AS avg_pizzas_per_order
FROM pizza_sales_data;



/* =========================
   B. Daily Trend for Total Orders
   ========================= */

SELECT 
    DAYNAME(order_date) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_data
GROUP BY DAYNAME(order_date)
ORDER BY total_orders DESC;



/* =========================
   C. Monthly Trend for Orders
   ========================= */

SELECT 
    MONTHNAME(order_date) AS month_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_data
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);

/* =========================
   D. % of Sales by Pizza Category
   ========================= */

WITH category_sales AS (
    SELECT
        pizza_category,
        SUM(total_price) AS category_revenue
    FROM pizza_sales_data
    GROUP BY pizza_category
)
SELECT
    pizza_category,
    ROUND(category_revenue, 2) AS total_revenue,
    ROUND(
        category_revenue * 100
        / SUM(category_revenue) OVER (),
        2
    ) AS pct_sales
FROM category_sales
ORDER BY pct_sales DESC;

/* =========================
   E. % of Sales by Pizza Size
   ========================= */

WITH size_sales AS (
    SELECT
        pizza_size,
        SUM(total_price) AS size_revenue
    FROM pizza_sales_data
    GROUP BY pizza_size
)
SELECT
    pizza_size,
    ROUND(size_revenue, 2) AS total_revenue,
    ROUND(
        size_revenue * 100
        / SUM(size_revenue) OVER (),
        2
    ) AS pct_sales
FROM size_sales
ORDER BY pct_sales DESC;



/* =========================
   F. Total Pizzas Sold by Pizza Category (February)
   ========================= */

SELECT 
    pizza_category,
    SUM(quantity) AS total_quantity_sold
FROM pizza_sales_data
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY total_quantity_sold DESC;



/* =========================
   G. Top 5 Pizzas by Revenue
   ========================= */

SELECT 
    pizza_name,
    SUM(total_price) AS total_revenue
FROM pizza_sales_data
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5;



/* =========================
   H. Bottom 5 Pizzas by Revenue
   ========================= */

SELECT 
    pizza_name,
    SUM(total_price) AS total_revenue
FROM pizza_sales_data
GROUP BY pizza_name
ORDER BY total_revenue ASC
LIMIT 5;



/* =========================
   I. Top 5 Pizzas by Quantity
   ========================= */

SELECT 
    pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales_data
GROUP BY pizza_name
ORDER BY total_pizzas_sold DESC
LIMIT 5;



/* =========================
   J. Bottom 5 Pizzas by Quantity
   ========================= */

SELECT 
    pizza_name,
    SUM(quantity) AS total_pizzas_sold
FROM pizza_sales_data
GROUP BY pizza_name
ORDER BY total_pizzas_sold ASC
LIMIT 5;



/* =========================
   K. Top 5 Pizzas by Total Orders
   ========================= */

SELECT 
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_data
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5;



/* =========================
   L. Bottom 5 Pizzas by Total Orders
   ========================= */

SELECT 
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_data
GROUP BY pizza_name
ORDER BY total_orders ASC
LIMIT 5;



/* =========================
   FILTER EXAMPLE (Category / Size)
   ========================= */

-- Bottom 5 Classic Pizzas by Orders
SELECT 
    pizza_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales_data
WHERE pizza_category = 'Classic'
GROUP BY pizza_name
ORDER BY total_orders ASC
LIMIT 5;
