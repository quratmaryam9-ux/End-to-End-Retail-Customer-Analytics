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
