use DataWarehouse;
/* -------------------------------------------------------------------------------------------
The below script finds the moving average and runnig total.
---------------------------------------------------------------------------------------------*/

select
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) as running_total,
AVG(avg_price) OVER (ORDER BY order_date) as moving_average
FROM 
	(
	select
		DATETRUNC(YEAR, order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	From  gold.fact_sales
	WHERE order_date is not null
	GROUP BY DATETRUNC(year, order_date)) t;

	-- Find moving average of sales price over months.

SELECT
	Order_date,
	AVG(avg_price) OVER (PARTITION BY Order_date ORDER BY Order_date) AS moving_average
FROM 
(
	SELECT
	Datetrunc(Month, order_date) AS Order_date,
	AVG(price) AS avg_price
	FROM Gold.fact_sales
	WHERE order_date is not null
	GROUP BY Datetrunc(Month, order_date)) t;
