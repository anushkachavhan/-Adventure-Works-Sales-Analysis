# -Adventure-Works-Sales-Analysis
A full-stack data analytics project analyzing bicycle sales data for Adventure Works Cycles — a multinational manufacturing company — using SQL, Excel, Power BI, and Tableau.
Adventure Works Cycles is a large multinational company that manufactures and sells metal and composite bicycles across North American, European, and Asian commercial markets. Coming off a successful fiscal year, the company wanted to:

Target their best customers more effectively
Extend product availability through an external web presence
Reduce cost of sales through lower production costs

This project performs end-to-end sales data analysis to uncover patterns, trends, and actionable insights across products, regions, and customer segments — visualized through interactive dashboards.

🎯 Objectives

Build a star schema data model linking fact and dimension tables
Perform data cleaning, transformation, and enrichment using SQL
Calculate key business metrics: Sales Amount, Production Cost, and Profit
Analyze performance across time (year/month/quarter), geography, and product category
Deliver interactive dashboards in Excel, Power BI, and Tableau


🗂️ Dataset
The dataset is based on Microsoft's AdventureWorksDW (Data Warehouse) sample database. It follows a star schema with one central fact table joined to several dimension tables.
Fact Tables
FileDescriptionFactInternetSales.xlsxHistorical internet sales transactionsFact_Internet_Sales_New.xlsxNewer/extended sales records (same schema)
Both tables are combined using UNION ALL to form a unified sales table.
Key columns: ProductKey, CustomerKey, SalesTerritoryKey, OrderDateKey, OrderQuantity, UnitPrice, UnitPriceDiscountPct, SalesOrderNumber
Dimension Tables
FileDescriptionDimProduct.xlsxProduct details — name, cost, list price, subcategory keyDimProductSubCategory.xlsxProduct subcategory namesDimProductCategory.xlsxProduct category names (Bikes, Accessories, Clothing, etc.)Dimcustomer.xlsxCustomer demographics — name, income, education, occupationDimDate.xlsxDate dimension — calendar year, quarter, month, fiscal periodsDimSalesterritory.xlsxSales territory — region, country, group

🏗️ Data Model
The project implements a star schema with FactInternetSales at the center, joined to all dimension tables via surrogate keys:
FactInternetSales
    ├── ProductKey       → DimProduct → DimProductSubCategory → DimProductCategory
    ├── CustomerKey      → DimCustomer
    ├── SalesTerritoryKey→ DimSalesTerritory
    └── OrderDateKey     → DimDate

🛠️ Tools & Technologies
ToolPurposeMySQLData modeling, transformation, and business metric calculationsExcelData cleaning, pivot-based analysis, and dashboard creationPower BIInteractive business intelligence dashboardsTableauVisual analytics and geographic sales exploration

🗄️ SQL Workflow (Adventure_Works_SQL.sql)
1. Database & Table Setup
sqlCREATE DATABASE adventureworks;

-- Combine both fact tables
CREATE TABLE sales AS
SELECT * FROM factinternetsales
UNION ALL
SELECT * FROM fact_internet_sales_new;

-- Build enriched product table with category hierarchy
CREATE TABLE product AS
SELECT
    p.ProductKey,
    p.EnglishProductName AS ProductName,
    p.StandardCost,
    p.ListPrice AS UnitPrice,
    ps.EnglishProductSubcategoryName AS ProductSubcategoryName,
    pc.EnglishProductCategoryName AS ProductCategoryName
FROM dimproduct p
LEFT JOIN dimproductsubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
LEFT JOIN dimproductcategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey;
2. Date Intelligence
Converts raw integer date keys (e.g. 20110101) into full date attributes:

Calendar year, month number, month name
Quarter (Q1–Q4)
Weekday number and name
Financial year quarters (April–March cycle)

3. Business Metric Calculations
MetricFormulaSales AmountUnitPrice × OrderQuantity × (1 − DiscountPct)Production CostStandardCost × OrderQuantityProfitSalesAmount − ProductionCost
4. Final View
sqlCREATE VIEW sales_analysis AS
SELECT
    s.SalesOrderNumber,
    OrderDate, Year, Month,
    p.ProductName, p.ProductCategoryName,
    CustomerFullName,
    SalesAmount, ProductionCost, Profit
FROM sales s
JOIN product p ON s.ProductKey = p.ProductKey
JOIN dimcustomer c ON s.CustomerKey = c.CustomerKey;

📊 KPIs Analyzed
KPIDescriptionYear-wise SalesTotal revenue grouped by calendar yearMonth-wise SalesMonthly revenue trendsQuarter-wise SalesQuarterly performance (calendar & financial)Country-wise SalesGeographic breakdown of revenueSales vs Production CostMonth-wise combo analysis for margin trackingTop / Bottom 10 ProductsBest and worst performing products by salesCategory-wise ProfitProfitability by product categoryTotal Sales / Profit / QuantityHigh-level KPI summary cards

📁 Repository Structure
adventure-works-analysis/
│
├── data/
│   ├── FactInternetSales.xlsx
│   ├── Fact_Internet_Sales_New.xlsx
│   ├── DimProduct.xlsx
│   ├── DimProductSubCategory.xlsx
│   ├── DimProductCategory.xlsx
│   ├── Dimcustomer.xlsx
│   ├── DimDate.xlsx
│   └── DimSalesterritory.xlsx
│
├── sql/
│   └── Adventure_Works_SQL.sql
│
├── excel/
│   └── Adventure_Works_Excel.xlsx        # Full dashboard workbook
│
├── powerbi/
│   └── Adventure_Works_PowerBI.pbix
│
├── tableau/
│   └── Adventure_Works_Tableau.twbx
│
│
└── README.md

📈 Dashboards
Excel Dashboard
Built using Pivot Tables and Charts across multiple sheets:

Year-wise, Month-wise, and Quarter-wise sales views
Country-wise sales breakdown
Sales & Cost combo chart
Separate Sales and Profit dashboard tabs
Top 10 / Bottom 10 product performance

Power BI Dashboard
Interactive report with drill-through capabilities across:

Time intelligence (year → quarter → month)
Product category hierarchy
Regional/country-level performance

Tableau Dashboard
Geographic and trend-based visualizations covering:

Regional sales performance
Product-level analysis
Customer segment insights



🏁 Conclusion
This project successfully uncovered significant trends and patterns in Adventure Works' sales portfolio. Key takeaways:

SQL was used for data modeling, cleaning, and metric calculation
Excel enabled rapid pivot-based exploration and dashboard prototyping
Power BI and Tableau provided interactive, stakeholder-ready visualizations
Analysis revealed actionable insights on regional performance, seasonal trends, and high-value customer segments — directly supporting Adventure Works' strategic goals


📋 Evaluation Criteria
This project was evaluated on four factors:

Technical Skills — Accuracy and depth of SQL, Excel, Power BI, and Tableau work
Collaboration — Effective teamwork across deliverables
Communication — Clarity of presentation and insights
Planning & Execution — Adherence to project schedule and milestones
