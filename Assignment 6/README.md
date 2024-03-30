# Instructions

[2.5 marks] The schema specified in the previous assignment is a normalized schema to support OLTP.  Analyze the OLAP needs of such application by designing at least 2 (OLAP) queries that analysts may want to run to help improve company’s business plan, efficiency, customer satisfaction or better outcomes for customers. 

Assuming that you would like to incorporate a ROLAP solution, propose a (or multiple) Star schema that you think is more suitable for such OLAP needs as opposed to the above normalized schema.  Append ‘Dim’ and ‘Facts’ to the names of the dimension and facts tables of the Star schema appropriately to distinguish from similar OLTP tables.  Identify measures that the facts table will contain.   Create the proposed star schema in Oracle database.  [Refer to this link for a quick introduction to the Star schema, dimension tables and facts tables. https://www.guru99.com/star-snowflake-data-warehousing.html#2]

Specify the above OLAP queries in SQL based on your proposed Star schema.

Towards creating a custom ETL solution using PL/SQL stored procedures and triggers to extract data from OLTP database, transform/translate to OLAP form and load into OLAP tables, use stored procedures for transferring data to a dimension that is stationary or slowly varying and a trigger for the live portion of ETL.
