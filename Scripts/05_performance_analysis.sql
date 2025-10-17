use DataWarehouse;
/* 
	PERFORMANCE ANALYSIS: Performance analysis helps us comparing the current value to the previous values.
	This explicit comparion helps us to guage the performance of a dimension against a Target value.

	We have window functions and Anlytical Functions to anaylize the performance. 
	We usually find the MIN, MAX, AVG, COUNT & SUM from the facts. and compare this these values against
	its previous values to chekc whether the current value is above the previous value or below it.
*/

-- Q  Analyze the yearly performance of products by comparing their sales to both the average sales perfromance of the product
   -- and the previous year's sales.

   WITH CTE_yearly_comparision AS(

   SELECT
	   YEAR(order_date) AS order_date,
	   p.product_name AS product_name,
	   SUM(f.sales_amount) AS current_sales
   FROM Gold.fact_sales f
   LEFT JOIN gold.dim_product p
   ON	f.product_key = p.product_key
   WHERE order_date is not null
   GROUP BY YEAR(order_date), p.product_name
   )
     
	SELECT 
		order_date,
		product_name,
		current_sales,
		AVG(current_sales) OVER (PARTITION BY product_name) AS avg_yearly,
		current_sales - AVG(current_sales) OVER (PARTITION BY product_name) diff_avg,
		CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
			 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
			 ELSE 'Avg'
		END AS avg_change,
		LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date ) py_sales,
		current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) diff_py,
		-- Year over year analysis..
		CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) > 0 THEN 'Increasing'
			 WHEN LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) < 0 THEN 'Decreasing'
			 ELSE 'No change'
		END AS py_change
		FROM CTE_yearly_comparision
		ORDER BY product_name, order_date 
		
