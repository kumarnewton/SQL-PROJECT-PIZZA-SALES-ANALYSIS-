CREATE DATABASE PIZZAHUT;

CREATE TABLE ORDERS ( 
ORDER_ID INT NOT NULL,
ORDER_DATE DATE NOT NULL,
ORDER_TIME TIME NOT NULL,
PRIMARY KEY(ORDER_ID));

CREATE TABLE ORDER_DETAILS ( 
ORDER_DETAILS_ID INT NOT NULL,
ORDER_ID INT NOT NULL,
PIZZA_ID TEXT NOT NULL,
QUANTITY INT NOT NULL,
PRIMARY KEY(ORDER_DETAILS_ID));

DROP TABLE ORDER_DETAILS;

SELECT* FROM ORDER_DETAILS;

DELETE FROM ORDER_DETAILS;
SET SQL_SAFE_UPDATES=0;

-- Retrieve the total number of orders placed.

select count(order_id) as total_orders from orders;



 -- Calculate the total revenue generated from pizza sales.

SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
    
    -- Identify the highest-priced pizza.

select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;



-- Identify the most common pizza size ordered.

SELECT 
    PIZZAS.SIZE,
    COUNT(ORDER_DETAILS.ORDER_DETAILS_ID) AS ORDER_COUNT
FROM
    PIZZAS
        JOIN
    ORDER_DETAILS ON PIZZAS.PIZZA_ID = ORDER_DETAILS.PIZZA_ID
GROUP BY PIZZAS.SIZE
ORDER BY ORDER_COUNT DESC;



-- Determine the top 3 most ordered pizza types based on revenue

SELECT PIZZA_TYPES.NAME,
SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
FROM PIZZA_TYPES JOIN PIZZAS
ON PIZZAS.PIZZA_TYPE_ID = PIZZA_TYPES.PIZZA_TYPE_ID
JOIN ORDER_DETAILS
ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.NAME ORDER BY REVENUE DESC LIMIT 3;



-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category CATEGORY.

SELECT 
    PIZZA_TYPES.CATEGORY,
    SUM(ORDER_DETAILS.QUANTITY) AS QUANTITY
FROM
    PIZZA_TYPES
        JOIN
    PIZZAS ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
        JOIN
    ORDER_DETAILS ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.CATEGORY
ORDER BY QUANTITY DESC;


-- Determine the distribution of orders by hour of the day

SELECT 
    HOUR(ORDER_TIME) AS HOUR, COUNT(order_ID) AS ORDER_COUNT
FROM
    ORDERS
GROUP BY HOUR(ORDER_TIME);



-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT CATEGORY, COUNT(NAME) FROM PIZZA_TYPES
GROUP BY CATEGORY;



-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(QUANTITY), 0) AS AVG_PIZZA_ORDERED_PER_DAY
FROM
    (SELECT 
        ORDERS.ORDER_DATE, SUM(ORDER_DETAILS.QUANTITY) AS QUANTITY
    FROM
        ORDERS
    JOIN ORDER_DETAILS ON ORDERS.ORDER_ID = ORDER_DETAILS.ORDER_ID
    GROUP BY ORDERS.ORDER_DATE) AS ORDER_QUANTITY;
    
    
    
    -- Determine the top 3 most ordered pizza types based on revenue

SELECT PIZZA_TYPES.NAME,
SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
FROM PIZZA_TYPES JOIN PIZZAS
ON PIZZAS.PIZZA_TYPE_ID = PIZZA_TYPES.PIZZA_TYPE_ID
JOIN ORDER_DETAILS
ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.NAME ORDER BY REVENUE DESC LIMIT 3;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

 
select name, revenue from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <= 3;