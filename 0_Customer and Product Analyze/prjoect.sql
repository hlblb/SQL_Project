/* 
         ------------------------------------------------------------
          Guided Project: Customers and Products Analysis Using SQL 
         ------------------------------------------------------------

 Introduction:

 We are going to answer to following questions.
 
 Question 1: Which products should we order more of or less of?
 Question 2: How should we tailor marketing and communication strategies to customer behaviors?
 Question 3: How much can we spend on acquiring new customers?

 Database Summary:

 The database contains 8 tables as follows.
   
 1. Customers: customer data
 2. Employees: all employee information
 3. Offices: sales office information
 4. Orders: customers' sales orders
 5. OrderDetails: sales order line for each sales order
 6. Payments: customers' payment records
 7. Products: a list of scale model cars
 8. ProductLines: a list of product line categories

 */		
 
--Screen 3 Write a query to display # of rows and columns for all tables.
SELECT 'Customer' AS table_name,
    	13 AS number_of_attributes,
		COUNT(*) AS number_of_rows
  FROM customers

UNION ALL

SELECT 'Products' AS table_name, 
       9 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Products

UNION ALL

SELECT 'ProductLines' AS table_name, 
       4 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM ProductLines

UNION ALL

SELECT 'Orders' AS table_name, 
       7 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Orders

UNION ALL

SELECT 'OrderDetails' AS table_name, 
       5 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM OrderDetails

UNION ALL

SELECT 'Payments' AS table_name, 
       4 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Payments

UNION ALL

SELECT 'Employees' AS table_name, 
       8 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Employees

UNION ALL

SELECT 'Offices' AS table_name, 
       9 AS number_of_attribute,
       COUNT(*) AS number_of_row
  FROM Offices; 

-- Question 1: Which Products Should We Order More of or Less of? --
-- Screen 4. Write a query to compute the low stock for each product using a correlated subquery.
  SELECT productCode, ROUND(SUM(quantityOrdered)*1.0/(SELECT quantityInStock 
							FROM products pr
         						   WHERE pr.productCode = od.productCode),2) as low_stock
    FROM orderdetails od
GROUP BY productCode
ORDER BY low_stock DESC
   LIMIT 10;
   
--Write a query to compute the product performance for each product.
   SELECT productCode, SUM(priceEach *quantityOrdered) AS product_performance
     FROM orderdetails od
 GROUP BY productCode
 ORDER BY product_performance DESC
    LIMIT 10;
 
--Combine the previous queries using a Common Table Expression (CTE) to display priority products for restocking using the IN operator.
WITH 
low_stock_table AS(

	SELECT productCode, ROUND(SUM(quantityOrdered)*1.0/(SELECT quantityInStock 
							      FROM products pr
							     WHERE pr.productCode = od.productCode),2) as low_stock
     FROM orderdetails od
 GROUP BY productCode
 ORDER BY low_stock DESC
    LIMIT 10

)
   SELECT productCode, SUM(priceEach *quantityOrdered) AS product_performance
     FROM orderdetails od
	WHERE productCode IN (SELECT productCode FROM low_stock_table)
 GROUP BY productCode
 ORDER BY product_performance DESC
    LIMIT 10;
	
	
	
	
--  Question 2: How Should We Match Marketing and Communication Strategies to Customer Behavior?	

-- Screen 5. Write a query to join the products, orders, and orderdetails tables to have customers and products information in the same place.

-- profits by customer
  SELECT o.customerNumber, SUM(od.quantityOrdered)*od.priceEach - SUM(od.quantityORdered)* (od.priceEach - pd.buyPrice) AS profit
    FROM orders o
    JOIN orderdetails od
	    ON o.orderNumber = od.orderNumber
    JOIN products pd
	    ON od.productCode = pd.productCode
GROUP BY o.customerNumber
ORDER BY profit DESC


--Screen 6. write a query to find the top five least-engaged customers. 
WITH
 VIP AS(
 
   SELECT o.customerNumber,  SUM(od.quantityORdered* (od.priceEach - pd.buyPrice)) AS profit
    FROM orders o
    JOIN orderdetails od
	  ON o.orderNumber = od.orderNumber
    JOIN products pd
	  ON od.productCode = pd.productCode
GROUP BY o.customerNumber
ORDER BY profit DESC

)
SELECT contactLastName, contactFirstName, city, country, VIP.profit
  FROM customers
  JOIN VIP
    ON customers.customerNumber = VIP.customerNumber
 LIMIT 5
	
-- Question 3: How Much Can We Spend on Acquiring New Customers?
-- Screen 7. Write a query to compute the average of customer profits using the CTE on the previous screen.

WITH
 VIP AS(
 
   SELECT o.customerNumber, SUM(od.quantityORdered* (od.priceEach - pd.buyPrice)) AS profit
    FROM orders o
    JOIN orderdetails od
	  ON o.orderNumber = od.orderNumber
    JOIN products pd
	  ON od.productCode = pd.productCode
GROUP BY o.customerNumber
ORDER BY profit DESC

)

SELECT AVG(VIP.profit)
  FROM VIP;






