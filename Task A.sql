SELECT * FROM Sales.Customer;



SELECT c.*
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name LIKE '%N';



SELECT c.*
FROM Sales.Customer c
JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
WHERE a.City IN ('Berlin', 'London');



SELECT c.*
FROM Sales.Customer c
JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('United Kingdom', 'United States');



SELECT * FROM Production.Product ORDER BY Name;


SELECT * FROM Production.Product WHERE Name LIKE 'A%';


SELECT DISTINCT c.*
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID;



SELECT DISTINCT c.*
FROM Sales.Customer c
JOIN Person.BusinessEntityAddress bea ON c.CustomerID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE a.City = 'London' AND p.Name = 'Chai';



SELECT * 
FROM Sales.Customer 
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader);



SELECT DISTINCT c.*
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.Name = 'Tofu';


SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY OrderDate ASC;


SELECT TOP 1 soh.SalesOrderID, soh.OrderDate, 
              SUM(sod.OrderQty * sod.UnitPrice) AS TotalPrice
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.SalesOrderID, soh.OrderDate
ORDER BY TotalPrice DESC;


SELECT SalesOrderID, AVG(OrderQty) AS AverageQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;


SELECT SalesOrderID, MIN(OrderQty) AS MinQuantity, MAX(OrderQty) AS MaxQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;


SELECT 
    m.BusinessEntityID, 
    p.FirstName, 
    p.LastName, 
    COUNT(e.BusinessEntityID) AS NumEmployees
FROM 
    HumanResources.Employee e
JOIN 
    HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN 
    Person.Person p ON m.BusinessEntityID = p.BusinessEntityID
GROUP BY 
    m.BusinessEntityID, 
    p.FirstName, 
    p.LastName;


SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'Canada';

SELECT * FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;


SELECT cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name;


SELECT p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName;


SELECT p.FirstName, p.LastName, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;


SELECT DISTINCT p.*
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.DiscontinuedDate IS NOT NULL
  AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';


SELECT 
    e.BusinessEntityID AS EmployeeID, 
    pe.FirstName AS EmployeeFirstName, 
    pe.LastName AS EmployeeLastName, 
    m.BusinessEntityID AS SupervisorID, 
    pm.FirstName AS SupervisorFirstName, 
    pm.LastName AS SupervisorLastName
FROM 
    HumanResources.Employee e
JOIN 
    Person.Person pe ON e.BusinessEntityID = pe.BusinessEntityID
JOIN 
    HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN 
    Person.Person pm ON m.BusinessEntityID = pm.BusinessEntityID;



SELECT e.BusinessEntityID, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN HumanResources.Employee e ON soh.SalesPersonID = e.BusinessEntityID
GROUP BY e.BusinessEntityID;



SELECT e.BusinessEntityID, p.FirstName, p.LastName
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE p.FirstName LIKE '%a%';



SELECT m.BusinessEntityID, COUNT(e.BusinessEntityID) AS NumEmployees
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
GROUP BY m.BusinessEntityID
HAVING COUNT(e.BusinessEntityID) > 4;


SELECT soh.SalesOrderID, p.Name
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;



WITH BestCustomer AS (
    SELECT TOP 1 soh.CustomerID
    FROM Sales.SalesOrderHeader soh
    GROUP BY soh.CustomerID
    ORDER BY SUM(soh.TotalDue) DESC
)
SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN BestCustomer bc ON soh.CustomerID = bc.CustomerID;


SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
WHERE pp.PhoneNumber IS NULL;


SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';


SELECT DISTINCT p.Name
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'France';


SELECT DISTINCT p.Name
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'France';



SELECT p.Name AS ProductName, pc.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
JOIN Production.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';



SELECT p.*
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

SELECT p.*
FROM Production.Product p
WHERE p.UnitsInStock < 10 AND p.UnitsOnOrder = 0;


SELECT TOP 10 cr.Name AS Country, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name
ORDER BY TotalSales DESC;


SELECT e.BusinessEntityID, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN HumanResources.Employee e ON soh.SalesPersonID = e.BusinessEntityID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
WHERE c.AccountNumber BETWEEN 'A' AND 'AO'
GROUP BY e.BusinessEntityID;


SELECT TOP 1 soh.OrderDate
FROM Sales.SalesOrderHeader soh
ORDER BY soh.TotalDue DESC;



SELECT p.Name, SUM(sod.OrderQty * sod.UnitPrice) AS TotalRevenue
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;


SELECT pv.BusinessEntityID AS SupplierID, COUNT(pv.ProductID) AS ProductCount
FROM Production.ProductVendor pv
GROUP BY pv.BusinessEntityID;



SELECT TOP 10 c.CustomerID, SUM(soh.TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
GROUP BY c


SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;





