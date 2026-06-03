CREATE DATABASE Window_Functions_ProductOrders_Assignmentdb;
USE Window_Functions_ProductOrders_Assignmentdb;

CREATE TABLE ProductOrders (
    OrderID INT,
    OrderDate DATE,
    CustomerID INT,
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    SalesAmount DECIMAL(12,2),
    PRIMARY KEY (OrderID, ProductID)
);

DESC ProductOrders;

INSERT INTO ProductOrders VALUES
(1,'2026-01-05',1001,101,'Laptop','Electronics',2,60000,120000),
(1,'2026-01-05',1001,102,'Mobile','Electronics',1,25000,25000),
(2,'2026-01-10',1002,103,'Printer','Electronics',3,12000,36000),
(3,'2026-01-15',1003,104,'Desk','Furniture',2,8000,16000),
(3,'2026-01-15',1003,105,'Chair','Furniture',4,3000,12000),
(4,'2026-02-05',1004,101,'Laptop','Electronics',1,60000,60000),
(4,'2026-02-05',1004,103,'Printer','Electronics',2,12000,24000),
(5,'2026-02-10',1005,102,'Mobile','Electronics',3,25000,75000),
(5,'2026-02-10',1005,104,'Desk','Furniture',1,8000,8000),
(6,'2026-03-01',1006,105,'Chair','Furniture',5,3000,15000),
(7,'2026-03-05',1007,101,'Laptop','Electronics',2,60000,120000),
(8,'2026-03-12',1008,102,'Mobile','Electronics',4,25000,100000);

SELECT * from ProductOrders;

-- 1. Generate ROW_NUMBER() for products ordered by SalesAmount descending.
SELECT ProductID,ProductName,SalesAmount, row_number() over (ORDER BY SalesAmount DESC) AS RowNumber
from ProductOrders;

-- 2. Assign RANK() to products based on total sales.
SELECT ProductID,ProductName,TotalSales,Rank() over ( Order by TotalSales DESC) AS ProductRank
FROM (SELECT ProductID,ProductName,sum(SalesAmount) as TotalSales 
	  FROM ProductOrders
      Group by ProductID,ProductName) tb;
      
SELECT ProductID,ProductName,SUM(SalesAmount) AS TotalSales,RANK() OVER (ORDER BY SUM(SalesAmount) DESC) AS ProductRank
FROM ProductOrders
GROUP BY ProductID,ProductName;

-- 3. Assign DENSE_RANK() to products based on quantity sold.
SELECT ProductID,ProductName,SUM(Quantity) AS Totalquantity,RANK() OVER (ORDER BY SUM(Quantity) DESC) AS ProductRank
FROM ProductOrders
GROUP BY ProductID,ProductName;

-- 4. Find the Top 3 selling products.
SELECT ProductID,ProductName,SUM(Quantity) AS Totalquantity,RANK() OVER (ORDER BY SUM(Quantity) DESC) AS ProductRank
FROM ProductOrders
GROUP BY ProductID,ProductName
limit 3;

-- 5. Display previous SalesAmount using LAG().
SELECT ProductID,ProductName,SalesAmount,LAG(SalesAmount) OVER (ORDER BY SalesAmount DESC) AS PreviousSalesAmount
FROM ProductOrders;

-- 6. Display next SalesAmount using LEAD().
SELECT ProductID,ProductName,SalesAmount,LEAD(SalesAmount) OVER (ORDER BY SalesAmount DESC) AS PreviousSalesAmount
FROM ProductOrders;

-- 7. Calculate running total of SalesAmount by OrderDate.
SELECT OrderID,OrderDate,SalesAmount,SUM(SalesAmount) OVER (ORDER BY OrderDate) AS RunningTotal
FROM ProductOrders;

-- 8. Calculate cumulative sales for each product.
SELECT ProductID,ProductName,SUM(SalesAmount) as Totalsalesamount
FROM ProductOrders
GROUP BY ProductID,ProductName;

