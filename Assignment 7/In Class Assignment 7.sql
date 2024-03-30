--------------------------------------------------------------------------------
------------------------------ Given Schema ------------------------------------
--------------------------------------------------------------------------------

DROP TABLE Customer;
DROP TABLE Employee;
DROP TABLE ServiceType;
DROP TABLE CustomerService;
DROP TABLE CustomerServiceSchedule;

-- Customer ( ID, Name, Address, Birthdate, Picture, Gender);
CREATE TABLE Customer (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Address VARCHAR2(255),
    Birthdate DATE,
    Picture BLOB, -- Assuming Picture is stored as Binary Large Object
    Gender VARCHAR2(10)
);

-- Employee (ID, Name, Address, ManagerID, JobTitle, CertifiedFor, StartDate, Salary);
CREATE TABLE Employee (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    Address VARCHAR2(255),
    ManagerID NUMBER,
    JobTitle VARCHAR2(100),
    CertifiedFor VARCHAR2(100),
    StartDate DATE,
    Salary NUMBER
);

-- ServiceType (ID, Name, CertificationRqts, Rate);
CREATE TABLE ServiceType (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100),
    CertificationRqts VARCHAR2(255),
    Rate NUMBER
);

-- CustomerService(CustomerID, ServiceTypeID, ExpectedDuration); 
CREATE TABLE CustomerService (
    CustomerID NUMBER,
    ServiceTypeID NUMBER,
    ExpectedDuration NUMBER, -- Assuming this is in hours or days
    FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
    FOREIGN KEY (ServiceTypeID) REFERENCES ServiceType(ID),
    PRIMARY KEY (CustomerID, ServiceTypeID)
);

-- CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status);
CREATE TABLE CustomerServiceSchedule (
    CustomerID NUMBER,
    ServiceTypeID NUMBER,
    EmployeeID NUMBER,
    StartDateTime TIMESTAMP,
    ActualDuration NUMBER, -- Assuming this is in hours or days
    Status VARCHAR2(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(ID),
    FOREIGN KEY (ServiceTypeID) REFERENCES ServiceType(ID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(ID),
    PRIMARY KEY (CustomerID, ServiceTypeID, EmployeeID, StartDateTime)
);

--------------------------------------------------------------------------------
---------------------------------- Question a. --------------------------------- 
--------------------------------------------------------------------------------

-- Unique Constraint
ALTER TABLE Customer ADD CONSTRAINT unique_customer_name UNIQUE (Name);

-- Not Null Constraint
ALTER TABLE Employee MODIFY Name VARCHAR2(100) NOT NULL;

-- Primary Key Constraint
ALTER TABLE ServiceType ADD CONSTRAINT pk_service_type_id PRIMARY KEY (ID);

-- Foreign Key Constraint
ALTER TABLE CustomerService ADD CONSTRAINT fk_customer_id FOREIGN KEY (CustomerID) REFERENCES Customer(ID);

-- Check Constraint
ALTER TABLE CustomerServiceSchedule ADD CONSTRAINT chk_actual_duration CHECK (ActualDuration >= 0);

-- Example of violating these constraints

-- Violating Unique Constraint
INSERT INTO Customer (ID, Name, Address, Birthdate, Picture, Gender) VALUES (1, 'John Doe', '123 Main St', TO_DATE('1990-01-01', 'YYYY-MM-DD'), NULL, 'Male');
INSERT INTO Customer (ID, Name, Address, Birthdate, Picture, Gender) VALUES (2, 'John Doe', '456 Elm St', TO_DATE('1992-05-15', 'YYYY-MM-DD'), NULL, 'Male');

-- Violating Not Null Constraint
UPDATE Employee SET Name = NULL WHERE ID = 1;

-- Violating Primary Key Constraint
INSERT INTO ServiceType (ID, Name, CertificationRqts, Rate) VALUES (1, 'Cleaning', 'Certification Needed', 50);
INSERT INTO ServiceType (ID, Name, CertificationRqts, Rate) VALUES (1, 'Repair', 'Certification Needed', 75);

-- Violating Foreign Key Constraint
INSERT INTO CustomerService (CustomerID, ServiceTypeID, ExpectedDuration) VALUES (100, 200, 2);

-- Violating Check Constraint
UPDATE CustomerServiceSchedule SET ActualDuration = -5 WHERE CustomerID = 1 AND ServiceTypeID = 1 AND EmployeeID = 1 AND StartDateTime = '2023-01-01 08:00:00';

--------------------------------------------------------------------------------
---------------------------------- Question b. --------------------------------- 
--------------------------------------------------------------------------------

-- Transaction 1
BEGIN
   UPDATE Employee SET Salary = Salary + 1000 WHERE ID = 1;
   COMMIT;
END;

SELECT * FROM Employee;

-- Transaction 2
BEGIN
   UPDATE Employee SET Salary = Salary + 1500 WHERE ID = 1;
   COMMIT;
END;

-- The two transactions can both execute concurrently, but there's a risk of the 
-- updates done by one transaction being lost due to the other transaction
-- overwriting them.


--------------------------------------------------------------------------------
---------------------------------- Question c. --------------------------------- 
--------------------------------------------------------------------------------

-- 1. Database Performance Tuning Guide: This guide covers various aspects of 
-- tuning database performance, including optimizing SQL statements, managing 
-- resources effectively, using indexes, partitioning data, and utilizing 
-- features like parallel execution and materialized views.

-- 2. Database Data Warehousing Guide: This guide focuses on optimizing 
-- performance specifically for data warehousing environments. It covers topics 
-- such as designing and optimizing schemas for data warehousing, utilizing 
-- partitioning and indexing strategies, optimizing query performance, and using 
-- features like materialized views and query rewrite for improving analytical 
-- query performance.
