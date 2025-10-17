use DataWarehouse;

/* ========================================================================================================
	ADVANCED ANALYTICS:
	-- In this section we will apply all the advanced techniques for analyzing data. 
  ========================================================================================================

  ========================================================================================================
   */

   -- 1. Changes Over Time Analysis

   select 
	   Year(order_date) as order_year,
	   SUM(sales_amount) as total_sales,
	   SUM(quantity) as total_quantity,
	   COUNT(DISTINCT customer_key) as total_customers
   from Gold.fact_sales
   WHERE order_date is not null
   Group By Year(order_date)
   ORDER BY Year(order_date);

   -- If we group the data by Months then it will help us finding the seasonality in the data. In which month the sales was
    -- higher and lower.

   select 
	   MONTH(order_date) as order_month,
	   SUM(sales_amount) as total_sales,
	   SUM(quantity) as total_quantity,
	   COUNT(DISTINCT customer_key) as total_customers
   from Gold.fact_sales
   WHERE order_date is not null
   Group By MONTH(order_date)
   ORDER BY MONTH(order_date);

   -- To find the detailed insights by Year and Month granularity, we will use DATETRUNC() function.

   select 
	   DATETRUNC(Month, order_date) as order_date,
	   SUM(sales_amount) as total_sales,
	   COUNT(DISTINCT customer_key) as total_customers,
	   SUM(quantity) as total_quantity
   from Gold.fact_sales
   WHERE order_date is not null
   GROUP BY DATETRUNC(Month, order_date)
   ORDER BY DATETRUNC(Month, order_date)

   -- There are different DTES formats that we can try out for and see the output the way you want it.
     
   Select 
	   FORMAT(order_date, 'MMM-yyyy') as order_date,
	   SUM(sales_amount) as total_sales
	   From gold.fact_sales
   where order_date is not null
   GROUP BY FORMAT(order_date, 'MMM-yyyy')
   ORDER BY FORMAT(order_date, 'MMM-yyyy');

   -- NOTE : Just make sure when you change the original date format to any other format the sorting will go into toss. 
   -- Keep your eye on the changes of the unsorted report.
  
  With yearly_performance AS (

      select 
	   DATETRUNC(YEAR, order_date) as order_date,
	   SUM(sales_amount) as current_sales,
	   COUNT(DISTINCT customer_key) as total_customers,
	   SUM(quantity) as total_quantity
   from Gold.fact_sales
   WHERE order_date is not null
   GROUP BY DATETRUNC(YEAR, order_date)
   )

 Select
	order_date,
	current_sales,
	sum(current_sales) OVER (PARTITION BY order_date) AS sales_by_customer
	From yearly_performance
	GROUP BY order_date, current_sales
	HAVING current_sales > 50000
