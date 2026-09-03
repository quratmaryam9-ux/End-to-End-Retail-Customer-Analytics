SQL
-- ===============================================================================
-- Project: End-to-End Retail & Customer Analytics
-- Script 3: Analytical SQL Views (VIP Segmentation & Customer Lifetime Value)
-- Engine: Microsoft SQL Server / T-SQL
-- ===============================================================================

-- 1. VIP Customer Revenue Concentration View (Pareto Decile Analysis via NTILE)
CREATE OR ALTER VIEW dbo.vw_Customer_Revenue_Concentration AS
WITH CustomerTotals AS (
    SELECT 
        Customer_ID,
        SUM(Total_Amount) AS Total_Customer_Spend
    FROM dbo.FactSales
    GROUP BY Customer_ID
),
RankedCustomers AS (
    SELECT 
        Customer_ID,
        Total_Customer_Spend,
        NTILE(10) OVER (ORDER BY Total_Customer_Spend DESC) AS Revenue_Decile
    FROM CustomerTotals
)
SELECT 
    CASE 
        WHEN Revenue_Decile = 1 THEN 'Top 10% Customers (VIP)'
        ELSE 'Remaining 90% Customers'
    END AS Customer_Segment,
    COUNT(Customer_ID) AS Total_Customers,
    SUM(Total_Customer_Spend) AS Total_Revenue
FROM RankedCustomers
GROUP BY 
    CASE 
        WHEN Revenue_Decile = 1 THEN 'Top 10% Customers (VIP)'
        ELSE 'Remaining 90% Customers'
    END;
GO

-- 2. Customer Lifetime Value (CLV) Summary View
CREATE OR ALTER VIEW dbo.vw_Customer_Lifetime_Value AS
SELECT 
    Customer_ID,
    COUNT(Transaction_ID) AS Total_Orders,
    SUM(Total_Amount) AS Customer_Lifetime_Value,
    ROUND(AVG(Total_Amount), 2) AS Average_Order_Value
FROM dbo.FactSales
GROUP BY Customer_ID;
GO

-- 3. Ranked Transaction Sales View via DENSE_RANK()
CREATE OR ALTER VIEW dbo.vw_FactSales_Ranked AS
WITH RankedSales AS (
    SELECT 
        Store_id,
        Customer_ID,
        Date,
        Total_Amount,
        DENSE_RANK() OVER (ORDER BY Total_Amount DESC) AS Transaction_Rank
    FROM dbo.FactSales
)
SELECT Store_id, Customer_ID, Date, Total_Amount, Transaction_Rank
FROM RankedSales;
GO
