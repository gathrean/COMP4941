--------------------------------------------------------------------------------
------------------------------ Given SQL Queries -------------------------------
--------------------------------------------------------------------------------

drop table customer;
drop table employee;
drop table servicetype;
drop table customerservice;
drop table customerserviceschedule;

create table Customer ( ID int, Name char(20), Street char(80), City char(20), Birthdate date);
create table Employee (ID int, Name char(20), Street char(80), City char(20), ManagerID int, JobTitle char(40), Certification char(100), Salary int);
create table ServiceType (ID int, Name char(20), CertificationRqts char(100), Rate int);
create table CustomerService(CustomerID int, ServiceTypeID int, ExpectedDuration int); 
create table CustomerServiceSchedule(CustomerID int, ServiceTypeID int, EmployeeID int, StartDateTime date, ActualDuration int, Status char(20));

insert into Customer (ID,Name, Street, City, Birthdate) values (1, 'Jimmy Jazz', '123 fake street', 'Burnaby', TO_DATE('1982-01-20','yyyy-mm-dd'));
insert into Customer (ID,Name, Street, City, Birthdate) values (2, 'Bob Rock', '222 fake street', 'Vancouver', TO_DATE('1979-07-22','yyyy-mm-dd'));
insert into Customer (ID,Name, Street, City, Birthdate) values (3, 'Simone Salsa', '333 fake street', 'Pitt Meadows', TO_DATE('1985-02-14','yyyy-mm-dd'));
insert into Customer (ID,Name, Street, City, Birthdate) values (4, 'Rick Rap', '444 fake street', 'Maple Ridge', TO_DATE('1969-12-25','yyyy-mm-dd'));
insert into Customer (ID,Name, Street, City, Birthdate) values (5, 'Connie Country', '555 fake street', 'Coquitlam', TO_DATE('2000-05-24','yyyy-mm-dd'));

insert into Employee (ID, Name, Street, City, ManagerID, JobTitle, Certification, Salary) values (6, 'Barney Gumble', '123 blue collar lane', 'Burnaby', 8, 'senior staff', 'FoodSafe', 100000);
insert into Employee (ID, Name, Street, City, ManagerID, JobTitle, Certification, Salary) values (7, 'Marge Simpson', '222 blue collar lane', 'Burnaby', 8, 'intermediate staff', 'LPN', 90000);
insert into Employee (ID, Name, Street, City, ManagerID, JobTitle, Certification, Salary) values (8, 'Homer Simpson', '333 blue collar lane', 'Burnaby', 9, 'junior staff', 'LPN', 80000);
insert into Employee (ID, Name, Street, City, ManagerID, JobTitle, Certification, Salary) values (9, 'Monty Burns', '444 blue collar lane', 'Maple Ridge', 9, 'junior staff', 'Foodsafe', 70000);
insert into Employee (ID, Name, Street, City, ManagerID, JobTitle, Certification, Salary) values (10, 'Milhouse Van Houten', '555 blue collar lane', 'Pitt Meadows', 8, 'junior staff', 'RMT', 60000);

insert into ServiceType (ID, Name, CertificationRqts, Rate) values (11, 'house keeping', 'HCT', 100);
insert into ServiceType (ID, Name, CertificationRqts, Rate) values (12, 'meal prep', 'Foodsafe', 85);
insert into ServiceType (ID, Name, CertificationRqts, Rate) values (13, 'catering', 'Foodsafe', 95);
insert into ServiceType (ID, Name, CertificationRqts, Rate) values (14, 'massage therapy', 'RMT', 125);
insert into ServiceType (ID, Name, CertificationRqts, Rate) values (15, 'platinum service', 'LPN', 250);

insert into CustomerService(CustomerID, ServiceTypeID, ExpectedDuration) values (1, 11, 25); 
insert into CustomerService(CustomerID, ServiceTypeID, ExpectedDuration) values (2, 13, 15);
insert into CustomerService(CustomerID, ServiceTypeID, ExpectedDuration) values (3, 14, 120); 
insert into CustomerService(CustomerID, ServiceTypeID, ExpectedDuration) values (4, 15, 115); 
insert into CustomerService(CustomerID, ServiceTypeID, ExpectedDuration) values (5, 15, 14);
insert into CustomerService(CustomerID, ServiceTypeID, ExpectedDuration) values (5, 11, 121);  

insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (1, 11, 6, TO_DATE('2019-10-06 09:30','yyyy-mm-dd HH24:MI'), 60, 'Completed');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (1, 11, 6, TO_DATE('2019-10-01 10:30','yyyy-mm-dd HH24:MI'), 60, 'Completed');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (1, 11, 6, TO_DATE('2018-09-24 09:30','yyyy-mm-dd HH24:MI'), 60, 'Completed');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (1, 11, 6, TO_DATE('2019-10-15 10:30','yyyy-mm-dd HH24:MI'), 60, 'Completed');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (1, 11, 7, TO_DATE('2019-10-06 10:30','yyyy-mm-dd HH24:MI'), 60, 'Completed');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (2, 13, 10, TO_DATE('2019-09-24 09:30','yyyy-mm-dd HH24:MI'), 20, 'On Hold');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (3, 14, 10, TO_DATE('2019-10-06 09:30','yyyy-mm-dd HH24:MI'), 40, 'Cancelled');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (4, 15, 6, TO_DATE('2019-09-24 09:30','yyyy-mm-dd HH24:MI'), 50, 'In Progress');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (5, 15, 10, TO_DATE('2019-09-24 09:30','yyyy-mm-dd HH24:MI'), 80, 'Complete');
insert into CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status) values (5, 11, 6, TO_DATE('2019-10-06 09:30','yyyy-mm-dd HH24:MI'), 80, NULL);	


