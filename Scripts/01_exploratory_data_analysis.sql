
/* 
========================================================================================================================
EXPLORATORY ANALYSIS:

Exploratory analysis helps us understanding the data that we are going to work on as how  many measures, dimensions are there
and what analysis and reposts we can create out of the data sets. This analysis provides an ariel view about the data.
========================================================================================================================
Purpose:

Find out what all dimensions and measures in the datasets and find the key KPIs from it. Like Count, Avg, MIN, MAX etc.
This metrics helps understanding what our data look like and what possbile reports we can create out of it.
==========================================================================================================================
*/

-- Explore all countries that our customers come from?

select distinct country from gold.dim_customers;

--  We have found that there 6 different Geographies from our customers are coming from.

/*               
n/a
Germany
United States
Australia
United Kingdom
Canada
France
*/

-- Explore all Product Categories "The Major Division".

Select DISTINCT category, subcategory, product_name from gold.dim_product
ORDER BY 1,2,3

/*
NULL
Accessories
Bikes
Clothing
Components
*/

-- Explore the Date Dimension.
-- This will help understanding the earliest and latest date values in the date dimension.
-- Then Min/Max combined with datediff() function will help finding all the crucial information about the date.

select 
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	datediff(Year, min(order_date), Max(order_date)) order_range_in_years,
	DATEDIFF(Month, MIN(order_date), MAX(order_date)) as order_range_in_months
from gold.fact_sales;

-- Find the youngest and oldest customers in our data.

select
	Min(birthdate) as oldest_customer,
	MAX(birthdate) as youngest_customer,
	DATEDIFF(Year, Min(birthdate), GETDATE()) as old_customer,
	DATEDIFF(Year, Max(birthdate), GETDATE()) as young_customer
From Gold.dim_customers;

-- Measure Exploration

-- Find the total sales 
select SUM(sales_amount) total_sales from gold.fact_sales

-- Find how many items are sold?
select SUM(quantity) total_quantity from gold.fact_sales

-- Find the average selling price.
select avg(price) avg_price from gold.fact_sales

-- Find total number of orders.
select count(order_number) AS total_orders from gold.fact_sales;
select count(DISTINCT order_number) total_sales from gold.fact_sales; -- USING DISTINCT will return only uniqe orders.


-- Find total number of products.
select count(product_key) AS total_product from gold.dim_product;
select count(DISTINCT product_key) from gold.dim_product;

-- Find total number of customers.
select COUNT(customer_key) AS total_customers from gold.dim_customers;

-- Find the total number of customer who have placed the order.
select COUNT(DISTINCT customer_key) AS total_customers from gold.fact_sales;

-- Generate report that shows all key metrics of our business

select 'Total Sales' as measure_value, SUM(sales_amount) total_sales from gold.fact_sales
	UNION ALL
	select 'Total Quantity' , SUM(quantity) total_quantity from gold.fact_sales
	UNION ALL
	select 'Avg Price',  avg(price) avg_price from gold.fact_sales
	UNION ALL
	select 'Total Nr. Orders', count(DISTINCT order_number) total_sales from gold.fact_sales
	UNION ALL
	select 'Total Nr. Products', count(DISTINCT product_key) from gold.dim_product
	UNION ALL
	select 'Total Nr. Customers', COUNT(customer_key) AS total_customers from gold.dim_customers

--Magnitude Analsis
/* In this magnitude analysis, we will first aggregate a specific measure and then split the value by a Dimension.
	This process helps us to see the actual values by dimensions and we can figure out which dimension is doing better or worst.
*/

-- Find the total orders by Countries.
select 
	country,
	COUNT(customer_key) AS total_customer
From gold.dim_customers
GROUP BY country
ORDER BY total_customer DESC;

-- Find total customers by gender.
select 
	gender,
	COUNT(customer_key) total_customer
from Gold.dim_customers
GROUP BY gender
ORDER BY total_customer DESC;

-- Find total products by category
select 
	category,
	count(product_key) as total_products
from Gold.dim_product
GROUP BY category
ORDER BY total_products DESC;

-- What is the average cost per category?
select 
	category,
	AVG(product_cost) as avg_cost
from gold.dim_product
GROUP BY category
ORDER BY avg_cost DESC;

-- What is the total revenue generated for each category?
select 
	p.category,
	sum(f.sales_amount) as total_revenue
from gold.fact_sales f
LEFT JOIN gold.dim_product p
ON p.product_key= f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Find total revenue geneated for each customer.
select 
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON	f.customer_key = c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC;

-- What is distribution of sold items across countries?
select 
	c.country,
	SUM(f.quantity) as total_sold_item
from Gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON	f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_item DESC;

-- RANKING ANALYSIS

-- Which 5 products generate the highest revenue?
select TOP 5 
	p.product_name,
	SUM(f.sales_amount) as total_revenue
from gold.fact_sales f
LEFT JOIN gold.dim_product p
ON	f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;


-- What are the 5 worst-performing products in terms of sales?

select TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
from gold.fact_sales f
LEFT JOIN gold.dim_product p
ON	f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Find the top and bottom 5 perfomers by using the WINDOW function.

SELECT
* 
	from (
		select 
		p.product_name,
		SUM(f.sales_amount) as total_revenue,
		ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) rank_numbr
	from gold.fact_sales f
	LEFT JOIN gold.dim_product p
	ON	f.product_key = p.product_key
	GROUP BY p.product_name
	) t
	Where rank_numbr <= 5

