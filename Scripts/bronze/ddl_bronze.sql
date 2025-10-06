/*
=========================================
DDL Script: Create Bronze Tables
=========================================

Script Purpose: 
This script creates tables in the 'bronze' schema, dropping existing tables if they already exists.
Run this script to re-define the strcture of the 'Bronze' tables.

*/

IF OBJECT_ID ('Bronze.crm_cust_info', 'U') IS NOT NULL   -- Here U standas for User defined tables.
	DROP TABLE Bronze.crm_cust_info;
CREATE TABLE Bronze.crm_cust_info (
	cst_id INT, 
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

--prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt
IF OBJECT_ID ('Bronze.crm_prod','U') IS NOT NULL
	DROP TABLE Bronze.crm_prod;
CREATE TABLE Bronze.crm_prod (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);

--sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price

IF OBJECT_ID ('[Bronze].[crm_sales_details]','U') IS NOT NULL
	DROP TABLE [Bronze].[crm_sales_details];

CREATE TABLE [Bronze].[crm_sales_details] (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);


-- CID,BDATE,GEN

IF OBJECT_ID ('Bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE Bronze.erp_loc_a101
CREATE TABLE Bronze.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
);

IF OBJECT_ID ('Bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE Bronze.erp_cust_az12;
CREATE TABLE Bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
);

-- ID,CAT,SUBCAT,MAINTENANCE

IF OBJECT_ID ('Bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE Bronze.erp_px_cat_g1v2;
CREATE TABLE Bronze.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)
);

-- Develope Bulk Insert Method in Data Warehouse. First empty the table and then load the data.

ALTER PROCEDURE Bronze.load_bronze AS 
BEGIN
	DECLARE @starttime datetime, @endtime datetime;

	SET @starttime = GETDATE();
	BEGIN TRY
-- 1
	DECLARE @start_time datetime, @end_time datetime

	PRINT '===================================';
	PRINT 'Loading Bronze Layer';
	PRINT '===================================';

	PRINT'****************************************';
	PRINT'LOADING DATA INTO CRM TABLES';
	PRINT'****************************************';

	PRINT '-----------------------------------';
	PRINT 'TRUNCATING TABLE: crm_cust_info';
	PRINT'------------------------------------';

		TRUNCATE TABLE [Bronze].[crm_cust_info];

	PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
	PRINT 'INSERTING INTO TABLE: crm_cust_info'
	PRINT '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
PRINT'>> Start Time';
SET @start_time = GETDATE()

		BULK INSERT [Bronze].[crm_cust_info]
		FROM 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
SET @end_time = GETDATE();

PRINT'>> End time';
PRINT'Time taken to execute this table:' + CAST(Datediff(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
PRINT'**************************************************************************************';
-- 2
	PRINT '-----------------------------------';
	PRINT 'TRUNCATING TABLE: crm_prod';
	PRINT'------------------------------------';
	
		TRUNCATE TABLE [Bronze].[crm_prod];

	PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
	PRINT' INSERTING INTO TABLE crm_prod';
	PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';


SET @start_time = GETDATE();

		BULK INSERT Bronze.crm_prod
		FROM 'C:\Users\Admin\Documents\SQL Server Management Studio 21\prd_info.csv'
		WITH
		(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
SET @end_time = GETDATE()

PRINT'Satrt Time';
PRINT'Time taken to execute this table:' + CAST(datediff(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
PRINT'***************************************************************************************************************';
	
-- 3
	PRINT '----------------------------------------';
	PRINT 'TRUNCATING TABLE: crm_sales_details';
	PRINT '----------------------------------------';
	
		TRUNCATE TABLE [Bronze].[crm_sales_details];

	PRINT '----------------------------------------';
	PRINT' INSERTING INTO TABLE:crm_sales_details';
	PRINT '----------------------------------------';
SET @start_time = GETDATE();

		BULK INSERT [Bronze].[crm_sales_details]
		FROM 'D:\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);	

SET @end_time = GETDATE();

PRINT'Satrt Time';
PRINT'Time taken to execute this table:' + CAST(datediff(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
PRINT'***************************************************************************************************************';

-- 4
	PRINT'======================================';
	PRINT' LOADING DATA INTO ERP TABLES';
	PRINT'======================================';

	PRINT'---------------------------------------';
	PRINT'TRUNCATING TABLE: erp_loc_a101';
	PRINT'---------------------------------------';
		TRUNCATE TABLE Bronze.erp_loc_a101;

	PRINT'---------------------------------------';
	PRINT'INSERTING INTO TABLE: erp_loc_a101';
	PRINT'---------------------------------------';

SET @start_time = GETDATE();

		BULK INSERT Bronze.erp_loc_a101
		FROM 'D:\source_erp\loc_a101.csv'
		WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
		);
SET @end_time = GETDATE()

PRINT'Satrt Time';
PRINT'Time taken to execute this table:' + CAST(datediff(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
PRINT'***************************************************************************************************************';

-- 5
	PRINT'---------------------------------------';
	PRINT'TRUNCATING TABLE: erp_cust_az12';
	PRINT'---------------------------------------';

		TRUNCATE TABLE Bronze.erp_cust_az12;

	PRINT'---------------------------------------';
	PRINT'INSERTING INTO TABLE: erp_cust_az12';
	PRINT'---------------------------------------';

SET @start_time = GETDATE();

		BULK INSERT Bronze.erp_cust_az12
		FROM 'D:\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
SET @end_time = GETDATE();

PRINT'Satrt Time';
PRINT'Time taken to execute this table:' + CAST(datediff(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
PRINT'***************************************************************************************************************';

-- 6
	PRINT'---------------------------------------';
	PRINT'TRUNCATING TABLE:erp_px_cat_g1v2';
	PRINT'---------------------------------------';
	
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;

	PRINT'---------------------------------------';
	PRINT'INSERTING INTO TABLE:erp_px_cat_g1v2';
	PRINT'---------------------------------------';

SET @start_time = GETDATE();

		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'D:\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
SET @end_time = GETDATE();

PRINT'Satrt Time';
PRINT'Time taken to execute this table:' + CAST(datediff(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
PRINT'***************************************************************************************************************';

SET @endtime = GETDATE();
PRINT'>> Duration taken to run the entire code block ' + CAST(datediff(second, @starttime, @endtime) as NVARCHAR) + ' secods ';

	END TRY
		BEGIN CATCH
		PRINT'***************************************';
		PRINT'ERROR OCCURED LOADING BRONZE LAYER';
		PRINT'ERROR Message' + Error_Message();
		PRINT'ERROR NUMBER' + CAST(ERROR_NUMBER() as NVARCHAR);
		PRINT'ERROR STATE' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'***************************************';
	END CATCH
END
