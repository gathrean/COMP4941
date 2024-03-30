--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- SQL code from PLSQL.docx ----------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

drop table student;
drop table courses;
drop table assignments;

create table student (sid integer, sname char(80), saddress char(80), gpa integer);
create table courses (sid integer, cid integer, cgrade integer);
create table assignments ( sid integer, cid integer, aid integer, agrade integer);

create or replace trigger update_course_grades before insert or update of agrade or delete on assignments for each row
begin
	if inserting then
		update courses set cgrade = cgrade + :new.agrade where sid = :new.sid and cid = :new.cid;
	elsif updating then
		update courses set cgrade = cgrade + (:new.agrade - :old.agrade) where sid = :new.sid and cid = :new.cid;	
	elsif deleting then
		update courses set cgrade = cgrade - :old.agrade where sid = :old.sid and cid = :old.cid;
	end if;
end;
/
show errors;

create or replace procedure createStudent as 
begin
    insert into student (sid, sname, saddress, gpa) values (1, 'John', 'Surrey', 80);   
end;
/
select * from student;
execute createstudent;
select * from student;
insert into courses values(1, 4945, 0);

select * from courses;

insert into assignments values(1, 4945, 1, 75);
insert into assignments values(1, 4945, 2, 80);
insert into assignments values(1, 4945, 3, 85);

select * from courses;

create or replace procedure updategrades as
cursor c1 is select sid, cid, sum(agrade)/count(agrade) from assignments group by sid, cid;
mysid integer;
mycid integer;
mycgrade integer;
begin

open c1;
    loop
        fetch c1 into mysid, mycid, mycgrade;
        exit when c1%notfound;
        update courses set cgrade = mycgrade where sid = mysid and cid = mycid;
    end loop;
    close c1;
end;
/
show errors;
select * from courses;
execute updategrades;
select * from courses;

create or replace procedure selectstudent(stdid IN integer, myName out varchar2) as
begin
	select sname into myName from student where sid = stdid;
end;
/

show errors;
variable myName char(80);
execute selectstudent(1, :myName);
print myName;

select * from assignments;

update assignments set agrade = agrade + 5;




--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-------------------- Assignment 6 Answering Questions --------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- OLAP Query 1: Revenue generated per service type per employee
SELECT e.Name AS EmployeeName, 
       st.Name AS ServiceName, 
       SUM(css.ActualDuration * st.Rate) AS Revenue
FROM CustomerServiceSchedule css
JOIN Employee e ON css.EmployeeID = e.ID
JOIN ServiceType st ON css.ServiceTypeID = st.ID
WHERE css.StartDateTime >= TO_DATE('2000-01-01', 'YYYY-MM-DD') -- Start date of analysis period
  AND css.StartDateTime < TO_DATE('2024-02-01', 'YYYY-MM-DD') -- End date of analysis period
GROUP BY e.Name, st.Name;

--------------------------------------------------------------------------------
-- OLAP Query 2: Number of services and total duration per customer
SELECT c.Name AS CustomerName, 
       COUNT(DISTINCT css.ServiceTypeID) AS NumServices,
       SUM(css.ActualDuration) AS TotalDuration
FROM CustomerServiceSchedule css
JOIN Customer c ON css.CustomerID = c.ID
WHERE css.StartDateTime >= TO_DATE('2000-01-01', 'YYYY-MM-DD') -- Start date of analysis period
  AND css.StartDateTime < TO_DATE('2024-02-01', 'YYYY-MM-DD') -- End date of analysis period
GROUP BY c.Name;

--------------------------------------------------------------------------------
-- Star Schema Creation
CREATE TABLE DimEmployee (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Street VARCHAR(100),
    City VARCHAR(50),
    ManagerID INT,
    JobTitle VARCHAR(100),
    Certification VARCHAR(100),
    Salary INT
);

CREATE TABLE DimCustomer (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Street VARCHAR(100),
    City VARCHAR(50),
    Birthdate DATE
);

CREATE TABLE DimServiceType (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    CertificationRqts VARCHAR(100),
    Rate INT
);

CREATE TABLE DimDate (
    DateID INT PRIMARY KEY,
    CalendarDate DATE
);

