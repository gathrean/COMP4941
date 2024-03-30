# In Class Assignment VII (Persistence Optimization)

Consider again the schema from In Class Assignment V:

```PLSQL
Customer ( ID, Name, Address, Birthdate, Picture, Gender);
Employee (ID, Name, Address, ManagerID, JobTitle, CertifiedFor, StartDate, Salary);
ServiceType (ID, Name, CertificationRqts, Rate);
CustomerService(CustomerID, ServiceTypeID, ExpectedDuration); 
CustomerServiceSchedule(CustomerID, ServiceTypeID, EmployeeID, StartDateTime, ActualDuration, Status);
```

1. [1 mark] Referring to the OLTP schema of Comp 4941 Assignment I, demonstrate the use of unique (on one or multiple columns), not null, primary key, foreign key and check constraints to ensure the data integrity of the above database.  Write the SQL (DML) Statements that will violate the above integrity constraints and the SQL statements that will succeed.
2. [1 mark] Provide example of an interleaved execution of two concurrent transactions, utilizing the above database, that would suffer from the lost update problem.  Show that the use of transactions would circumvent the issue of lost update.
3. [1 mark]  Summarize and verify strategies available in Oracle to improve performance of OLAP queries. 

The following tutorials present performance tuning opportunities available in oracle 12c.  Summarize these two tutorials.  Create the OLAP schema of Comp 4941 Assignment I on oracle server (e.g. 19c) to verify that using indexes, data partitions and materialized views and query rewrites etc indeed improved performance.  Use “Explain For” to verify that queries resulted in better performance when these were utilized.  For now you can incorporate and verify any one of these techniques. 

https://docs.oracle.com/cd/E82638_01/tgdba/database-performance-tuning-guide.pdf

https://docs.oracle.com/en/database/oracle/oracle-database/12.2/dwhsg/database-data-warehousing-guide.pdf

```text
explain plan for select * from student where id = 1;
select plan_table_output from table(dbms_xplan.display(‘plan_table’, null, ‘basic’));
select * from table(dbms_xplan.display);
```
