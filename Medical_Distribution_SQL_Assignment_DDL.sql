CREATE DATABASE MedicalDistributionDB;

USE MedicalDistributionDB;

CREATE TABLE Manufacturer (
    ManufacturerID INT PRIMARY KEY AUTO_INCREMENT,
    ManufacturerName VARCHAR(100) NOT NULL UNIQUE,
    Country VARCHAR(50) NOT NULL,
    LicenseNo VARCHAR(30) UNIQUE,
    CreatedDate DATE DEFAULT (CURRENT_DATE)
);

DESC Manufacturer;

CREATE TABLE Distributor (
    DistributorID INT PRIMARY KEY AUTO_INCREMENT,
    DistributorName VARCHAR(100) NOT NULL,
    GSTNumber VARCHAR(20) UNIQUE,
    City VARCHAR(50) DEFAULT 'Chennai',
    ContactNo VARCHAR(15) NOT NULL
);

DESC Distributor;

CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    ManufacturerID INT,
    UnitPrice DECIMAL(10,2) CHECK(UnitPrice > 0),
    StockQty INT CHECK(StockQty >= 0),
    ExpiryDate DATE NOT NULL,

    FOREIGN KEY (ManufacturerID)
    REFERENCES Manufacturer(ManufacturerID)
);

CREATE TABLE Hospital (
    HospitalID INT PRIMARY KEY,
    HospitalName VARCHAR(100) NOT NULL,
    RegistrationNo VARCHAR(30) UNIQUE,
    City VARCHAR(50) NOT NULL
);

CREATE TABLE Pharmacy (
    PharmacyID INT PRIMARY KEY,
    PharmacyName VARCHAR(100) NOT NULL,
    LicenseNo VARCHAR(30) UNIQUE,
    ContactNo VARCHAR(15) NOT NULL
);

CREATE TABLE SalesRepresentative (
    RepID INT PRIMARY KEY,
    RepName VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) DEFAULT 25000 CHECK(Salary > 0),
    DistributorID INT,

    FOREIGN KEY (DistributorID)
    REFERENCES Distributor(DistributorID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    DistributorID INT,
    HospitalID INT,
    OrderDate DATE NOT NULL,
    OrderAmount DECIMAL(12,2) CHECK(OrderAmount > 0),

    FOREIGN KEY (DistributorID)
    REFERENCES Distributor(DistributorID),

    FOREIGN KEY (HospitalID)
    REFERENCES Hospital(HospitalID)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT CHECK(Quantity > 0),
    UnitPrice DECIMAL(10,2) CHECK(UnitPrice > 0),

    PRIMARY KEY (OrderID, ProductID),

    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID)
    ON DELETE CASCADE,

    FOREIGN KEY (ProductID)
    REFERENCES Product(ProductID)
);

CREATE TABLE Shipment (
    ShipmentID INT PRIMARY KEY,
    OrderID INT,
    ShipmentDate DATE NOT NULL,

    Status VARCHAR(20)
    CHECK(Status IN ('Pending','Shipped','Delivered')),

    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,

    Amount DECIMAL(12,2)
    CHECK(Amount > 0),

    PaymentMode VARCHAR(20)
    CHECK(PaymentMode IN ('Cash','UPI','Card','NEFT')),

    FOREIGN KEY (OrderID)
    REFERENCES Orders(OrderID)
);

SHOW TABLES;

-- Load Manufacturer Data
INSERT INTO Manufacturer
(ManufacturerID, ManufacturerName, Country, LicenseNo)
VALUES
(1,'MedLife Pharma','India','LIC1001'),
(2,'HealthCare Labs','India','LIC1002'),
(3,'BioCure Pharma','USA','LIC1003'),
(4,'Apex Medicines','UK','LIC1004'),
(5,'Global Drugs','Germany','LIC1005');

-- Load Distributor Data
INSERT INTO Distributor
(DistributorID, DistributorName, GSTNumber, City, ContactNo)
VALUES
(101,'South Medical Distributors','GST1001','Chennai','9876543210'),
(102,'Health Supply Chain','GST1002','Bangalore','9876543211'),
(103,'Pharma Logistics','GST1003','Hyderabad','9876543212'),
(104,'Care Distributors','GST1004','Mumbai','9876543213'),
(105,'Med Express','GST1005','Delhi','9876543214');

-- Load Product Data
INSERT INTO Product
(ProductID, ProductName, ManufacturerID, UnitPrice, StockQty, ExpiryDate)
VALUES
(1001,'Paracetamol 500mg',1,15.50,5000,'2027-12-31'),
(1002,'Amoxicillin 250mg',2,45.00,3000,'2027-08-15'),
(1003,'Vitamin C Tablets',3,10.00,4500,'2028-01-31'),
(1004,'Insulin Injection',4,250.00,1000,'2026-10-31'),
(1005,'BP Control Tablet',5,75.00,2500,'2027-05-30');

-- Referential Integrity Check #1
SELECT
    p.ProductID,
    p.ProductName,
    m.ManufacturerName
