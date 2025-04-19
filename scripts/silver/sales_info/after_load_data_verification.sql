/*
This SQL script verifies the data quality in the slr_crm_sales table to ensure it meets the required standards for accuracy and consistency. 
Here's an overview of the checks:

1. Unwanted Spaces: 
Confirms that the sls_ord_num column does not contain any leading or trailing spaces by comparing it with its trimmed version.

2. Product Key Matching: 
Validates that all sls_prd_key entries in slr_crm_sales exist in the prd_key column of the slr_crm_prd table.

3. Customer ID Matching: 
Ensures sls_cust_id values in slr_crm_sales are present in the cst_id column of the slr_crm_cust table.

4. Invalid Order Date: 
Checks for invalid sls_order_dt values, such as 0 or lengths not equal to 8. No such values are found.

5. Invalid Ship and Due Dates: 
Validates sls_ship_dt and sls_due_dt for proper lengths and non-zero values, ensuring no anomalies.

6. Invalid Date Orders: 
Verifies that sls_order_dt is not greater than sls_ship_dt or sls_due_dt. No invalid date orders are identified.

7. Sales, Quantity, Price Validation: 
Checks whether sls_sales equals sls_quantity * sls_price, while ensuring all values are non-null and greater than zero. 
Flags rows with null or negative values for review.
*/


-- check for unwanted Spaces with ord_sales
-- Expectation : No Results

select * from slr_crm_sales 
where sls_ord_num != Trim(sls_ord_num);  
-- There are No Unwanted Spaces in table

#=======================================================================
-- check for prd_key of sales table matching with prd_key of slr_crm_prd table
-- Expectation :  No Results
SELECT * 
FROM slr_crm_sales
WHERE sls_prd_key not IN (SELECT prd_key FROM slr_crm_prd);
-- There are no results that are not matching

#=======================================================================
-- check for cust_id of sales table matching with cust_id of slr_crm_cust table
-- Expectation : No Results

select * from slr_crm_sales
where sls_cust_id not in (select cst_id from slr_crm_cust);
-- There are no results that are not matching 

#============================================================================
-- check for Invalid order date 
-- Expectation : No Results

select  sls_order_dt from slr_crm_sales
where sls_order_dt <= 0 or length(sls_order_dt) != 8;
-- There are no value as 0

#==========================================================================
-- check for Invalid ship date
-- Expectation : No Results

select  sls_ship_dt from slr_crm_sales
where sls_ship_dt <= 0 or length(sls_ship_dt) != 8;
-- There is no value as 0 

#==========================================================================
-- check for Invalid due date
-- Expectation : No Results

select  sls_due_dt from slr_crm_sales
where sls_due_dt <= 0 or length(sls_due_dt) != 8 ;
-- There is no value as 0 

#==========================================================================
-- check for invalid date orders
-- Expectation : No Results

select * from slr_crm_sales
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_ship_dt;
-- There are no results where order date is greater than ship or due date

#==========================================================================
-- check for sales quantity price 
-- Note sales = quantity * price

select * from slr_crm_sales
where sls_sales != (sls_quantity * sls_price)
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_price
-- There are rows with null values and negative values
