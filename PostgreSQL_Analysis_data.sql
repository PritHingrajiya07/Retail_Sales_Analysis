CREATE DATABASE Sales_Analysis_P1;

DROP TABLE IF EXISTS ratail_sales;
CREATE TABLE retail_sales(
			transactions_id	INT		PRIMARY KEY,
			sale_date	DATE,
			sale_time	TIME,
			customer_id	INT,
			gender		Varchar(15),
			age			INT,
			category	Varchar(15),
			quantiy		INT,
			price_per_unit	Float,
			cogs		Float,
			total_sale	Float
);

SELECT * FROM retail_sales;

-- Import data using direct button select through
-- COPY .....

SELECT COUNT(*) FROM retail_sales;

	-- how to find out null value and clean it
SELECT * FROM retail_sales
WHERE transactions_id IS NUll;

SELECT * FROM retail_sales
WHERE sale_date IS Null;

	-- insted off one by one you can write all in one query
SELECT * FROM retail_sales
WHERE 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantiy IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL ;

--  now delecte null rows
DELETE FROM retail_sales
WHERE 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantiy IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL ;

	-- How many unique Customers we have?
SELECT COUNT(DISTINCT customer_id) as total_cus 
FROM retail_sales;

	-- How many Categorys are there
SELECT DISTINCT category 
FROM retail_sales;

	-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

	-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' 
				-- and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retail_sales
WHERE category = 'Clothing' 
	  AND to_char(sale_date, 'YYYY-MM') = '2022-11'
	  AND quantiy >= 4 ;

	-- 3.Write a SQL query to calculate the total sales for each category
SELECT category,  sum(total_sale) as sales,  count(*) as orders
FROM retail_sales
group by 1		-- here 1 meaning is that category is first in query

	-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT category,  round(AVG(age),2) as age,  AVG(price_per_unit) as price
FROM retail_sales
WHERE category = 'Beauty'
group by 1;

	-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *  FROM retail_sales
WHERE total_sale > 1000 ;

	-- 6.Write SQL query to find totalnumber of transactions (transaction_id) made by each gender in each category
SELECT category, gender, count(*) as total
FROM retail_sales
group by category, gender
order by 1 ;

	-- 7.Write SQL query to calculate the average sale for each month. Find out best selling month in each year
-- this is my query:
			SELECT  extract(YEAR FROM sale_date) as year,
					extract(MONTH FROM sale_date) as month, 
					avg(total_sale) as sale
			FROM retail_sales
			group by 1,2
			order by 3 DESC LIMIT 2;
-- This is proper right query
SELECT 
       year, month, avg_sale
FROM (    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
	WHERE rank = 1;


	-- 8.Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, sum(total_sale)
FROM retail_sales
group by 1
order by 2 DESC LIMIT 5;

	-- 9.Write SQL query to find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) as total_cus  
FROM retail_sales
group by 1;

	-- 10.Write a SQL query to create each shift and number of orders 
			-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17
WITH hourly_sales
as (
SELECT * , CASE
				WHEN EXTRACT(HOUR from sale_time) <12 THEN 'Morning'
				WHEN EXTRACT(HOUR from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
				ELSE 'Evening'
			END as Shift
FROM retail_sales
)
SELECT shift, COUNT(*) as total_orders
FROM hourly_sales
GROUP BY shift