FROM Product p
JOIN Manufacturer m
ON p.ManufacturerID = m.ManufacturerID;

-- Load Hospital Data
INSERT INTO Hospital
(HospitalID, HospitalName, RegistrationNo, City)
VALUES
(201,'Apollo Hospital','REG1001','Chennai'),
(202,'Fortis Hospital','REG1002','Bangalore'),
(203,'Global Hospital','REG1003','Hyderabad'),
(204,'Care Hospital','REG1004','Mumbai'),
(205,'Medway Hospital','REG1005','Chennai'),
(206,'SIMS Hospital','REG1006','Chennai'),
(207,'Manipal Hospital','REG1007','Bangalore'),
(208,'Rainbow Hospital','REG1008','Hyderabad'),
(209,'MGM Hospital','REG1009','Chennai'),
(210,'Kauvery Hospital','REG1010','Trichy');

-- Load Pharmacy Data
INSERT INTO Pharmacy
(PharmacyID, PharmacyName, LicenseNo, ContactNo)
VALUES
(301,'Apollo Pharmacy','PH1001','9000011111'),
(302,'MedPlus','PH1002','9000011112'),
(303,'NetMeds Store','PH1003','9000011113'),
(304,'Wellness Forever','PH1004','9000011114'),
(305,'Care Pharmacy','PH1005','9000011115'),
(306,'Trust Pharmacy','PH1006','9000011116'),
(307,'Health Pharmacy','PH1007','9000011117'),
(308,'MedCare Pharmacy','PH1008','9000011118'),
(309,'LifeCare Pharmacy','PH1009','9000011119'),
(310,'City Pharmacy','PH1010','9000011120');

-- Load SalesRepresentative Data
INSERT INTO SalesRepresentative
(RepID, RepName, Salary, DistributorID)
VALUES
(401,'Rajesh Kumar',35000,101),
(402,'Priya Sharma',32000,102),
(403,'Arun Kumar',30000,103),
(404,'Kiran Rao',34000,104),
(405,'Vijay Kumar',36000,105),
(406,'Suresh Babu',33000,101),
(407,'Anita Singh',31000,102),
(408,'Deepak Verma',37000,103),
(409,'Lakshmi Devi',34000,104),
(410,'Ramesh Gupta',35000,105);

-- Referential Integrity Check #2
SELECT
    s.RepID,
    s.RepName,
    d.DistributorName
FROM SalesRepresentative s
JOIN Distributor d
ON s.DistributorID = d.DistributorID;

-- Load Orders Data
INSERT INTO Orders
(OrderID, DistributorID, HospitalID, OrderDate, OrderAmount)
VALUES
(5001,101,201,'2026-06-01',25000),
(5002,102,202,'2026-06-02',35000),
(5003,103,203,'2026-06-03',45000),
(5004,104,204,'2026-06-04',28000),
(5005,105,205,'2026-06-05',55000),
(5006,101,206,'2026-06-06',30000),
(5007,102,207,'2026-06-07',42000),
(5008,103,208,'2026-06-08',38000),
(5009,104,209,'2026-06-09',47000),
(5010,105,210,'2026-06-10',60000);

-- Load OrderDetails Data
INSERT INTO OrderDetails
(OrderID, ProductID, Quantity, UnitPrice)
VALUES
(5001,1001,500,15.50),
(5001,1002,200,45.00),
(5002,1003,1000,10.00),
(5002,1005,300,75.00),
(5003,1004,100,250.00),
(5003,1001,600,15.50),
(5004,1005,250,75.00),
(5005,1002,400,45.00),
(5006,1003,800,10.00),
(5007,1004,120,250.00);

-- Verify Composite Primary Key
SHOW INDEX FROM OrderDetails;

-- Verify Orders → OrderDetails Relationship
SELECT
    o.OrderID,
    od.ProductID,
    od.Quantity
FROM Orders o
JOIN OrderDetails od
ON o.OrderID = od.OrderID;

-- Load Shipment Data
INSERT INTO Shipment
(ShipmentID, OrderID, ShipmentDate, Status)
VALUES
(7001,5001,'2026-06-02','Delivered'),
(7002,5002,'2026-06-03','Shipped'),
(7003,5003,'2026-06-04','Pending'),
(7004,5004,'2026-06-05','Delivered'),
(7005,5005,'2026-06-06','Shipped'),
(7006,5006,'2026-06-07','Delivered'),
(7007,5007,'2026-06-08','Pending'),
(7008,5008,'2026-06-09','Shipped'),
(7009,5009,'2026-06-10','Delivered'),
(7010,5010,'2026-06-11','Pending');

-- Load Payments Data
INSERT INTO Payments
(PaymentID, OrderID, Amount, PaymentMode)
VALUES
(8001,5001,25000,'UPI'),
(8002,5002,35000,'Card'),
(8003,5003,45000,'NEFT'),
(8004,5004,28000,'Cash'),
(8005,5005,55000,'UPI'),
(8006,5006,30000,'Card'),
(8007,5007,42000,'NEFT'),
(8008,5008,38000,'Cash'),
(8009,5009,47000,'UPI'),
(8010,5010,60000,'Card');

