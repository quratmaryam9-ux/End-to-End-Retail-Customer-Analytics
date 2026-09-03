SQL
-- ===============================================================================
-- Project: End-to-End Retail & Customer Analytics
-- Script 4: Customer Retention & Purchase Interval Analysis (LAG Function)
-- Engine: Microsoft SQL Server / T-SQL
-- ===============================================================================

-- Calculate Average Days Between Repeat Purchases Across Customer Cohorts
CREATE OR ALTER VIEW dbo.vw_Customer_Purchase_Intervals AS
WITH CustomerOrders AS (
    SELECT 
        Customer_ID,
        CAST(Date AS DATE) AS Order_Date,
        LAG(CAST(Date AS DATE)) OVER (
            PARTITION BY Customer_ID 
            ORDER BY CAST(Date AS DATE)
        ) AS Previous_Order_Date
    FROM dbo.FactSales
),
OrderGaps AS (
    SELECT 
        Customer_ID,
        Order_Date,
        Previous_Order_Date,
        DATEDIFF(day, Previous_Order_Date, Order_Date) AS Days_Between_Orders
    FROM CustomerOrders
    WHERE Previous_Order_Date IS NOT NULL
)
SELECT 
    AVG(Days_Between_Orders) AS Overall_Avg_Days_Between_Purchases
FROM OrderGaps;
GO
