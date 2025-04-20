/*
This script facilitates data verification, quality checks, and standardization within the datawarehouse database, 
specifically focusing on the slr_erp_cust and slr_crm_cust tables.

#Key Operations:

Customer ID Checks:
- Verifies the relationship between slr_crm_cust.cst_key and slr_erp_cust.cid, confirming identical values.
- Confirms there are no null values in the cid column of slr_erp_cust.
- Ensures no duplicate entries exist by comparing the count of distinct and total cid values.

Date (bdate) Analysis:
- Checks for null values in the bdate column, with future dates already set to null.
- Retrieves the minimum and maximum dates to understand the range of data.
- Filters distinct bdate values from February 10, 1979, to the current date, ensuring valid records and flagging future-dated entries as faulty.

Gender (gen) Standardization:
- Identifies unique values in the gen column for normalization.
- Facilitates cleaning and mapping inconsistent values to standardized categories.
*/




use datawarehouse;



-- check for customer id in erp_cust table with slr_crm_cust cst_key and null values also
-- Expectation : Results with slight differences

select * from slr_crm_cust;
select * from slr_erp_cust;
-- Here we can observe that there is relation with erp_cust and crm_cust table 
-- with no difference in column values of cst_key of crm_cust table and cid of erp_cust table

select * from slr_erp_cust where cid is null;
-- there are no null values

-- Check for duplicates
select count(distinct cid) from slr_erp_cust; # distinct rows are counted
select count(cid) from slr_erp_cust; # all rows are counted 
-- For both the queries got same count which means no duplicates

#===============================================================

-- bdate checking

#checking for null values
select bdate from slr_erp_cust where bdate is null;
-- Future bdate are set to null

select min(bdate), max(bdate) from slr_erp_cust ;

SELECT DISTINCT bdate 
FROM slr_erp_cust 
WHERE bdate > '1979-02-10' AND bdate < now() 
ORDER BY bdate;
-- In first 5000 rows last year is 1979 so took 1979 to current date
-- Customer data can be there till present time, if any customer data is registered with future data then it is fault data

#=========================================================================================

-- Data Standardization and Normalization

-- check gen column for data standardization
-- Expectations : No Results

select distinct gen from slr_erp_cust;

#=============================================================================