SELECT * FROM Manufacturer;
SELECT * FROM Distributor;
SELECT * FROM Product;
SELECT * FROM Hospital;
SELECT * FROM Pharmacy;
SELECT * FROM SalesRepresentative;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;
SELECT * FROM Shipment;
SELECT * FROM Payments;

-- Verify Payment ↔ Orders Relationship
SELECT
    p.PaymentID,     
    o.OrderID,
    p.Amount,
    p.PaymentMode
FROM Payments p
JOIN Orders o
ON p.OrderID = o.OrderID;

-- ///////////Implement ON DELETE CASCADE between Orders and OrderDetails. 
-- Let's test it. // Before Deleting // Check Order 5001 exists:
-- //////////////////////////////////////////////////////////////////////
SELECT *
FROM OrderDetails
WHERE OrderID = 5001;

-- Delete dependent records
DELETE FROM Payments
WHERE OrderID = 5001;
DELETE FROM Shipment
WHERE OrderID = 5001;

-- Delete the parent order
DELETE FROM Orders
WHERE OrderID = 5001;

SELECT *
FROM OrderDetails
WHERE OrderID = 5001;

/* OrderDetails table was created with a foreign key referencing Orders(OrderID) using ON DELETE CASCADE. 
When OrderID 5001 was deleted from the Orders table, the related records in OrderDetails were 
automatically deleted, demonstrating successful cascade behavior. */

-- ////Restore the deleted data
-- Before moving to DQL queries, restoring the deleted records so your dataset remains complete.

-- Reinsert Order
INSERT INTO Orders
(OrderID, DistributorID, HospitalID, OrderDate, OrderAmount)
VALUES
(5001,101,201,'2026-06-01',25000);

-- Reinsert OrderDetails
INSERT INTO OrderDetails
(OrderID, ProductID, Quantity, UnitPrice)
VALUES
(5001,1001,500,15.50),
(5001,1002,200,45.00);

-- Reinsert Shipment
INSERT INTO Shipment
(ShipmentID, OrderID, ShipmentDate, Status)
VALUES
(7001,5001,'2026-06-02','Delivered');

-- Reinsert Payment
INSERT INTO Payments
(PaymentID, OrderID, Amount, PaymentMode)
VALUES
(8001,5001,25000,'UPI');

-- ///////////////////////////////////Referential Integrity Verification.//////////////////////////
-- Verification Query 1: Product ↔ Manufacturer
SELECT
    p.ProductID,
    p.ProductName,
    m.ManufacturerName
FROM Product p
JOIN Manufacturer m
ON p.ManufacturerID = m.ManufacturerID;

-- Verification Query 2: SalesRepresentative ↔ Distributor
SELECT
    s.RepID,
    s.RepName,
    d.DistributorName
FROM SalesRepresentative s
JOIN Distributor d
ON s.DistributorID = d.DistributorID;

-- Verification Query 3: Orders ↔ Hospital
SELECT
    o.OrderID,
    h.HospitalName
FROM Orders o
JOIN Hospital h
ON o.HospitalID = h.HospitalID;

-- Verification Query 4: Orders ↔ Distributor
SELECT
    o.OrderID,
    d.DistributorName
FROM Orders o
JOIN Distributor d
ON o.DistributorID = d.DistributorID;

-- Verification Query 5: Payments ↔ Orders
SELECT
    p.PaymentID,
    p.OrderID,
    o.OrderDate
FROM Payments p
JOIN Orders o
ON p.OrderID = o.OrderID;

-- Verification Query 6: Shipment ↔ Orders
SELECT
    s.ShipmentID,
    s.OrderID,
    o.OrderDate
FROM Shipment s
JOIN Orders o
ON s.OrderID = o.OrderID;

/* Referential integrity was verified using JOIN queries between parent and 
child tables such as Product–Manufacturer, SalesRepresentative–Distributor, 
Orders–Hospital, Orders–Distributor, Payments–Orders, and Shipment–Orders. 
The successful retrieval of matching records confirmed that all 
foreign key relationships were valid and consistent.  */

-- Top-Selling Medicines
SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS TotalSold
FROM Product p
JOIN OrderDetails od
ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalSold DESC;

-- Total Sales by Hospital
SELECT
    h.HospitalName,
    SUM(o.OrderAmount) AS TotalSales
FROM Hospital h
JOIN Orders o
ON h.HospitalID = o.HospitalID
GROUP BY h.HospitalName
;

-- Pending Shipments
SELECT
    ShipmentID,
    OrderID,
    ShipmentDate,
    Status
FROM Shipment
WHERE Status = 'Pending';

-- Low-Stock Products
SELECT
    ProductID,
    ProductName,
    StockQty
FROM Product
WHERE StockQty < 2000;

-- Distributor-wise Sales Summary
SELECT
    d.DistributorName,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.OrderAmount) AS TotalSales
FROM Distributor d
JOIN Orders o
ON d.DistributorID = o.DistributorID
GROUP BY d.DistributorName
ORDER BY TotalSales DESC;