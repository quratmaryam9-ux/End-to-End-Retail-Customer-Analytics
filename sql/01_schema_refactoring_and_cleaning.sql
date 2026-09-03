SQL
-- ===============================================================================
-- Project: End-to-End Retail & Customer Analytics
-- Script 1: Schema Refactoring, Standardization & Initial Data Cleaning
-- Engine: Microsoft SQL Server / T-SQL
-- ===============================================================================

-- 1. Rename Raw Tables to Enterprise Dimensional Conventions
EXEC sp_rename 'dbo.[stadsdeel]', 'DimDistrict';
EXEC sp_rename 'dbo.[winkelstraat_straat]', 'DimStores';
EXEC sp_rename 'dbo.[Sales Transaction]', 'FactSales';
GO

-- 2. Drop Metadata & Irrelevant Spatial Columns
ALTER TABLE dbo.DimStores
DROP COLUMN objectid, thema, type, subtype, laagste_niveau, hoogste_niveau, lengte, shape_length;
GO

-- 3. Standardize Column Names Across Dimensions
EXEC sp_rename 'dbo.DimStores.id', 'Store_id', 'COLUMN';
EXEC sp_rename 'dbo.DimStores.naam', 'Store_name', 'COLUMN';
EXEC sp_rename 'dbo.DimStores.straatnaam', 'Street_name', 'COLUMN';
EXEC sp_rename 'dbo.DimStores.postcode', 'Postcode', 'COLUMN';
EXEC sp_rename 'dbo.DimStores.district', 'District', 'COLUMN';
GO

-- 4. Optimize Data Types for Performance & Storage Efficiency
ALTER TABLE dbo.DimStores ALTER COLUMN Store_id VARCHAR(20) NOT NULL;
ALTER TABLE dbo.DimStores ALTER COLUMN Postcode VARCHAR(10);
ALTER TABLE dbo.DimStores ALTER COLUMN Store_name NVARCHAR(100);
ALTER TABLE dbo.DimStores ALTER COLUMN Street_name NVARCHAR(150);
ALTER TABLE dbo.DimStores ALTER COLUMN District NVARCHAR(100);
GO

-- 5. Handle Missing / Null Records
UPDATE dbo.DimStores
SET Street_name = 'Unknown'
WHERE Street_name IS NULL;
GO
