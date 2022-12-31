#THE NUMBER OF DIFFERENT PRODUCTS AVAILABLE
SELECT COUNT(DISTINCT(Product)) AS PRODUCT
FROM products

#THE COUNT OF PRODUCTS BY TYPE IN PERCENTAGES
SELECT Category,
       ROUND((COUNT(*)/(SELECT COUNT(*) FROM products))*100, 0) as percentage
FROM products
GROUP BY Category

#THE COUNT OF PRODUCTS BY TYPE AND SIZE IN PERCENTAGES
SELECT Category, Size,
       ROUND((COUNT(*)/(SELECT COUNT(*) FROM products))*100, 0) as percentage
FROM products
GROUP BY Category, Size
ORDER BY Category

#REVENUE IN THE FIRST QUARTER
SELECT SUM(Amount) AS REVENUE
FROM sales
WHERE SaleDate BETWEEN "2021-1-1" and "2021-3-31"

#REVENUE AND QUANTITY SOLD IN EACH QUARTER
WITH QUARTERS AS(
SELECT SaleDate, Amount, Boxes,
CASE
    WHEN SaleDate BETWEEN "2021-1-1" and "2021-3-31" THEN "Q1"
    WHEN SaleDate BETWEEN "2021-4-1" and "2021-6-30" THEN "Q2"
    WHEN SaleDate BETWEEN "2021-7-1" and "2021-9-30" THEN "Q3"
	ELSE "Q4"
END AS QUARTERS
FROM sales)
SELECT QUARTERS, SUM(Boxes) AS QUANTITY, SUM(Amount) AS REVENUE
FROM QUARTERS
GROUP BY QUARTERS
ORDER BY QUARTERS ASC

#AVERAGE ORDER VALUE IN EACH MONTH
SELECT MONTH(SaleDate) AS MNTH, ROUND(AVG(Amount),0) AS AVG_ORDER_VALUE
FROM sales
GROUP BY MNTH

#ORDERS ABOVE AVERAGE SALES ORDER VALUE
SELECT *
FROM sales
WHERE Amount >
    (SELECT  AVG(Amount) 
     FROM sales) 

#THE TOP 3 SALES AGENTS WHO BROUGHT IN THE MOST REVENUE
SELECT Salesperson, SUM(Amount) AS REVENUE
FROM people
INNER JOIN sales USING(SPID)
GROUP BY Salesperson
ORDER BY REVENUE DESC
LIMIT 3

#THE MOST POPULAR PRODUCT BY PURCHASED QUANTITY
SELECT Product, SUM(Boxes) AS AMOUNT
FROM products
INNER JOIN sales USING(PID)
GROUP BY Product
ORDER BY AMOUNT DESC
LIMIT 1

#PLACED NUMBER OF ORDERS BY EACH COUNTRY
SELECT Geo AS Country, COUNT(*) AS PLACED_ORDERS
FROM sales
INNER JOIN geo USING(GeoID)
GROUP BY Country
ORDER BY PLACED_ORDERS ASC

#THE MOST POPULAR PRODUCT SOLD IN EACH COUNTRY
WITH COMBINED_TABLES AS(
SELECT geo AS COUNTRY, Product AS PRODUCT, SUM(Boxes) AS QUANTITY
FROM geo
INNER JOIN sales USING(GeoID)
INNER JOIN products USING(PID)
GROUP BY COUNTRY, PRODUCT)

SELECT c.*
    FROM ( SELECT COUNTRY, MAX(QUANTITY) AS QUANTITY
               FROM COMBINED_TABLES
               GROUP BY COUNTRY ) x
    JOIN COMBINED_TABLES c USING(COUNTRY, QUANTITY)
    ORDER BY COUNTRY ASC