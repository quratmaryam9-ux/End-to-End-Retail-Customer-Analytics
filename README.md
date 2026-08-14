## End-to-End-Retail-Customer-Analytics

### Dashboard Link: 

## Business Problem and Strategic Context:

This project evaluates retail sales performance, customer purchasing behavior, and pricing dynamics across **Beauty, Clothing and Electronics** categories in **Antwerp, Belgium** region. By combining public demographic data from Antwerp with commercial transaction records, this project delivers actionable results to optimize product margins, improve customer retention, and improve Average Order Value (AOV). 

## Key Strategic Findings & Recommendations:

* **Price Elasticity & Cross-Category Bundeling:** An inverse relationship has been observed between unit price and sales volume. Cross-category bundling **(e.g., Pairing high-margin Beauty products with high-volume Clothing products)** can drive higher total order value.
* **Basket Size & Multi-Order Purchasing:** Orders show consistent multi-order purchases pattern across all categories **(Average 2.51 Items per category)**. Multi-buy incentives **(e.g., Buy 3 & Get 4 at 20% off)** will further nudge 1- to 2- items buyers into higher tiers.
* **Seasonality & Demand Forcasting:** Clear annual sale seasonality are identified, peaking in May and Q4, with a sharp drop in October. Pre-planning inventory and promotional campaigns prior to high-demand months will prevent stock-out and better planning for low sale months.
* **Customers Concentration Risk (80/20 Rule):** The top 10% VIP customers generate **38.2% of total store revenue.** Targeted VIP loyalty programs for this high-value customer segment is crucial to safegaud revenue.

## Data Engineering & Analytical Workflow:

### **Step 1: Data Acquisition & Integration:**

Ingested official public demographic dataset from **OPEN DATA ANTWERPEN (Stad Antwerpen)** and integrated them with commercial retail transaction data from **Kaggle** to analyze regional market distribution and spending patterns. 

### **Step 2:Database Setup & Transformation:**

Loaded raw data into Azure SQL via SQL Server Management Studio (SSMS). Executed custom T-SQL transformation queries and database views to clean and structure data. 

### **Step 3: Data Profiling & Quality Check:**

Evaluated data quality by checking null values. However, data has no null values. Inconsistent types of data is given proper data type such as text, char, varchar, nchar, nvarchar, date. Duplicate records are removed in order to maintain the data integrity. 

### **Step 4: Data Modeling & Star Schema:** 

Structured a clean Star Schema by separating data into three dimension tables and one core fact table.
Dimcustomer (Customer Attributes)
Dimdistrict (Demography & Geography)
Dimstores (Stores locations)
FactSales (Core Transaction Metrics)

### **Step 5: Relational Key Mapping:**

Assigned primary and foreign keys by establishing strict 1 to many relationships between dimension tables and fact table. 

## **Exploratory Data Analysis(EDA) & DAX Development:**

### **Step 6: Price & Elasticity Analysis:**

Built a scatter plot in PowerBI comparing 'Price_Per_Unit' against 'Quantity'. A linear trendline is applied through further analysis visual, proving a near-zero correlation and confirming an inelastic demand curve across core retail products. 

### **Step 7: Category Pricing & AOV:**

Created combo charts (line + Clustered Column) and financial summary tables to evaluate category revenue contribution. Developed DAX KPI measures. 

#### **DAX Measure**

                        - Average unit price = AVERAGE(FactSales[Price_per_Unit])
                        - Total Quantity Sold = SUM(FactSales[Quantity])
                        - AOV = DIVIDE([Total Revenue], [Total orders],0)

### **Step 8: Basket Size Statistical Profiling:**

Created quantity bins (sizes 1 through 4) using Power BI's grouping features. Computed core statistical metrics via DAX to evaluate transaction distribution.

#### **DAX Measure**

                        - Mean Quantity = AVERAGE(FactSales[Quantity])
                        - Median Quantity = MEDIAN(FactSales[Quantity])
                        - Min Quantity = MIN(FactSales[Quantity])
                        - Max Quantity = MAX(FactSales[Quantity])
                        - StdDev Quantity = STDEV.S(FactSales[Quantity])

### **Step 9: Category-Level Basket Behavior:**

Evaluated category basket consistency using Matrix tables and Bar charts, proving an identical 2.51 average basket size across Clothing, Electronics, and Beauty.


#### **DAX Measure**

                        - Average Basket Size = AVERAGE(vw_FactSales2[Quantity])

### **Step 10: Executive Sales Trends & Performances:**

Built continuous time-series line charts and horizontal bar charts to track monthly revenue patterns and product performance by category. KPI cards are included with slicers to observe the data in different time period. 


