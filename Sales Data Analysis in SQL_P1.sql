-- Sales Data Analysis in SQL_P1

CREATE DATABASE IF NOT EXISTS product_db;

USE product_db;

-- CREATE TABLE
DROP TABLE IF EXISTS products;
CREATE TABLE products
			(
			   product_id INT PRIMARY KEY, 
			   product_name VARCHAR(255), 
			   product_category VARCHAR(60)
			);               
            
            
-- # Data Overview
SELECT * FROM products
LIMIT 10;

SELECT * FROM orders
LIMIT 10;

SELECT * FROM accounts
LIMIT 10;

DESCRIBE orders;
DESCRIBE products;
DESCRIBE accounts;

-- To check how many records there are in each datasets
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM accounts;

SET SQL_SAFE_UPDATES = 0;


-- # Data Cleaning and Data Preparation

-- To change the data type of the two columns order_date & ship_date from "text" to "date"
UPDATE orders
SET order_date= STR_TO_DATE(order_date,'%m/%d/%Y'),
    ship_date= STR_TO_DATE(ship_date,'%m/%d/%Y'); 
    
ALTER TABLE orders
MODIFY COLUMN order_date date,
MODIFY COLUMN ship_date date; 

SELECT COUNT(*) FROM orders
WHERE order_no IS NULL;

SELECT * FROM orders
WHERE order_date IS NULL OR 
      customer_name IS NULL OR
      address IS NULL OR
      city IS NULL OR
      state IS NULL OR
      customer_type IS NULL OR
      account_id IS NULL OR
      order_priority IS NULL OR
      product_id IS NULL OR
      product_container IS NULL OR
      ship_mode IS NULL OR
      ship_date IS NULL OR
      cost_price IS NULL OR
      retail_price IS NULL OR
      order_quantity IS NULL OR
      sub_total IS NULL OR
      order_total IS NULL OR
      shipping_cost IS NULL OR
      total IS NULL; 
      
DELETE FROM orders
WHERE order_date IS NULL OR 
      customer_name IS NULL OR
      address IS NULL OR
      city IS NULL OR
      state IS NULL OR
      customer_type IS NULL OR
      account_id IS NULL OR
      order_priority IS NULL OR
      product_id IS NULL OR
      product_container IS NULL OR
      ship_mode IS NULL OR
      ship_date IS NULL OR
      cost_price IS NULL OR
      retail_price IS NULL OR
      order_quantity IS NULL OR
      sub_total IS NULL OR
      order_total IS NULL OR
      shipping_cost IS NULL OR
      total IS NULL; 
      
-- Check for duplicate values
SELECT order_no, COUNT(order_no) FROM orders
GROUP BY order_no
HAVING COUNT(order_no) > 1;

SELECT * FROM orders
WHERE order_no ='5768-2' OR order_no ='6159-2';

SET SQL_SAFE_UPDATES = 1;


-- # Data Analysis & Business Key Problems & Answers

-- Q-1.What is the total revenue generated by each product category?
-- Q-2.How many unique products have been ordered?
-- Q-3.What is the total revenue generated each year?
-- Q-4.What is the date of the latest and earliest order?
-- Q-5.What product category has the lowest average price of products?
-- Q-6.What are the top 10 highest performing products? 
-- Q-7.Show the total revenue and profit generated by each account manager?
-- Q-8.What is the name, city and account manager of the highest selling products in 2017?
-- Q-9.Find the mean amount spent per order by each customer type.
-- Q-10.What are the five(5) highest selling products? 
-- Q-11.What is the 5th highest selling product? 


-- Now answer the following business questions step by step. 

-- Q-1. What is the total revenue generated by each product category?
SELECT product_category, ROUND(SUM(total), 2) AS revenue
FROM orders
JOIN products
ON orders.product_id = products.product_id
GROUP BY product_category;

 
-- Q-2.	How many unique products have been ordered?
SELECT (COUNT(DISTINCT product_name)) AS unique_products
FROM products; 


-- Q-3.	What is the total revenue generated each year?
SELECT EXTRACT(YEAR from order_date) AS year,
ROUND(SUM(total), 2) AS revenue
FROM orders
GROUP BY year;


-- Q-4.What is the date of the latest and earliest order?
SELECT MIN(order_date) AS earliest_date,
MAX(order_date) AS latest_date
FROM orders;


-- Q-5.What product category has the lowest average price of products?
SELECT product_category, ROUND(AVG(retail_price), 2) AS average_price
FROM orders
JOIN products
USING (product_id)
GROUP BY product_category
ORDER By average_price
LIMIT 1;


-- Q-6.What are the top 10 highest performing products? 
SELECT DISTINCT product_name, ROUND(SUM(total), 2) AS revenue
FROM products
JOIN orders
USING(product_id)
GROUP BY product_name 
ORDER BY revenue DESC
LIMIT 10;


-- Q-7.Show the total revenue and profit generated by each account manager?
SELECT account_manager, 
ROUND(SUM(total), 2) AS revenue, 
ROUND((SUM(total)-SUM(cost_price)), 2) AS profit
FROM orders
JOIN accounts
USING(account_id)
GROUP BY account_manager
ORDER BY revenue;


-- Q-8.What is the name, city and account manager of the highest selling products in 2017?
SELECT product_name, city, account_manager, ROUND(SUM(total), 2) AS revenue
FROM orders
JOIN products
USING(product_id)
JOIN accounts
USING(account_id)
WHERE EXTRACT(year from order_date)=2017
GROUP BY product_name, city, account_manager
ORDER BY revenue DESC
LIMIT 1;


-- Q-9.Find the mean amount spent per order by each customer type.
SELECT customer_type, ROUND(AVG(total), 2) AS average_amount
FROM orders
GROUP BY customer_type;


-- Q-10.What are the five(5) highest selling products? 
SELECT product_name, ROUND(SUM(total), 2) AS revenue
FROM products
JOIN orders
USING(product_id)
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;


-- Q-11.What is the 5th highest selling product? 
SELECT product_name, ROUND(SUM(total), 2) AS revenue
FROM products
JOIN orders
USING(product_id)
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 1 OFFSET 4; 


-- End of Project
