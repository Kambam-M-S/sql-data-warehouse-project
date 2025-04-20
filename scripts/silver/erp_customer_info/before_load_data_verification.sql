/*
This script describes the process of performing data quality checks, analysis, and standardization within a data warehouse environment. 
It focuses on two related tables, bnz_erp_cust and slr_crm_cust, analyzing customer data for null values, duplicates, and discrepancies, followed by data standardization.

Relationship Analysis:
- he slr_crm_cust and bnz_erp_cust tables are compared to explore their relationship and identify subtle differences in column values.

Customer ID Verification:
- Null value checks are performed on the cid column in bnz_erp_cust, confirming that there are no NULL entries.
- Duplicate checks verify that the count of distinct cid values matches the total count, indicating no duplicates.

Date (bdate) Analysis:
- Null values in the bdate column are checked.
- The minimum and maximum bdate values are retrieved to determine the data range.
- A query filters for distinct bdate values within a specific range (from February 10, 1979, to the current date) 
  to identify valid records and flag any data inconsistencies, such as future-dated entries.

Data Standardization:
- The gen (gender) column is examined for inconsistent or unwanted values.

Standardization is implemented using a query that:
- Trims whitespace.
- Converts values to uppercase for uniformity.
- Maps recognized gender values (M, F, Male, Female) to consistent categories ("Male", "Female").
- Assigns "n/a" to unrecognized or null values. 

*/


use datawarehouse;



-- check for customer id in erp_cust table with slr_crm_cust cst_key and null values also
-- Expectation : Results with slight differences

select * from slr_crm_cust;
select * from bnz_erp_cust;
-- Here we can observe that there is relation with erp_cust and crm_cust table 
-- with slight difference in column values

select * from bnz_erp_cust where cid is null;
-- there are no null values

-- Check for duplicates
select count(distinct cid) from bnz_erp_cust; # distinct rows are counted
select count(cid) from bnz_erp_cust; # all rows are counted 
-- For both the queries got same count which means no duplicates

#===============================================================

-- bdate checking

#checking for null values
select bdate from bnz_erp_cust where bdate is null;

select min(bdate), max(bdate) from bnz_erp_cust ;

SELECT DISTINCT bdate 
FROM bnz_erp_cust 
WHERE bdate > '1979-02-10' AND bdate < now() 
ORDER BY bdate;
-- In first 5000 rows last year is 1979 so took 1979 to current date
-- Customer data can be there till present time, if any customer data is registered with future data then it is fault data

#=========================================================================================

-- Data Standardization and Normalization

-- check gen column for data standardization
-- Expectations : No Results

select distinct gen from bnz_erp_cust;

select 
distinct
case when upper(trim(gen)) in ('F','Female') then 'Female' 
when upper(trim(gen)) in ('M','Male') then 'Male'
else 'n/a'
end as gen
from bnz_erp_cust;
-- M F null And unwanted spaces are removed and final unique values are displayed

#==========================================================================================