#### **DAX Measure**

                        - Total Revenue = SUM(vw_Factsales1[total_amount])
                        - Total orders = DISTINCTCOUNT(vw_Factsales1[transaction_id])
                        - Average Order Value = DIVIDE([Total Revenue],[Total orders],0)

## Advanced T-SQL Logic & Window Functions:

### **Step 11: Customer Revenue Segmentation (Decile Ranking):**

Used NTILE(10) window functions in SQL to calculate revenue concentration and isolate the top 10 VIP tier. 

#### **SQL**


                       - CREATE VIEW vw_Customer_Revenue_Concentration AS
                         WITH CustomerDeciles AS (
                           SELECT
                               Customer_ID,
                               Total_Amount,
                               NTILE(10) OVER (ORDER BY Total_Amount DESC) AS Decile
                           FROM FactSales
                         )
                         SELECT
                            CASE
                                WHEN Decile = 1 THEN 'Top 10% Customers (VIP)'
                                ELSE 'Remaining 90% Customers'
                              END AS Customer_Segment,
                              COUNT(Customer_ID) AS Total_Customers,
                              SUM(Total_Amount) AS Segment_Revenue,
                              ROUND((SUM(Total_Amount) / SUM(SUM(Total_Amount)) OVER()) * 100, 2) AS Revenue_Share_Pct
                         FROM CustomerDeciles
                         GROUP BY
                             CASE
                                WHEN Decile = 1 THEN 'Top 10% Customers (VIP)'
                                ELSE 'Remaining 90% Customers'
                             END;

### **Step 12: Customer Life-Time Value (CLV):**

Executed 'INNER JOIN' queries between Factsales and dimcustomer to identify top spenders profile. 

#### **SQL**

                        - SELECT TOP 10
                             c.Customer_ID,
                             SUM(s.Total_Amount) AS Customer_Lifetime_Value
                          FROM FactSales s
                          JOIN DimCustomer c
                             ON s.Customer_ID = c.Customer_ID
                          GROUP BY
                             c.Customer_ID
                          ORDER BY
                             Customer_Lifetime_Value DESC;

                          CREATE VIEW vw_Customer_Lifetime_Value AS
                          SELECT
                             Customer_ID,
                             SUM(Total_Amount) AS Customer_Lifetime_Value
                          FROM FactSales
                          GROUP BY Customer_ID;

### **Step 13: Retention Tracking & Purchase Gap:

Engineered a T-SQL query utilizing LAG() and DATEDIFF() to calculate the average repeat purchase interval.


#### **SQL**

                        - WITH CustomerOrders AS (
                             SELECT
                               Customer_ID,
                               Date,
                               LAG(Date) OVER (
                               PARTITION BY Customer_ID
                               ORDER BY Date
                               ) AS Previous_Order_Date
                             FROM FactSales
                          ),
                          OrderGaps AS (
                          SELECT
                             Customer_ID,
                             Date,
                             Previous_Order_Date,
                             DATEDIFF(day, Previous_Order_Date, Date) AS Days_Between_Orders
                            FROM CustomerOrders
                          WHERE Previous_Order_Date IS NOT NULL
                          )
                         SELECT
                            AVG(Days_Between_Orders) AS Avg_Days_Between_Purchases
                         FROM OrderGaps;

#### **Data Quality Insights:** 
The query returned NULL because every customer record currently contains exactly one order, indicating that customer repeat retention is 0% and highlighting a critical business opportunity for automated post-purchase marketing.

## **Executive Dashboards Summary Insights:**

## **Product Pricing Impact:**

<img width="1315" height="727" alt="Image" src="https://github.com/user-attachments/assets/10599f2a-e1e9-426f-966c-c9284ba941c5" />

## **EDA: PRICING ANALYSIS:**

<img width="1311" height="756" alt="Image" src="https://github.com/user-attachments/assets/c14f38a0-36bc-4c80-af48-bc7678963314" />

## **EDA: Basket Size:**

<img width="1348" height="718" alt="Image" src="https://github.com/user-attachments/assets/20b35898-9cac-471d-9374-90c81d5effc1" />

## **EDA: Basket Size by Category:**

<img width="1353" height="752" alt="Image" src="https://github.com/user-attachments/assets/43d028cb-b86e-4353-ac5c-c565de557eb1" />

## **Sales Trends:**

<img width="1355" height="762" alt="Image" src="https://github.com/user-attachments/assets/c8518961-f281-4990-8c9a-a0745b7c00c0" />

## **Customers Retention & Spendings:

<img width="1343" height="752" alt="Image" src="https://github.com/user-attachments/assets/c3185319-f519-4421-853f-fa9294ddf1b8" />

