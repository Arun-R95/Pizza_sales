-- 1.Retrieve the total number of orders placed.
SELECT 
    COUNT(Order_id) AS Total_Orders
FROM
    pizzahut.orders;
-- 2.Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(Orders_details.Quantity * pizzas.price), 2) AS Total_Sales
FROM
    orders_details 
        JOIN
    pizzas  ON orders_details.pizza_id = pizzas.pizza_id;
    -- 3.Identify the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizzahut.pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1;
-- 4.Identify the most common pizza size ordered.
SELECT 
    pizzas.size,
    COUNT(orders_details.Order_details_id) AS Order_count
FROM
    pizzas
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY Order_count DESC;
-- 5.List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.Quantity) AS QTY
FROM
    orders_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY QTY DESC
LIMIT 5;
-- 1.Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.Quantity) AS QTY
FROM
    orders_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY QTY DESC;
-- Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(Order_time) AS hour, COUNT(Order_id) AS Order_Count
FROM
    orders
GROUP BY HOUR(Order_time);
-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;
-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity))
FROM
    (SELECT 
        orders.Order_date, SUM(Orders_details.Quantity) AS quantity
    FROM
        pizzahut.orders
    JOIN orders_details ON Orders_details.order_id = orders.order_id
    GROUP BY order_date) AS Order_quantity;
-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(orders_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;
-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pizza_types.category,
	ROUND (SUM(orders_details.quantity * pizzas.price) / (SELECT 
    ROUND(SUM(o.Quantity * p.price), 2) AS Total_Sales
FROM
    orders_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id) * 100,2) as revenue
from pizza_types
JOIN	pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details on orders_details.pizza_id = pizzas.pizza_id
Group by pizza_types.category
order by revenue desc;
-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pizza_types.category,
	ROUND (SUM(orders_details.quantity * pizzas.price) / (SELECT 
    ROUND(SUM(o.Quantity * p.price), 2) AS Total_Sales
FROM
    orders_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id) * 100,2) as revenue
from pizza_types
JOIN	pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details on orders_details.pizza_id = pizzas.pizza_id
Group by pizza_types.category
order by revenue desc;
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name, revenue 
FROM (SELECT  category,name,revenue, RANK() Over(partition by category order by revenue DESC) as rn
FROM
(SELECT pizza_types.category,pizza_types.name,sum((orders_details.Quantity) * pizzas.price) as  revenue
FROM pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
Join orders_details on orders_details.pizza_id =pizzas.pizza_id
group by pizza_types.category,pizza_types.name)as a) as b
where rn <= 3;


