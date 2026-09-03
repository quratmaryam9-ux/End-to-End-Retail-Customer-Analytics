SQL
-- ===============================================================================
-- Project: End-to-End Retail & Customer Analytics
-- Script 2: Deduplication, Key Enforcement & Star Schema Relational Integrity
-- Engine: Microsoft SQL Server / T-SQL
-- ===============================================================================

-- 1. Identify & Purge Exact Duplicate Records using CTE + ROW_NUMBER()
WITH DeduplicationCTE AS (
    SELECT *, 
           ROW_NUMBER() OVER(
               PARTITION BY Store_id, Store_name, Street_name, Postcode, District 
               ORDER BY Store_id
           ) AS DuplicateRank
    FROM dbo.DimStores
)
DELETE FROM DeduplicationCTE
WHERE DuplicateRank > 1;
GO

-- 2. Resolve Primary Key Conflicts by Appending Identifiers
WITH StoreKeyCTE AS (
    SELECT Store_id, 
           ROW_NUMBER() OVER(PARTITION BY Store_id ORDER BY Store_id) AS KeyRank
    FROM dbo.DimStores
)
UPDATE StoreKeyCTE
SET Store_id = Store_id + '-NEW'
WHERE KeyRank > 1;
GO

-- 3. Enforce Primary Key on Dimension Table
ALTER TABLE dbo.DimStores
ADD CONSTRAINT PK_DimStores PRIMARY KEY (Store_id);
GO

-- 4. Fact Table Standardization & Data Type Alignment
ALTER TABLE dbo.FactSales ALTER COLUMN Price_per_Unit DECIMAL(10,2);
ALTER TABLE dbo.FactSales ALTER COLUMN Total_Amount DECIMAL(10,2);
ALTER TABLE dbo.FactSales ALTER COLUMN Transaction_ID INT NOT NULL;
GO

-- 5. Enforce Fact Table Primary Key & Foreign Key Relationships
ALTER TABLE dbo.FactSales
ADD CONSTRAINT PK_FactSales PRIMARY KEY (Transaction_ID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_Stores
FOREIGN KEY (Store_id) REFERENCES dbo.DimStores(Store_id);
GO
