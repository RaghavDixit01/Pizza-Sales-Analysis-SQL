-- 1. Retrieve the total number of orders placed
SELECT COUNT(order_id) AS total_orders
FROM orders;


-- 2. Calculate the total revenue generated from pizza sales
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id;


-- 3. Identify the highest-priced pizza
SELECT 
    pt.name AS pizza_name,
    p.price
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;


-- 4. Identify the most common pizza size ordered
SELECT 
    p.size,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_quantity DESC
LIMIT 1;


-- 5. Top 5 most ordered pizza types
SELECT 
    pt.name,
    SUM(od.quantity) AS total_ordered
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_ordered DESC
LIMIT 5;

-- 6. Total quantity of each pizza category ordered
SELECT 
    pt.category,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;


-- 7. Distribution of orders by hour of the day
SELECT 
    HOUR(order_time) AS order_hour,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;


-- 8. Category-wise distribution of pizzas
SELECT 
    pt.category,
    COUNT(od.order_details_id) AS total_orders
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;


-- 9. Average number of pizzas ordered per day
SELECT 
    ROUND(AVG(total_pizzas), 2) AS avg_pizzas_per_day
FROM (
    SELECT 
        o.order_date,
        SUM(od.quantity) AS total_pizzas
    FROM orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    GROUP BY o.order_date
) daily_orders;


-- 10. Top 3 pizza types based on revenue
SELECT 
    pt.name,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

-- 11. Percentage contribution of each pizza type to total revenue
SELECT 
    pt.name,
    ROUND(
        (SUM(od.quantity * p.price) /
        (SELECT SUM(od2.quantity * p2.price)
         FROM order_details od2
         JOIN pizzas p2 
         ON od2.pizza_id = p2.pizza_id)) * 100
    , 2) AS revenue_percentage
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue_percentage DESC;


-- 12. Cumulative revenue generated over time
SELECT 
    o.order_date,
    ROUND(
        SUM(od.quantity * p.price)
        OVER (ORDER BY o.order_date),
    2) AS cumulative_revenue
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN pizzas p
ON od.pizza_id = p.pizza_id;


-- 13. Top 3 pizza types based on revenue for each category
SELECT category, name, revenue
FROM (
    SELECT 
        pt.category,
        pt.name,
        ROUND(SUM(od.quantity * p.price), 2) AS revenue,
        RANK() OVER (
            PARTITION BY pt.category
            ORDER BY SUM(od.quantity * p.price) DESC
        ) AS rank_no
    FROM order_details od
    JOIN pizzas p
    ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
) ranked_pizzas
WHERE rank_no <= 3;
