--SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

--Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender	VARCHAR(15),
	age	INT,
	category VARCHAR(15),	
	quantiy	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

-- Exploratory Data Analysis 
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- CHECK FOR NULL VALUES
SELECT * FROM retail_sales
	WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- DELETE NULL VALUES
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Data Exploration


-- Total Sales records
SELECT COUNT(*) AS total_sale FROM retail_sales;
--How many unique customers we have
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

--Data Analysis and business key problems
-- Q1. Write a SQL query to retrieve all columns for sales made on '2012-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
-- Q2. Write a SQL Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
	AND 
	TO_CHAR (sale_date,'YYYY-MM') = '2022-11'
	AND
	quantiy >=4
;
-- Write a SQL Query to calculate the total sales (total_sale) for each category
SELECT 	Sum(total_sale),
category
FROM retail_sales
GROUP BY category;
-- Average age of customers who purchased items from the beauty category

SELECT ROUND (Avg(age),2) FROM retail_sales
WHERE category = 'Beauty';

-- Find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Find total number of transactions made by each gender in each category

SELECT 
	category,
	gender,
	COUNT(*) AS number_of_transactions
FROM retail_sales
GROUP BY 
	category, 
	gender
ORDER BY 1;

-- Calculate the average sale for each month. Find out best selling month in each year
SELECT 
year,
month,
avg_sale
FROM
(SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) AS rank
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE rank=1
ORDER BY 1,3 DESC;

-- Find the top 5 customers based on the highest total_sales
SELECT 
	customer_id,
	SUM(total_sale)
FROM retail_sales
	GROUP BY customer_id
	ORDER BY SUM(total_sale) DESC
	LIMIT 5;
-- Find the number of unique customers who purchased items from each category

SELECT 
	category,
	COUNT(DISTINCT customer_id ) as cnt_unique_customers
	FROM retail_sales
	GROUP BY category;
-- Create each shift and number of orders( Example Morning<=12, Afternoon Between 12 and 17. Evening >17)
WITH hourly_sale
AS
(SELECT *,
CASE 
	WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT shift,
COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

--SELECT EXTRACT (HOUR FROM CURRENT_TIME);
-- END OF PROJECT