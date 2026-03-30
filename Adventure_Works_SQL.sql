CREATE DATABASE adventureworks;
USE adventureworks;

CREATE TABLE sales AS
SELECT * FROM factinternetsales
UNION ALL
SELECT * FROM fact_internet_sales_new;

CREATE TABLE product AS
SELECT 
    p.ProductKey,
    p.EnglishProductName AS ProductName,
    p.StandardCost,
    p.ListPrice AS UnitPrice,
    ps.EnglishProductSubcategoryName AS ProductSubcategoryName,
    pc.EnglishProductCategoryName AS ProductCategoryName
FROM dimproduct p
LEFT JOIN dimproductsubcategory ps
    ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN dimproductcategory pc
    ON ps.ProductCategoryKey = pc.ProductCategoryKey;

SELECT
    p.ProductName,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerFullName,
    p.UnitPrice
FROM sales s
LEFT JOIN product p
    ON s.ProductKey = p.ProductKey
LEFT JOIN dimcustomer c
    ON s.CustomerKey = c.CustomerKey;
    
SELECT
    OrderDateKey,
    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS OrderDate,

    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year,
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthFullName,

    CONCAT('Q', QUARTER(STR_TO_DATE(OrderDateKey, '%Y%m%d'))) AS Quarter,

    DATE_FORMAT(STR_TO_DATE(OrderDateKey, '%Y%m%d'), '%Y-%b') AS YearMonth,

    WEEKDAY(STR_TO_DATE(OrderDateKey, '%Y%m%d')) + 1 AS WeekdayNumber,
    DAYNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS WeekdayName
FROM sales;

SELECT
    OrderDateKey,
    CASE
        WHEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) >= 4
        THEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) - 3
        ELSE MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) + 9
    END AS FinancialMonth,
    CASE
        WHEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter
FROM sales;

SELECT s.OrderQuantity, p.UnitPrice, s.UnitPriceDiscountPct,
    (p.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct)) AS SalesAmount
FROM sales s
JOIN product p
    ON s.ProductKey = p.ProductKey;
    
SELECT s.OrderQuantity, p.StandardCost, 
(p.StandardCost * s.OrderQuantity) AS ProductionCost
FROM sales s
JOIN product p
    ON s.ProductKey = p.ProductKey;
    
SELECT
    (p.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct)) AS SalesAmount,
    (p.StandardCost * s.OrderQuantity) AS ProductionCost,
    ((p.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct))
     - (p.StandardCost * s.OrderQuantity)) AS Profit
FROM sales s
JOIN product p
    ON s.ProductKey = p .ProductKey;
    
CREATE VIEW sales_analysis AS
SELECT
    s.SalesOrderNumber,
    STR_TO_DATE(s.OrderDateKey, '%Y%m%d') AS OrderDate,
    YEAR(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) AS Year,
    MONTHNAME(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) AS Month,
    p.ProductName,
    p.ProductCategoryName,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerFullName,
    (p.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct)) AS SalesAmount,
    (p.StandardCost * s.OrderQuantity) AS ProductionCost,
    ((p.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct))
     - (p.StandardCost * s.OrderQuantity)) AS Profit
FROM sales s
JOIN product p ON s.ProductKey = p.ProductKey
JOIN dimcustomer c ON s.CustomerKey = c.CustomerKey;



