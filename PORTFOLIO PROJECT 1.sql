SELECT TOP (1000) [Row ID]
      ,[Order ID]
      ,[Year]
      ,[Order Date]
      ,[Ship Date]
      ,[Ship Mode]
      ,[Customer ID]
      ,[Customer Name]
      ,[Segment]
      ,[Country]
      ,[City]
      ,[State]
      ,[Postal Code]
      ,[Region]
      ,[Product ID]
      ,[Category]
      ,[Sub-Category]
      ,[Product Name]
      ,[Revenue]
      ,[Quantity]
      ,[Discount]
      ,[Profit]
      ,[Profit Margin]
      ,[Actual Revenue]
      ,[Cost price]
      ,[Profit without discount]
      ,[Loss at discount]
  FROM [PORTFOLIOPROJECT1].[dbo].[Data]


  SELECT * 
  FROM DATA


  ALTER TABLE DATA
  ALTER COLUMN [Order Date] DATE

  ALTER TABLE DATA
  ALTER COLUMN [Ship Date] DATE

--1. Identify the top-selling products (by sales and Profit).
--TOP 10 BY SALES
	select top 10 [product name], round(sum(Revenue), 2) as totalsales
	from DATA
	group by [product name]
	order by totalsales desc

--TOP 10 BY PROFIT
	select top 10 [product name], round(sum(profit), 2) as totalprofit
	from DATA
	group by [product name]
	order by totalprofit desc

-- 2. Determine the best-performing product categories(by Sales and Profit)
--BEST PERFORMING CATEGORY BY SALES
	select category, round(sum(Revenue), 2) as sales_by_category
	from DATA
	group by Category
	order by sales_by_category desc
	
--BEST PERFORMING CATEGORY BY PROFIT
	select category, round(sum(profit), 2) as profit_by_category
	from DATA
	group by Category
	order by profit_by_category desc

--3. Analyze sales trends over time (e.g., by month, year, or quarter).
--YEARLY REVENUE TREND
	select Year, round(sum(Revenue), 0) yearly_sales
	from DATA
	group by Year
	order by yearly_sales desc
	
--MONTHLY REVENUE TREND
		WITH MONTHLY AS (
		SELECT MONTH([ORDER DATE]) ALLMONTH, ROUND(SUM(REVENUE), 0) MONTHLYREV
		FROM Data
		GROUP BY [Order Date])
		SELECT ALLMONTH, SUM(MONTHLYREV) TOTALMONTHLYREV
		FROM MONTHLY
		GROUP BY ALLMONTH
		ORDER BY TOTALMONTHLYREV DESC;



--yeearly revenue rate 
		WITH yearly AS (
		SELECT YEAR, ROUND(SUM(Revenue), 0) REVENUE
		FROM DATA
		GROUP BY YEAR)
		SELECT YEAR, (REVENUE/SUM(REVENUE) OVER ()) * 100 AS YEARLY_RATE
		FROM yearly
		ORDER BY YEARLY_RATE DESC


--5. Analyze the most ordered goods by Subcategory
		select [Sub-Category], sum(quantity) total_quantity
		from DATA
		group by [Sub-Category]
		order by total_quantity desc

--Assess profitability:

--1. Calculate the overall profit
		select round(sum(profit), 0) OVERALLPROFIT
		from DATA

--2. Analyze the impact of discounts on profitability.
--actual price
		select Revenue/(1-Discount) actual_price
		from DATA

--cost price
	select round((Revenue/(1-Discount)) - ABS(profit), 0) cost_price
	from DATA

--profit without discount
	select round((Revenue/(1-Discount)) - ((Revenue/(1-Discount)) - ABS(profit)), 2) profit_without_discount
	from data

--loss after discount
	select round((Revenue/(1-Discount)) - Revenue, 2) loss_on_discount
	from DATA

--Customer and geographic insights:

--1. Identify the most valuable customers based on total profit.
	select top 10 [Customer Name], round(sum(profit), 0) customer_profit
	from data
	group by [Customer Name]
	order by customer_profit desc

--2. Analyze sales and profitability across different customer segments (e.g., Consumer, Corporate).
--sales across segments
	select segment, round(sum(Revenue), 0) segment_sales
	from DATA
	group by Segment
	order by segment_sales desc

--profit accross segment
	select segment, round(sum(profit), 0) segment_profit
	from DATA
	group by Segment
	order by segment_profit desc


--3. Compare sales and profitability across different regions, cities, and states.
--sales accross regions
	select Region, round(sum(Revenue), 0) region_sales
	from DATA
	group by Region
	order by region_sales desc

--profit accross region
	select Region, round(sum(profit), 0) region_profit
	from DATA
	group by Region
	order by region_profit desc

--sales accross cities
select top 10 City, round(sum(Revenue), 0) city_sales
	from DATA
	group by City
	order by city_sales desc

--profit accross cities
	select top 10 City, round(sum(profit), 0) city_profit
	from DATA
	group by City
	order by city_profit desc

--sales accross state
	select top 10 State, round(sum(Revenue), 0) State_sales
	from DATA	
	group by State
	order by State_sales desc

--profit accross state
	select top 10 State, round(sum(profit), 0) State_profit
	from DATA
	group by State
	order by State_profit desc

