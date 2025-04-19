/*
This SQL script performs comprehensive data quality checks on the bnz_crm_sales table to ensure accuracy, consistency, and integrity before further use. Here's what it verifies:

Unwanted Spaces: 
Ensures there are no unwanted spaces in the sls_ord_num column by comparing it with its trimmed version.

Product Key Matching: 
Confirms that the sls_prd_key values in the bnz_crm_sales table exist in the slr_crm_prd table.

Customer ID Matching: 
Checks that the sls_cust_id values in bnz_crm_sales are present in the slr_crm_cust table.

Invalid Order Date: 
Identifies invalid sls_order_dt values (e.g., 0 or incorrect length) for correction or null replacement.

Invalid Ship and Due Dates: 
Validates sls_ship_dt and sls_due_dt for proper length and non-zero values, ensuring type casting where necessary.

Date Order Validation: 
Ensures no records have an order date (sls_order_dt) greater than the ship or due date.

Sales, Quantity, Price Validation: 
Verifies that sls_sales matches sls_quantity * sls_price, and identifies rows with null, zero, or negative values in the sls_sales, sls_quantity, or sls_price column
*/




-- check for unwanted Spaces with ord_sales
-- Expectation : No Results

select * from bnz_crm_sales 
where sls_ord_num != Trim(sls_ord_num);  
-- There are No Unwanted Spaces in table

#=======================================================================
-- check for prd_key of sales table matching with prd_key of slr_crm_prd table
-- Expectation :  No Results
SELECT * 
FROM bnz_crm_sales
WHERE sls_prd_key not IN (SELECT prd_key FROM slr_crm_prd);
-- There are no results that are not matching

#=======================================================================
-- check for cust_id of sales table matching with cust_id of slr_crm_cust table
-- Expectation : No Results

select * from bnz_crm_sales
where sls_cust_id not in (select cst_id from slr_crm_cust);
-- There are no results that are not matching 

#============================================================================
-- check for Invalid order date 
-- Expectation : No Results

select  sls_order_dt from bnz_crm_sales
where sls_order_dt <= 0 or length(sls_order_dt) != 8;
-- There are values as 0 which need to be replaced with null
-- As Data Type is integer type cast to date type

#==========================================================================
-- check for Invalid ship date
-- Expectation : No Results

select  sls_ship_dt from bnz_crm_sales
where sls_ship_dt <= 0 or length(sls_ship_dt) != 8;
-- There is no value as 0 
-- As Data Type is integer, type casting is necessary

#==========================================================================
-- check for Invalid due date
-- Expectation : No Results

select  sls_due_dt from bnz_crm_sales
where sls_due_dt <= 0 or length(sls_due_dt) != 8 ;
-- There is no value as 0 
-- As Data Type is integer, type casting is necessary
#==========================================================================
-- check for invalid date orders
-- Expectation : No Results
select * from bnz_crm_sales
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_ship_dt;
-- There are no results where order date is greater than ship or due date

#==========================================================================
-- check for sales quantity price 
-- Note sales = quantity * price

select * from bnz_crm_sales
where sls_sales != (sls_quantity * sls_price)
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_price
-- There are rows with null values and negative values
