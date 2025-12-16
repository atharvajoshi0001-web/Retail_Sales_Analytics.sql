CREATE DATABASE retail_db;
USE retail_db;
CREATE TABLE Customers (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Gender VARCHAR(10),
    City VARCHAR(50),
    JoinDate DATE
);
CREATE TABLE Products (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustID INT NOT NULL,
    OrderDate DATE,
    ShipDate DATE,
    OrderStatus VARCHAR(20),
    
    CONSTRAINT fk_customer
        FOREIGN KEY (CustID) REFERENCES Customers(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
CREATE TABLE OrderDetails (
    DetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT,
    Price DECIMAL(10,2),
    Discount DECIMAL(5,2) default 0.00,
    
    CONSTRAINT fk_order
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_product
        FOREIGN KEY (ProductID) REFERENCES Products(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Customers (Name, Gender, City, JoinDate)
VALUES
('Amit Sharma', 'Male', 'Mumbai', '2023-02-10'),
('Priya Singh', 'Female', 'Delhi', '2024-01-05'),
('Rahul Patel', 'Male', 'Mumbai', '2022-11-20'),
('Sneha Rao', 'Female', 'Pune', '2023-06-12'),
('Rakesh Kumar', 'Male', 'Bengaluru', '2024-03-22'),
('Anjali Mehta', 'Female', 'Chennai', '2021-09-30'),
('Vikram Desai', 'Male', 'Ahmedabad', '2024-07-01'),
('Kavita Joshi', 'Female', 'Mumbai', '2023-12-15');

INSERT INTO Orders (CustID, OrderDate, ShipDate, OrderStatus)
VALUES
(1,'2024-01-15','2024-01-17','Shipped'),
(2,'2024-02-05','2024-02-06','Shipped'),
(3,'2024-02-20','2024-02-27','Delivered'),
(4,'2024-03-10','2024-03-15','Delivered'),
(1,'2024-03-25','2024-03-27','Shipped'),
(5,'2024-04-02',NULL,'Processing'),
(6,'2024-04-18','2024-04-20','Delivered'),
(7,'2024-05-05','2024-05-09','Delivered'),
(8,'2024-05-20','2024-05-22','Shipped'),
(2,'2024-06-11','2024-06-13','Delivered'),
(3,'2024-07-01','2024-07-06','Delivered'),
(4,'2024-07-18','2024-07-22','Returned');

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price, Discount)
VALUES
(1,2,1,499.00,0.00),
(1,5,4,49.00,0.00),
(2,1,2,2499.00,10.00),
(3,3,3,199.00,0.00),
(3,2,7,299.00,0.00),
(4,1,5,5999.00,5.00),
(5,1,1,499.00,0.00),
(5,2,8,399.00,0.00),
(6,1,6,999.00,0.00),
(7,1,2,2499.00,0.00),
(7,2,3,199.00,0.00),
-- (8,10,4,49.00,0.00)  <-- ❌ Remove this line
(9,3,1,499.00,0.00),
(9,1,7,299.00,0.00),
(10,2,2,2499.00,5.00),
(11,1,5,5999.00,10.00),
(12,1,2,2499.00,0.00),
(12,1,8,399.00,0.00),
(4,1,1,499.00,0.00),
(2,2,4,49.00,0.00);

INSERT INTO Products (Name, Category, UnitPrice)
VALUES
('Wireless Mouse','Accessories',499.00),
('Bluetooth Headphones','Electronics',2499.00),
('Water Bottle 1L','Home & Kitchen',199.00),
('Notebook - A4','Stationery',49.00),
('Office Chair','Furniture',5999.00),
('LED Desk Lamp','Home & Kitchen',999.00),
('USB-C Cable','Accessories',299.00),
('Smartphone Case','Accessories',399.00);
-- 1. List all customers from the city “Mumbai”.Retrieve all customer details whose city is exactly Mumbai.
SELECT *
FROM Customers
WHERE City = 'Mumbai';

-- 2. Show all products that have a price greater than ₹500.Display product name, category, and price where the selling price exceeds ₹500.
SELECT Name, Category, UnitPrice
FROM Products
WHERE UnitPrice > 500
ORDER BY UnitPrice DESC;

-- 3. Count the total number of orders placed during the year 2024.Use the OrderDate column to filter orders from 1-Jan-2024 to 31-Dec-2024.

SELECT COUNT(*) AS TotalOrders_2024
FROM Orders
WHERE OrderDate BETWEEN '2024-01-01' AND '2024-12-31';

-- 4. Get all unique product categories.From the products table, list distinct categories available in the store.

SELECT DISTINCT Category
FROM Products;

-- 5. Display details of customers who joined after the year 2023.Filter customers based on JoinDate > '2023-12-31'.
SELECT *
FROM Customers
WHERE JoinDate > '2023-12-31';

-- 6.show all orders whose status is “Shipped”.Retrieve order details where the order status is exactly Shipped.

SELECT *
FROM Orders
WHERE OrderStatus = 'Shipped';

-- 7. Retrieve product name and price for all products.Display only two fields: ProductName and Price.

SELECT Name AS ProductName, UnitPrice AS Price
FROM Products;

-- 8. Display all orders sorted by newest to oldest.Sort the orders by OrderDate in descending order.

SELECT *
FROM Orders
ORDER BY OrderDate DESC;

-- 9. Count total customers for each city (city-wise customer count).Group customers by City and count how many belong to each city.

SELECT City, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY City;

-- 10. Show all purchases made by a specific customer (CustomerID = 101).Retrieve order + product details for customer ID 101 from Orders + OrderDetails.

SELECT 
    o.OrderID,
    o.OrderDate,
    o.OrderStatus,
    p.Name AS ProductName,
    od.Quantity,
    od.Price,
    od.Discount
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ID
WHERE o.CustID = 1;

-- 11. Calculate total sales amount for each order line (Quantity × Price).Return OrderID, ProductID, Quantity, Price, and computed TotalSales.


SELECT
    OrderID,
    ProductID,
    Quantity,
    Price,
    (Quantity * Price) AS TotalSales
FROM OrderDetails;

SELECT COUNT(*) FROM OrderDetails;

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price, Discount)
VALUES (1,1,2,500,0);
-- 13. Compute month-wise sales for the year 2024.Group sales by month using MONTH(OrderDate) filtered for 2024.

SELECT
    MONTH(o.OrderDate) AS OrderMonth,
    SUM(od.Quantity * od.Price) AS MonthlySales
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY MONTH(o.OrderDate)
ORDER BY OrderMonth;SELECT
    MONTH(o.OrderDate) AS OrderMonth,
    SUM(od.Quantity * od.Price) AS MonthlySales
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
WHERE o.OrderDate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY MONTH(o.OrderDate)
ORDER BY OrderMonth;

-- 14. Identify the top 5 customers by total purchase value
SELECT 
    o.CustID,
    SUM(od.Quantity * od.Price) AS TotalPurchaseValue
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
GROUP BY o.CustID
ORDER BY TotalPurchaseValue DESC
LIMIT 5;

-- 15. Find the most frequently purchased product
SELECT 
    ProductID,
    COUNT(*) AS PurchaseCount
FROM OrderDetails
GROUP BY ProductID
ORDER BY PurchaseCount DESC
LIMIT 1;

-- 16. Show all orders that took more than 3 days to ship
SELECT *
FROM Orders
WHERE DATEDIFF(ShipDate, OrderDate) > 3;

-- 17. Calculate the discount amount for each order line
SELECT
    OrderID,
    ProductID,
    Quantity,
    Price,
    Discount,
    (Price * Quantity * Discount / 100) AS DiscountAmount
FROM OrderDetails;

-- 18. Show customers who have never placed any order
SELECT *
FROM Customers c
LEFT JOIN Orders o 
    ON c.ID = o.CustID
WHERE o.OrderID IS NULL;

-- 19. Show the number of orders placed by each customer
SELECT 
    CustID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustID;

-- 20. Identify product categories whose revenue exceeded ₹50,000
SELECT
    p.Category,
    SUM(od.Quantity * od.Price) AS TotalRevenue
FROM OrderDetails od
JOIN Products p 
    ON od.ProductID = p.ID
GROUP BY p.Category
HAVING TotalRevenue > 50000;

-- 21. Display the average discount applied for each product
SELECT
    ProductID,
    AVG(Discount) AS AvgDiscount
FROM OrderDetails
GROUP BY ProductID;

-- 22. Calculate customer lifetime value (total purchases)
SELECT
    o.CustID,
    SUM(od.Quantity * od.Price) AS CustomerLifetimeValue
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
GROUP BY o.CustID;

-- 23. Find the top-selling product category by total revenue
SELECT
    p.Category,
    SUM(od.Quantity * od.Price) AS TotalRevenue
FROM OrderDetails od
JOIN Products p 
    ON od.ProductID = p.ID
GROUP BY p.Category
ORDER BY TotalRevenue DESC
LIMIT 1;

-- 24. Calculate retention rate — customers who returned for repeat purchases
SELECT
    COUNT(DISTINCT CustID) AS RepeatCustomers
FROM Orders
GROUP BY CustID
HAVING COUNT(OrderID) > 1;

-- 25. Identify high-value customers (total purchase > ₹1,00,000)
SELECT
    o.CustID,
    SUM(od.Quantity * od.Price) AS TotalPurchase
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
GROUP BY o.CustID
HAVING TotalPurchase > 100000;

-- 26. Compare sales between 2023 and 2024
SELECT
    YEAR(o.OrderDate) AS SalesYear,
    SUM(od.Quantity * od.Price) AS TotalRevenue
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) IN (2023, 2024)
GROUP BY YEAR(o.OrderDate);

-- 27. Determine daily sales trend
SELECT
    DATE(o.OrderDate) AS OrderDate,
    SUM(od.Quantity * od.Price) AS DailySales
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
GROUP BY DATE(o.OrderDate);

-- 28. Identify slow-moving products (least quantity sold)
SELECT
    ProductID,
    SUM(Quantity) AS TotalQuantitySold
FROM OrderDetails
GROUP BY ProductID
ORDER BY TotalQuantitySold ASC;

-- 29. Show top 3 customers in each city using RANK()
SELECT *
FROM (
    SELECT
        c.City,
        o.CustID,
        SUM(od.Quantity * od.Price) AS TotalPurchase,
        RANK() OVER (PARTITION BY c.City ORDER BY SUM(od.Quantity * od.Price) DESC) AS CityRank
    FROM Customers c
    JOIN Orders o ON c.ID = o.CustID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY c.City, o.CustID
) ranked
WHERE CityRank <= 3;

-- 30. Calculate profit per order line
SELECT
    OrderID,
    ProductID,
    Quantity,
    Price,
    Discount,
    (Price - (Price * Discount / 100)) AS ProfitPerUnit
FROM OrderDetails;

-- 31. Calculate average order value (AOV) per customer
SELECT
    o.CustID,
    SUM(od.Quantity * od.Price) / COUNT(DISTINCT o.OrderID) AS AvgOrderValue
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
GROUP BY o.CustID;

-- 32. Display order aging (days since order date)
SELECT
    OrderID,
    OrderDate,
    DATEDIFF(CURRENT_DATE, OrderDate) AS OrderAgingDays
FROM Orders;

-- 33. Find percentage of orders shipped late
SELECT
    (SUM(CASE WHEN ShipDate > OrderDate THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS LateOrderPercentage
FROM Orders;

-- 34. Identify customers who returned after long gaps between orders
SELECT
    CustID,
    OrderDate,
    LAG(OrderDate) OVER (PARTITION BY CustID ORDER BY OrderDate) AS PreviousOrderDate,
    DATEDIFF(OrderDate, LAG(OrderDate) OVER (PARTITION BY CustID ORDER BY OrderDate)) AS GapDays
FROM Orders;

-- 35. Cluster customers into Low / Medium / High spenders
SELECT
    o.CustID,
    SUM(od.Quantity * od.Price) AS TotalSpend,
    CASE
        WHEN SUM(od.Quantity * od.Price) < 20000 THEN 'Low Spender'
        WHEN SUM(od.Quantity * od.Price) BETWEEN 20000 AND 100000 THEN 'Medium Spender'
        ELSE 'High Spender'
    END AS CustomerSegment
FROM Orders o
JOIN OrderDetails od 
    ON o.OrderID = od.OrderID
GROUP BY o.CustID;


























































