use sales
-- Exploratory data analysis
--------------------------------------------------------- Analyzing the customers table----------------------------------------------------

select * from customers
-- further analysis from SQL Server Management Studio gui shows customers_code is primary key (no duplicates or null values allowed)
select distinct customer_name from customers
-- customer_name appears clean for now
select distinct customer_type from customers
-- customer_type appears clean for now

----------------------------------------------------------- Analyzing the markets table-------------------------------------------------
select * from markets
-- further analysis from SQL Server Management Studio gui shows markets_code is primary key (no duplicates or null values allowed)
select distinct markets_name from markets
-- markets_name contains some cities not in india, some data cleaning required
select distinct zone from markets
select markets_name from markets where zone is null
-- some null entries in zone which coincide with cities outside india are present. cleaning required


----------------------------------------------------------- Analyzing the products table-----------------------------------------------------
select * from products
-- product_code is primary key
-- ensure validity of product_code
SELECT *
FROM products
WHERE product_code NOT LIKE 'Prod%' OR
      TRY_CAST(SUBSTRING(product_code, 5, LEN(product_code)) AS INT) IS NULL OR
      TRY_CAST(SUBSTRING(product_code, 5, LEN(product_code)) AS INT) not between 1 and 172
-- no further cleaning required

-- ensure validity of product_type
select distinct product_type from products
-- no further cleaning required

------------------------------------------------- Analyzing the date table ------------------------------------------------------------------
select * from date
-- date column is primary key
select MIN(date) from date
select MAX(date) from date
-- date column appears reasonably clean for now
select distinct cy_date from date

select date,cy_date from date where FORMAT(date, 'yyyy-MM')  <> FORMAT(cy_date, 'yyyy-MM') 
-- cy_date column appears in correct order for now
select distinct year from date
select date,year from date where year(date)  <> year
-- year column appears clean for now
select distinct month_name from date
select date,month_name from date where DATENAME(month, date)  <> month_name
-- month_name column appears clean for now
select distinct date_yy_mmm from date
select date,date_yy_mmm from date where FORMAT(date, 'yy-MMM')  <> date_yy_mmm
-- date_yy_mmm column appears clean for now

------------------------------------------------- Analyzing the transactions table ------------------------------------------------------------------

select * from transactions

select product_code, count (product_code) product_count from transactions group by product_code order by product_count
select product_code from transactions where product_code not in (select product_code from products)
-- Product code column is clean



select customer_code, count (customer_code) customer_count from transactions group by customer_code order by customer_count
select customer_code from transactions where customer_code not in (select customer_code from customers)
-- Customer code column is clean

select market_code, count (market_code) market_count from transactions group by market_code order by market_count
select market_code from transactions where market_code not in (select market_code from customers)

-- market code column is clean


select order_date, count (order_date) date_count from transactions group by order_date order by date_count
select order_date from transactions where order_date not in (select date from date)

-- order date column is clean

select top 10 sales_qty from transactions group by sales_qty order by sales_qty
select top 10 sales_qty from transactions group by sales_qty order by sales_qty desc

-- sales qty column is clean

select top 10 sales_amount from transactions group by sales_amount order by sales_amount
select top 10 sales_amount from transactions group by sales_amount order by sales_amount desc
select top 10 * from transactions order by sales_amount desc

-- sales amount column is clean

select distinct currency from transactions
select * from transactions where currency <> 'INR'

--sales_amount not in INR currency must be converted 


select top 10 cost_price from transactions group by cost_price order by cost_price
select top 10 cost_price from transactions group by cost_price order by cost_price desc
select top 10 * from transactions order by cost_price desc

-- cost price column is clean

-- examing finance data in transactions

SELECT *, sales_amount - cost_price
FROM transactions
WHERE ROUND(profit_margin, 2) <> ROUND(sales_amount - cost_price, 2);

select * from transactions where profit_margin_percentage <> ROUND ( profit_margin/sales_amount, 2)

-- errors discovered are due to usd sales_amount being in USD currency
