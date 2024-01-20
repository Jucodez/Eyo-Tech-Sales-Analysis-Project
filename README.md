# Uttam-Tech-Sales-Analysis-Project

## Problem Statement


Uttam Tech is a company that supplies computer hardware and peripherals to many clients like Excel stores and Electricalsara stores across India. Uttam Tech Hardware has its head office situated in Delhi, India with regional offices throughout India.


Rivaan Burman is the Sales director for this company and is facing a lot of challenges dealing with the rapid changes in the market, resulting in the decline of overall sales and profitability. The sales director has issues tracking the key sales data of various regions that should have aided him in decision-making. This is due to verbal communication being relied upon to transmit sales KPIs between the regional managers and the sales director. Although sales data is also stored in Excel files, the limited analytics capability of the firm hinders its sales director from gaining meaningful insight from it.


The sales director needs to have a clear and understandable overview of the sales data to gain insights that would aid in decision-making. These data-driven decisions are essential in Uttam Tech turning the trajectory of its sales around.



## Project Planning

1. Purpose: To unlock sales insights that were not visible before to the sales team for decision support

2. Stakeholders:

- Sales director

- Marketing team

- Customer service team

- Data analytics team

- IT team

3. End result: An automated dashboard providing quick and latest sights in order to support data-driven decision-making.

4. Success Criteria :

- Creation of a dashboard uncovering sales order insights with the latest data available

- Sales team able to make better decisions 

- Minimizing the manual processes associated with sales analytics in the company

- Increase profits by 10%



## Project Steps


### Data Exploration


The data analysis process started off with an SQL Server Database.


The tables in the database are:

- Customers: customer_code, customer_name, customer_type

- Date: date, cy_date, year, month_name, date_yy_mmm

- Markets: markets_code, markets_name, zone

- Products: product_code, product_type

- Transaction:product_code,customer_code,market_code,order_date,sales_qty,sales_amount,currency,profit_margin_percentage,profit_margin,cost_price



SQL was used to query the database and explore the dataset. These SQL queries helped to identify opportunities for data cleaning.


Key data cleaning opportunities identified:

- The markets_name column in the markets table contains some cities not in India


      select distinct markets_name from markets


   ![incorrect market entries](https://github.com/Jucodez/Eyo-Tech-Sales-Analysis-Project/assets/102746691/df8f86d9-57e9-4b71-933c-95cba0d886e7)

   


- some null entries in the zone column in the markets table where identified, these also coincide with cities outside India in the markets_name column.


      select distinct zone from markets


   ![Null entries in zone](https://github.com/Jucodez/Eyo-Tech-Sales-Analysis-Project/assets/102746691/8d1693a3-1a81-4d63-9b51-ecb8818e27f2)


      select markets_name from markets where zone is null


   ![Corresponding Market entries with null zones](https://github.com/Jucodez/Eyo-Tech-Sales-Analysis-Project/assets/102746691/df529d15-c588-4631-96f7-07f114645f47)


- some transactions in the sales_amount column are in USD, not in INR currency, and must be converted 


      select distinct currency from transactions


   ![Distinct Currencies](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/22c2d59d-20a3-479a-8d92-fe72031440e4)


      select * from transactions where currency <> 'INR'


   ![Transactions with incorrect currencies](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/0c36af76-db7b-4668-8a31-6fa20df0f69d)



### Extract, transform, and load (ETL)


- Loaded data from the SQL server database to power query for cleaning. The errors in the data were found in the transactions table, and that was where the following data-cleaning steps were applied.

- Removed duplicates

- Converted transaction currencies from USD to INR where needed using a conditional column (= Table.AddColumn(#"Removed Duplicates", "Corrected_sales_amount", each if [currency] = "USD" then ([sales_amount]*64.51) else [sales_amount])

- Removed profit margin and profit margin percentage columns. These would be replaced later with appropriate measures. 

- The currency column was also removed to reduce the size of the pbix file and improve dashboard performance.



### Data modeling


A star data model was adopted, with the transactions table serving as the facts table and the other tables serving as the dimensions tables.



![Sales Data Model](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/1e68a957-7f73-4830-b48d-aa534b83fd60)



### Measures

- Calculate revenue by summing sales_amount for whatever item is being analyzed.


      Revenue = sum(transactions[sales_amount])


- Calculate revenue contribution % by dividing revenue for an item by total revenue. 


      Revenue contribution % = DIVIDE([Revenue],CALCULATE([Revenue],ALL(markets),ALL(customers),ALL(products))) 



- Calculate revenue last year by calculating the sum of sales amount for the item in question for the same period last year.


      Revenue Last Year:  Revenue LY = CALCULATE([Revenue],SAMEPERIODLASTYEAR('date'[date]))


- Calculate the sales quantity by calculating the sum of the sales_qty column for the item in question.


      Sales Quantity = sum(transactions[sales_qty])


- Calculate the profit margin by subtracting the cost price from the sales amount for the item in question.


      profit margin = 

      SUM('transactions'[sales_amount]) - SUM('transactions'[cost_price])


- Calculate profit contribution % by dividing the profit margin for an item by the total profit margin. 


      Profit contribution % = DIVIDE([profit margin],CALCULATE([profit margin],ALL(markets),ALL(customers),ALL(products)))


- Calculate profit margin % by dividing profit margin by revenue.


      profit margin % = (transactions[profit margin]/sum(transactions[sales_amount]))


### DASHBOARDING

- A three-page report was developed to help visualize key parameters relevant to revenue, profit, and performance analysis
****
&nbsp;
The revenue analysis dashboard is presented below
****
![revenue analysis dashnboard](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/9602b5b0-ef01-4344-b13f-8e5c40482080)
****
&nbsp;
The profit analysis dashboard is presented below
****
![Profit Analysis Dashboard](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/4ed79cd0-5d8c-4175-8586-5fde6b653136)
****
&nbsp;
The performance analysis dashboard is presented below
****
![Performance Analysis Dashboard](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/e39291c3-fc00-40db-8a42-acdfa37be7fc)
****
&nbsp;
This report was published online for easy access by key stakeholders in the company.

### Key Insights / Data-Driven Strategy

#### Revenue Analysis Dashboard
****
![revenue analysis dashnboard](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/9602b5b0-ef01-4344-b13f-8e5c40482080)
****
1. Revenue trend analysis: 
****
![Revenue trend analysis](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/fb40ccaa-5cc8-4b78-9d7d-3064d64bdb25)
****

A somewhat steady downward trend in revenue was discovered from 2018-2020, with a sharp decline in the early portion of 2020

Analysis: 

The sales team acknowledged that the steady decline in revenue over a two-year period indicates the need for the company to make changes to its overall sales strategy as its market share seems to be gradually eroded away by competitors.


The sharp decline, however, was attributed to the global pandemic, and a drive to apply necessary cost-saving measures to weather the storm was adopted.


This prompted the need for a Profit Analysis Dashboard.


#### Profit Analysis Dashboard
****
![Profit Analysis Dashboard](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/4ed79cd0-5d8c-4175-8586-5fde6b653136)
****
Although the dashboard uncovers insight for the total period of time covered by the dataset, the period of reference for the following key insights is the First half of 2020, as this is the major area of concern for the sales team.
1. Operation Efficiency By Market
- Revenue and profit contribution by market:

  ![Revenue and profit contribution by market](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/4b85c0b8-e4bb-4241-8b34-13fcb5292275)
  
   The Delhi NCR market had the best contribution to revenue (54.7%); however, its profit contribution was second with a mere (22.1%). While the Mumbai market had the second highest revenue contribution (14.2%) but the highest profit contribution (23.9%).
- Profit Margin % by Market:

  ![Profit margin% by market](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/3f059d76-e210-4497-853c-a7811bc04805)
  
   Mumbai came in sixth (2.4%), but more efficient markets that placed higher contributed significantly less to the profit of the organization. Out of the 5 more efficient markets, Chennai was the most profitable, with a profit contribution of 7.6% (5th) and a profit margin % of 6.3% (3rd). Delhi NCR, our biggest contributor to revenue, had an outstandingly poor profit margin % of 0.6%, placing 11 out of the 13 markets. Some Markets like Lucknow were also discovered to be running at a loss (-2.7%).
**Analysis** 
This shows the need for the company to adopt cost-saving measures in the Delhi NCR market. Cost-effective and profitable markets like  Mumbai should be examined further to understand how cost-effective practices can be transferred where possible to other markets. Also, operations in markets contributing little to profit or even running at a loss need to be examined further for cost-saving practices to be performed.


2. Operation Efficiency By Customer

![customer operation efficiency](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/e036abaa-4bc0-46a6-ad2e-3301643b26d4)

- Profit contribution by Customer: Excel Stores, Surge Stores, and Electricalsara Stores contribute the most to the profit of the company (12.5%,11.9%, and 11.9%, respectively). This highlighted the lack of efficiency in operations dealing with Electricalsara Stores, which is the biggest revenue contributor (46.2%). Excel Stores had the second-highest contribution to revenue (5.6%). Excel Stores operations might be a good system to examine for cost cost saving techniques as regards other customers.


- Profit Margin % by Market: The most efficient market was Electricalsbea Stores (15.6%), but it had a very low profit contribution (0.4%). Excel Stores placed 16th with 3.3%. Other more efficient customer relationships had considerably less contribution to revenue and profit margin. Electricalsara Stores had a very low profit margin % of 0.4%. Some customer operations had a negative profit margin %  like Electricalsquipo Stores (-11.4%), showing a need for immediate cost-saving actions as regards these operations


**Analysis**


Customer operations running at a loss need to be investigated immediately. Areas where cost efficiency can be improved need to be addressed, and strategies from more cost-effective customer relations can be adopted where possible.



3. Operation Efficiency by Products:



- Profit contribution by product type: 


  ![Product Profit analysis](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/7493bc74-0845-4fbc-b188-8be7cca061b5)


  Products produced by the company ( Own Brand) were discovered to contribute the most to profit (78.3%), while Distribution Products contributed just (21.7%)


**Analysis** 


During the pandemic period, the company might decide to focus more on its own products due to the profit contribution of those products compared to the distribution products.


Due to the cost-saving initiatives to be undertaken, a performance-tracking dashboard was developed. 


#### Performance Analysis Dashboard


****


![Performance Analysis Dashboard](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/e39291c3-fc00-40db-8a42-acdfa37be7fc)

****


Although the dashboard uncovers insight for the total period of time covered by the dataset, the period of reference for the following key insights is the First half of 2020, as this is the major area of concern for the sales team.


1. Profit Margin % Trend: 


  ![Performance trend](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/71c30d05-7b2d-4da1-a77e-35e5a1c45f96)


  An initial downward trend was observed from January to February and then a steady fluctuation throughout the remaining months.


2. Profit Margin % by Market Performance: 


  ![red alert 2](https://github.com/Jucodez/Uttam-Tech-Sales-Analysis-Project/assets/102746691/78e8627c-5448-45cf-8aed-421e90247e2b)


  A red alert was created on a Profit Margin % by Market visual to help decision makers quickly identify markets performing below the desired profit margin % target of 2.0%. 


## Conclusion 


Overall, this report helps the sales team devise ways to cope with the turbulent market and identify ways to improve operations. The analysis also sheds light on how profits can be increased through cost-efficiency initiatives.

