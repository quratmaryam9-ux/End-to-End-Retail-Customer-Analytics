## End-to-End-Retail-Customer-Analytics

## Business Problem and Stategic Context:

This project evaluates retail sales performance, customer purchasing behavior, and pricing dynamics across **Beauty, Clothing and Electronics** categories in **Antwerp, Belgium**. By combining public demographic data with commercial transaction records, this project delivers actionable intelligence to optimize product margins, improve customer retention, and improve Average Order Value (AOV). 

## Key Strategic Findings & Recommendations:

* **Price Elasticity & Cross-Category Bundeling:** An inverse relationship has been observed between unit price and sales volume. Cross-category bundling **(e.g., Pairing high-margin Beauty products with high-volumn Clothing products)** can drive higher total order value.
* **Basket Size & Multi-Order Purchasing:** Orders show consistent multi-order purchases pattern across all categories **(Average 2.51 Items per category)**. Multi-buy incentives **(e.g., Buy 3 & Get 4 at 20% off)** will further nudge 1- to 2- items buyers into higher tiers.
* **Seasonality & Demand Forcasting:** Clear annual sale seasonality was indentified, peaking in May and Q4, with a sharp drop in October. Pre-palanning inventory and promotional compaigns prior to high-demand months will prevent stock-out and smooth mid-autumn slumps.
* **Customers Concentration Risk (80/20 Rule):** The top 10% VIP customers generate **38.2% of total store revenue.** Targeted VIP loyalty programs for this high-value decile is crucial to safegauding revenue.

## Data Engineering & Analytical Workflow:

### **Step 1: Data Aquisition & Integration:**

Ingested official public demographic dataset from **OPEN DATA ANTWERPEN (Stad Antwerpen)** and integrated them with commercial retail transaction data from Kaggle to analyze regional market distribution and spending patterns. 

### **Step 2:Database Setup & Transformation:**

Loaded raw data into Azure SQL via SQL Server Management Studio (SSMS). Executed custom T-SQL transformation queries and database views to clean and stricture data. 

### **Step 3: Data Profiling & Quality Check:**

Evaluated data quality by checking null values. However, data has no null values. Inconsistent types of data is given proper data type such as text, char, varchar, nchar, nvarchar, date. Duplicate records are removed in order to maintain the data integrity. 

### **Step 4: Data Modeling & Star Schema:** 

Structured a clean Star Schema by separating data intothree dimension tables and one core fact table.
Dimcustomer (Customer Attributes)
Dimdistrict (Demography & Geography)
Dimstores (Stores locations)
FactSales (Core Transaction Metrics)

### **Step 5: Relational Key Mapping:**

Assigned primary and foreign keys by establishing strict 1to many relationships between dimensions and fact table. 

## **Exploratory Data Analysis(EDA) & DAX Development:**

### **Step 6: Price & Elasticity Analysis:**

Built a scatter plot in PowerBI comparing 'Price_Per_Unit' against 'Quantity'. A linear trendline is applied thorugh further analysis visual, proving a near-zero correlation and confirming an inelastic demand curve across core retail products.  




