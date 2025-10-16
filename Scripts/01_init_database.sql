/* 
==================================================
CREATE DATABASE AND SCHEMA
==================================================
Script Purpose:
This scripts creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it dropped and recreated. Additionally, the scripts sets up
three schemas within the database: Bronze, Silver, and Gold.

WARNING!
Running this script will drop the entire DataWarehouse databaseif it exists. All data in the
database will be permanantly deleted. Proceed with caution and ensure you have proper backup
before running this scripts.
*/

Use master;
GO

-- Drop and recreate database dataWarehouse
IF EXISTS (Select 1 from sys.databases WHERE name = 'DataWarehouse')
Begin
	ALTER Database DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
	END;
GO

--Create a 'datawarehouse' database

CREATE Database DataWarehouse;
Go

Use DataWarehouse;
GO

-- Create Schemas

CREATE SCHEMA Bronze;
Go

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO
