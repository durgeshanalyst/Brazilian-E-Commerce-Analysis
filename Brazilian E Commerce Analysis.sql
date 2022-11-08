use project3
---BASic knowledge describing here----
SELECT table_name, table_schema
FROM informatiON_schema.tables
WHERE table_type = 'BASE TABLE'
ORDER BY table_name ASC;

---



/*Q1.write queary to analyse sales for each year and each state*/
WITH sales_delivered AS (
                  SELECT * FROM olist_orders_datASet
				  where order_status = 'delivered')
SELECT ROUND(SUM(ooid.price),4) AS Total_sales_Price, c.customer_state,DATEPART(year,s.order_purchASe_timestamp) AS in_year, 
COUNT(distinct s.order_id) AS Total_order_delivered
FROM sales_delivered s join olist_customers_datASet c ON s.customer_id=c.customer_id
                       join  olist_order_items_datASet ooid ON ooid.order_id=s.order_id
GROUP BY c.customer_state,DATEPART(year,s.order_purchASe_timestamp)
ORDER BY in_year desc

/*Q1. ALTERNATIVE WAY*/
CREATE VIEW sales_delivered AS (
                  SELECT * FROM olist_orders_datASet
				  where order_status = 'delivered')


Create view final1 AS (
SELECT Round(SUM(ooid.price),4) AS Total_sales_Price, c.customer_state,DATEPART(year,s.order_purchASe_timestamp) AS in_year, 
COUNT(distinct s.order_id) AS Total_order_delivered
FROM sales_delivered s join olist_customers_datASet c ON s.customer_id=c.customer_id
                       join  olist_order_items_datASet ooid ON ooid.order_id=s.order_id
GROUP BY c.customer_state,DATEPART(year,s.order_purchASe_timestamp)

SELECT * FROM final1




/*Q.2 all order status*/

create view all_order AS (
SELECT ROUND(SUM(ooid.price),4) AS PRICE,c.customer_state,datepart(year,o.order_purchASe_timestamp) in_year,
COUNT(DISTINCT o.order_id) AS No_of_order_initiated
FROM olist_customers_datASet c join olist_orders_datASet o ON c.customer_id= o.customer_id
                               join  olist_order_items_datASet ooid ON ooid.order_id=o.order_id
GROUP BY c.customer_state,datepart(year,o.order_purchASe_timestamp) 
)
SELECT SUM(PRICE) AS SALES,in_year FROM all_order GROUP BY in_year
SELECT * FROM all_order

/*Q3.customer aquisitiON in each year and in each state*/

create view customer AS (
SELECT COUNT(DISTINCT c.customer_id) AS Customer_exist,c.customer_state,datepart(year,o.order_purchASe_timestamp) in_year
FROM olist_customers_datASet c join olist_orders_datASet o ON c.customer_id= o.customer_id
GROUP BY c.customer_state,datepart(year,o.order_purchASe_timestamp) )
SELECT * FROM customer



/*Total customer in each year*/

CREATE VIEW CUSTOMERS_WE_HAVE AS (
SELECT in_year,SUM(customer_exist) AS cust FROM (
  SELECT COUNT(c.customer_id) AS customer_exist,c.customer_state,datepart(year,o.order_purchASe_timestamp) in_year
FROM olist_customers_datASet c join olist_orders_datASet o ON c.customer_id= o.customer_id
GROUP BY c.customer_state,datepart(year,o.order_purchASe_timestamp) )d
GROUP BY in_year)

SELECT * FROM CUSTOMERS_WE_HAVE

  /*How many order placed in each city and each year*/

CREATE VIEW ORDER_COUNT AS (
SELECT COUNT(distinct O.order_id) AS TOTAL_ORDER, C.customer_state,DATEPART(YEAR,O.order_purchASe_timestamp) AS IN_YEAR
FROM olist_customers_datASet C JOIN olist_orders_datASet O ON C.customer_id=O.customer_id
                               join  olist_order_items_datASet ooid ON ooid.order_id=o.order_id
GROUP BY C.customer_state,DATEPART(YEAR,O.order_purchASe_timestamp))
SELECT * FROM ORDER_COUNT


---if you will calculate the price for each Year across the different states customer serve ONly for
--delivered order
--THEN there will BE disparity between no of order
---if you will calculate the no of order foR all order.

/*(Choosed  the best suited metrics amognst all 3 in point (a) to carry out the analysis)*/

SELECT SUM(Total_sales_Price) AS [amount for delivered],
		SUM(Total_order_delivered) AS [Total_order_delivered],in_year  --delivered order---
			FROM final1 GROUP BY in_year

SELECT SUM(PRICE)AS [amount for total order],
		SUM(No_of_order_initiated) AS [order received],in_year ---Initiated order---
			FROM all_order GROUP BY in_year

----but benifit we got in_customer aquisitiON


----declined trend over the year
SELECT TOP 2 customer_state,in_year,Total_sales_Price FROM final1 WHERE in_year = 2018 ORDER BY TOTAL_SALES_PRICE DESC
SELECT TOP 2 customer_state,in_year,Total_sales_Price FROM final1 WHERE in_year = 2017 ORDER BY TOTAL_SALES_PRICE DESC
SELECT TOP 2 customer_state,in_year,Total_sales_Price FROM final1 WHERE in_year = 2016 ORDER BY TOTAL_SALES_PRICE DESC

----INCLINED TREND OVER THE YEAR
SELECT TOP 2 customer_state,in_year,Total_sales_Price FROM final1 WHERE in_year = 2016 ORDER BY TOTAL_SALES_PRICE DESC
SELECT TOP 2 customer_state,in_year,Total_sales_Price FROM final1 WHERE in_year = 2017 ORDER BY TOTAL_SALES_PRICE DESC
SELECT TOP 2 customer_state,in_year,Total_sales_Price FROM final1 WHERE in_year = 2018 ORDER BY TOTAL_SALES_PRICE DESC
/*Show the Total sales amount for each Category */
SELECT SUM(ooid.price) AS sales,opd.product_category_name
FROM olist_order_items_datASet ooid join olist_product_datASet opd ON ooid.product_id=opd.product_id
                                     join product_category_name_translatiON pcnt ON pcnt.[PRODUCT NAME]=opd.product_category_name
											GROUP BY opd.product_category_name

/* Show the amount for each product id */
SELECT round(SUM(ooid.price),4) AS sales,opd.product_id
FROM olist_product_datASet opd join olist_order_items_datASet ooid ON opd.product_id=ooid.product_id
GROUP BY opd.product_id


/*Analyse all the order revied score AS per their status*/
---AS PER RATING AND STATUS
SELECT ood.order_status,COUNT(oord.review_score) AS reviewd,OORD.review_score
	FROM olist_orders_datASet ood join olist_order_reviews_datASet oord ON ood.order_id=oord.order_id
		GROUP BY  ood.order_status,OORD.review_score
			ORDER BY reviewd desc;

/*TOTAL REVIEW ON POST ORDER AS PER STATUS*/
SELECT ood.order_status,COUNT(oord.review_score) AS NUMBER_OF_REVIEW
	FROM olist_orders_datASet ood join olist_order_reviews_datASet oord ON ood.order_id=oord.order_id
		GROUP BY  ood.order_status;
/*Rate and separate all the sellers in Top,High and Poor AS per their delivery time*/

--High rated Seller who deliver delay 

CREATE OR ALTER VIEW [SELLER'S DELIVERED] AS (
SELECT OSD.seller_id AS [HIGH RATED SELLERS],OOD.order_status
FROM olist_orders_datASet OOD JOIN olist_order_items_datASet OOID ON OOD.order_id=OOID.order_id
                              JOIN olist_sellers_datASet OSD ON OSD.seller_id=OOID.seller_id
							  WHERE OOD.order_status = 'DELIVERED'
							  	GROUP BY OSD.seller_id,OOD.order_status);
									SELECT * FROM [SELLER'S DELIVERED]
--poor rated sellers who does not deliver
CREATE OR ALTER VIEW [NOT DELIVERED SELLERS] AS  (
SELECT OSD.seller_id AS [POOR RATING SELLERS],OOD.order_status
FROM olist_orders_datASet OOD JOIN olist_order_items_datASet OOID ON OOD.order_id=OOID.order_id
                              JOIN olist_sellers_datASet OSD ON OSD.seller_id=OOID.seller_id
							  WHERE OOD.order_status NOT LIKE 'DELIVERED'
							  	GROUP BY OSD.seller_id,OOD.order_status);
									SELECT * FROM [NOT DELIVERED SELLERS]

-----PREDELIVERY'SELLERS (TOP RATED SELLERS)
CREATE OR ALTER VIEW [SELLER'S PRE- DELIVERED] AS (
SELECT OSD.seller_id AS [TOP RATED SELLERS],OOD.order_status
FROM olist_orders_datASet OOD JOIN olist_order_items_datASet OOID ON OOD.order_id=OOID.order_id
                              JOIN olist_sellers_datASet OSD ON OSD.seller_id=OOID.seller_id
							  WHERE OOD.order_delivered_customer_date<OOD.order_estimated_delivery_date
							  							  GROUP BY OSD.seller_id,OOD.order_status);
														  SELECT * FROM [SELLER'S PRE- DELIVERED]
/*Check all at ONce by grouping*/
				SELECT S1.[TOP RATED SELLERS], 
					   S2.[POOR RATING SELLERS],
					   S3.[HIGH RATED SELLERS]
					FROM [SELLER'S PRE- DELIVERED]S1
						JOIN [NOT DELIVERED SELLERS]S2
						 ON S1.[TOP RATED SELLERS]=S2.[POOR RATING SELLERS]
						JOIN [SELLER'S DELIVERED] S3
						 ON S1.[TOP RATED SELLERS]=S3.[HIGH RATED SELLERS]


-----what wAS the % of orders delivered earlier than the expected date
SELECT * into smart FROM (
		SELECT COUNT(order_id) AS [success order]
		FROM olist_orders_datASet
		where order_delivered_customer_date<order_estimated_delivery_date)a;
SELECT * FROM smart

SELECT 88649*100/COUNT(order_id) FROM olist_orders_datASet

/*what wAS the % of orders delivered earlier than the expected date*/

create or alter view  [percentage nikala] AS
SELECT SUM(
		 CASE
			WHEN order_delivered_customer_date<order_estimated_delivery_date THEN 1 else 0 end ) 
			  AS [success order],COUNT(order_id) AS [all over order]
				FROM olist_orders_datASet

SELECT [success order]*100/[all over order] AS [earlier deliver] FROM  [percentage nikala]

----what wAS the % of orders delivered later than the expected date

CREATE or ALTER VIEW  [percentage nikala2] AS
SELECT SUM(CASE WHEN order_delivered_customer_date>order_estimated_delivery_date THEN 1 ELSE 0 END ) AS [success order],
COUNT(order_id) AS [all over order]
FROM olist_orders_datASet

SELECT [success order]*100/[all over order] AS [delay deliver] FROM  [percentage nikala2]
----
CREATE or ALTER VIEW  [percentage nikala3] AS
SELECT SUM(CASE WHEN order_delivered_customer_date is null THEN 1 ELSE 0 END ) AS [not deivered order],
COUNT(order_id) AS [all over order]
FROM olist_orders_datASet

SELECT [not deivered order]*100/[all over order] AS [delay deliver] FROM  [percentage nikala3]

-----show thre trend over year and city
create or alter view [trend by city] AS (
SELECT Round(SUM(ooid.price),4) AS Total_sales_Price,c.customer_city,DATEPART(year,s.order_purchASe_timestamp) AS in_year, 
COUNT(distinct s.order_id) AS Total_order_delivered
FROM sales_delivered s join olist_customers_datASet c ON s.customer_id=c.customer_id
                       join  olist_order_items_datASet ooid ON ooid.order_id=s.order_id
GROUP BY c.customer_city,DATEPART(year,s.order_purchASe_timestamp))
----DECLINED TREND
SELECT top 2 customer_city,in_year,Total_sales_Price  FROM [trend by city] where in_year=2016 ORDER BY Total_sales_Price desc
SELECT top 2 customer_city,in_year,Total_sales_Price  FROM [trend by city] where in_year=2017 ORDER BY Total_sales_Price desc
SELECT top 2 customer_city,in_year,Total_sales_Price  FROM [trend by city] where in_year=2018 ORDER BY Total_sales_Price desc


----INCLINED TRENND
SELECT top 2 customer_city,in_year,Total_sales_Price  FROM [trend by city] where in_year=2016 ORDER BY Total_sales_Price ASC
SELECT top 2 customer_city,in_year,Total_sales_Price  FROM [trend by city] where in_year=2017 ORDER BY Total_sales_Price ASC
SELECT top 2 customer_city,in_year,Total_sales_Price  FROM [trend by city] where in_year=2018 ORDER BY Total_sales_Price ASC



SELECT * FROM olist_customers_datASet;
SELECT * FROM olist_order_items_datASet;
SELECT * FROM olist_order_payments_datASet;
SELECT * FROM olist_order_reviews_datASet;
 SELECT * FROM olist_orders_datASet;
SELECT * FROM olist_sellers_datASet;
SELECT * FROM  olist_geolocatiON_datASet;
SELECT * FROM product_category_name_translatiON;
SELECT * FROM olist_product_datASet
SELECT *,len([PRODUCT NAME]) AS PNL FROM product_category_name_translatiON