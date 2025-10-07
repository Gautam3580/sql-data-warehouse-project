-- Develope Bulk Insert Method in Data Warehouse. First empty the table and then load the data.
/*
	CREATE STORE PROCEDURE FOR BRONZE LAYER: 
	Created stored procedure for inserting bulk data into the table. First the procedure will truncate the table and then 
	insert into the tables.
*/

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