CREATE TABLE FactServiceSchedule (
    ServiceScheduleID INT PRIMARY KEY,
    CustomerID INT,
    ServiceTypeID INT,
    EmployeeID INT,
    DateID INT,
    StartDateTime DATE,
    ActualDuration INT,
    Status VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(ID),
    FOREIGN KEY (ServiceTypeID) REFERENCES DimServiceType(ID),
    FOREIGN KEY (EmployeeID) REFERENCES DimEmployee(ID),
    FOREIGN KEY (DateID) REFERENCES DimDate(DateID)
);

--------------------------------------------------------------------------------
-- OLAP Query 1: Revenue generated per service type per employee using Star Schema
SELECT de.Name AS EmployeeName,
       dst.Name AS ServiceName,
       SUM(fs.ActualDuration * dst.Rate) AS Revenue
FROM FactServiceSchedule fs
JOIN DimEmployee de ON fs.EmployeeID = de.ID
JOIN DimServiceType dst ON fs.ServiceTypeID = dst.ID
WHERE fs.StartDateTime >= TO_DATE('2000-01-01', 'YYYY-MM-DD')
  AND fs.StartDateTime < TO_DATE('2024-02-01', 'YYYY-MM-DD')
GROUP BY de.Name, dst.Name;

--------------------------------------------------------------------------------
-- OLAP Query 2: Number of services and total duration per customer using Star Schema
SELECT dc.Name AS CustomerName,
       COUNT(DISTINCT fs.ServiceTypeID) AS NumServices,
       SUM(fs.ActualDuration) AS TotalDuration
FROM FactServiceSchedule fs
JOIN DimCustomer dc ON fs.CustomerID = dc.ID
WHERE fs.StartDateTime >= TO_DATE('2000-01-01', 'YYYY-MM-DD')
  AND fs.StartDateTime < TO_DATE('2024-02-01', 'YYYY-MM-DD')
GROUP BY dc.Name;

--------------------------------------------------------------------------------
-- ETL Procedures
CREATE OR REPLACE PROCEDURE ETL_LoadData AS
BEGIN
    -- Insert data into DimEmployee
    INSERT INTO DimEmployee (ID, Name, Street, City, ManagerID, JobTitle, Certification, Salary)
    SELECT ID, Name, Street, City, ManagerID, JobTitle, Certification, Salary
    FROM Employee;

    -- Insert data into DimCustomer
    INSERT INTO DimCustomer (ID, Name, Street, City, Birthdate)
    SELECT ID, Name, Street, City, Birthdate
    FROM Customer;

    -- Insert data into DimServiceType
    INSERT INTO DimServiceType (ID, Name, CertificationRqts, Rate)
    SELECT ID, Name, CertificationRqts, Rate
    FROM ServiceType;

    -- Insert data into DimDate
    INSERT INTO DimDate (DateID, CalendarDate)
    SELECT ROWNUM, TRUNC(SYSDATE) - (ROWNUM - 1)
    FROM dual CONNECT BY LEVEL <= 365; -- Assuming we want to load data for the past year

    -- Insert data into FactServiceSchedule
    INSERT INTO FactServiceSchedule (ServiceScheduleID, CustomerID, ServiceTypeID, EmployeeID, DateID, StartDateTime, ActualDuration, Status)
    SELECT css.CustomerServiceScheduleID, css.CustomerID, css.ServiceTypeID, css.EmployeeID, 
           dd.DateID, css.StartDateTime, css.ActualDuration, css.Status
    FROM CustomerServiceSchedule css
    JOIN DimDate dd ON TRUNC(css.StartDateTime) = dd.CalendarDate;
END;
/

--------------------------------------------------------------------------------
-- Triggers for ETL
CREATE OR REPLACE TRIGGER TRG_ETL_CustomerServiceSchedule
AFTER INSERT OR UPDATE OR DELETE ON CustomerServiceSchedule
BEGIN
    ETL_LoadData; -- Execute ETL procedure on any change in CustomerServiceSchedule table
END;
/

CREATE OR REPLACE TRIGGER TRG_ETL_ServiceType
AFTER INSERT OR UPDATE OR DELETE ON ServiceType
BEGIN
    ETL_LoadData; -- Execute ETL procedure on any change in ServiceType table
END;
/