-- 9. Show highest sales in each category using FIRST_VALUE().
SELECT OrderID,ProductName,Category,SalesAmount,FIRST_VALUE(SalesAmount) OVER (PARTITION BY Category ORDER BY SalesAmount DESC) AS HighestSales
FROM ProductOrders;

-- 10. Show lowest sales in each category using LAST_VALUE().
SELECT OrderID,ProductName,Category,SalesAmount,
       LAST_VALUE(SalesAmount) OVER (PARTITION BY Category ORDER BY SalesAmount DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LowestSales
FROM ProductOrders;

-- 11. Calculate difference between current and previous sales.
SELECT OrderID,ProductName,SalesAmount,
       LAG(SalesAmount) OVER (ORDER BY OrderDate) AS PreviousSales,
       SalesAmount - LAG(SalesAmount) OVER (ORDER BY OrderDate) AS Difference
FROM ProductOrders;

-- 12. Calculate 3-order moving average sales.
SELECT OrderID,
       OrderDate,
       SalesAmount,
       AVG(SalesAmount) OVER (
           ORDER BY OrderDate
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS MovingAvg_3Orders
FROM ProductOrders;

-- 13. Show percentage contribution of each product to total sales.
SELECT ProductID,
       SUM(SalesAmount) AS ProductSales,
       ROUND(
           SUM(SalesAmount) * 100.0 /
           SUM(SUM(SalesAmount)) OVER (),
           2
       ) AS PercentageContribution
FROM ProductOrders
GROUP BY ProductID;
-- 14. Find products whose sales exceed category average.
SELECT *
FROM (
    SELECT ProductName,
           Category,
           SalesAmount,
           AVG(SalesAmount) OVER(PARTITION BY Category) AS CategoryAvg
    FROM ProductOrders
) t
WHERE SalesAmount > CategoryAvg;

-- 15. Divide products into quartiles using NTILE(4).
SELECT ProductName,
       SalesAmount,
       NTILE(4) OVER (ORDER BY SalesAmount DESC) AS Quartile
FROM ProductOrders;

-- 16. Find second highest selling product.
SELECT ProductName,
       SalesAmount
FROM (
    SELECT ProductName,
           SalesAmount,
           DENSE_RANK() OVER (ORDER BY SalesAmount DESC) AS rnk
    FROM ProductOrders
) t
WHERE rnk = 2;

-- 17. Compare each product with category leader sales.
SELECT ProductName,
       Category,
       SalesAmount,
       FIRST_VALUE(SalesAmount) OVER (
           PARTITION BY Category
           ORDER BY SalesAmount DESC
       ) AS CategoryLeaderSales,
       SalesAmount -
       FIRST_VALUE(SalesAmount) OVER (
           PARTITION BY Category
           ORDER BY SalesAmount DESC
       ) AS Difference
FROM ProductOrders;

-- 18. Calculate month-over-month sales growth.
SELECT Month,
       TotalSales,
       LAG(TotalSales) OVER (ORDER BY Month) AS PreviousMonthSales,
       ROUND(
           ((TotalSales -
           LAG(TotalSales) OVER (ORDER BY Month))
           * 100.0)
           /
           LAG(TotalSales) OVER (ORDER BY Month),
           2
       ) AS GrowthPercent
FROM (
    SELECT DATE_FORMAT(OrderDate,'%Y-%m') AS Month,
           SUM(SalesAmount) AS TotalSales
    FROM ProductOrders
    GROUP BY DATE_FORMAT(OrderDate,'%Y-%m')
) m;

-- 19. Identify products with consecutive sales increases using LAG().
SELECT ProductName,
       OrderDate,
       SalesAmount,
       LAG(SalesAmount) OVER (
           PARTITION BY ProductName
           ORDER BY OrderDate
       ) AS PreviousSales
FROM ProductOrders
WHERE SalesAmount >
      LAG(SalesAmount) OVER (
           PARTITION BY ProductName
           ORDER BY OrderDate
      );

-- 20. Create a sales leaderboard using DENSE_RANK().
SELECT ProductName,
       SalesAmount,
       DENSE_RANK() OVER (
           ORDER BY SalesAmount DESC
       ) AS LeaderboardRank
FROM ProductOrders;