--------------------------------------------------------------------------------
----------------------------------- Commands -----------------------------------
--------------------------------------------------------------------------------

-- Question 1 [2 marks] Referring to the over OLTP schema, specify the following 
-- queries in SQL.

-- Question 1.a.
-- The Customer table may contain customers who have not yet registered for a 
-- service type i.e. there is no record for that customer in the CustomerService
-- table.  
-- On the other hand, there may exist customers who have registered for multiple 
-- different service types e.g. House Keeping and Meal Preparation etc.  
-- Thus there may be zero, one or multiple records of a customer in the 
-- CustomerService table. With this assumptions about the data, “Find the names 
-- of customers who are registered for at least two services”.

SELECT DISTINCT c.Name
FROM Customer c
INNER JOIN CustomerService cs1 ON c.ID = cs1.CustomerID
INNER JOIN CustomerService cs2 ON c.ID = cs2.CustomerID AND cs1.ServiceTypeID <> cs2.ServiceTypeID


-- Question 1.b.
-- List names of all customers along with the services that they have registered 
-- for. The list should also include customers who have not registered for any 
-- service yet.

SELECT c.Name, COALESCE(st.Name, 'None') AS ServiceName
FROM Customer c
LEFT JOIN CustomerService cs ON c.ID = cs.CustomerID
LEFT JOIN ServiceType st ON cs.ServiceTypeID = st.ID
ORDER BY c.Name, ServiceName;


-- Question 1.c.
-- “Determine the revenue generated per service type per customer during the last month”

SELECT 
    c.Name AS CustomerName,
    st.Name AS ServiceType,
    SUM(css.ActualDuration * st.Rate) AS Revenue
FROM 
    Customer c
LEFT JOIN 
    CustomerServiceSchedule css ON c.ID = css.CustomerID
LEFT JOIN 
    ServiceType st ON css.ServiceTypeID = st.ID
LEFT JOIN 
    CustomerService cs ON c.ID = cs.CustomerID AND css.ServiceTypeID = cs.ServiceTypeID
WHERE 
    css.StartDateTime >= ADD_MONTHS(TRUNC(SYSDATE), -1)
GROUP BY 
    c.Name, st.Name;


-- Question 1.d.
-- “Find all the services that all the employees are scheduled to perform today 
-- for all customers”.  The output should have columns EmployeeName, StartTime, 
-- ServiceName, CustomerCity, CustomerName.  The results should be ordered by 
-- EmployeeName and then by StartTime.

SELECT 
    e.Name AS EmployeeName,
    css.StartDateTime AS StartTime,
    st.Name AS ServiceName,
    c.City AS CustomerCity,
    c.Name AS CustomerName
FROM 
    Employee e
INNER JOIN 
    CustomerServiceSchedule css ON e.ID = css.EmployeeID
INNER JOIN 
    ServiceType st ON css.ServiceTypeID = st.ID
INNER JOIN 
    Customer c ON css.CustomerID = c.ID
WHERE 
    TRUNC(css.StartDateTime) = TRUNC(SYSDATE) -- Services scheduled for today
ORDER BY 
    e.Name, css.StartDateTime;


-- Question 2. [1 mark]  Referring to this OLTP schema, construct two SQL 
-- queries that demonstrate the use of subqueries in FROM and WITH clause, 
-- respectively.

-- first query:
SELECT 
    c.Name AS CustomerName,
    (SELECT COUNT(*) FROM CustomerService WHERE CustomerID = c.ID) AS ServiceCount
FROM 
    Customer c
ORDER BY 
    ServiceCount DESC;


-- second query:
WITH CustomerServiceCounts AS (
    SELECT 
        CustomerID,
        COUNT(*) AS ServiceCount
    FROM 
        CustomerService
    GROUP BY 
        CustomerID
)
SELECT 
    c.Name AS CustomerName,
    COALESCE(csc.ServiceCount, 0) AS ServiceCount
FROM 
    Customer c
LEFT JOIN 
    CustomerServiceCounts csc ON c.ID = csc.CustomerID
ORDER BY 
    ServiceCount DESC;


-- Question 3.

SELECT 
    e.ID AS EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID AS ManagerID,
    m.Name AS ManagerName,
    LEVEL AS HierarchyLevel
FROM 
    Employee e
LEFT JOIN 
    Employee m ON e.ManagerID = m.ID
START WITH 
    e.ManagerID IS NULL
CONNECT BY 
    PRIOR e.ID = m.ManagerID
ORDER BY 
    HierarchyLevel, EmployeeID;


