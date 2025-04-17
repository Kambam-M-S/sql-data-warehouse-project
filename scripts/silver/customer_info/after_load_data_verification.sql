/*

This script validates the slr_crm_cust table to ensure that:

- There are no null values or duplicate entries in the cst_id column (which is expected to be unique).

- Data cleanliness has been maintained, specifically checking for unwanted spaces and ensuring standardized formatting in key columns

*/

-- check for null or duplicates in primary key
-- Expectation : No results for the test

SELECT cst_id, COUNT(*) 
FROM SLR_crm_cust 
GROUP BY cst_id 
HAVING COUNT(*)>1 OR cst_id IS NULL ;
-- There are null values and duplicate cst_id, 


-- check for unwanted space
-- Expectation : No result for the test 

SELECT cst_firstname FROM SLR_crm_cust
WHERE cst_firstname != TRIM(cst_firstname);
-- There is unwanted space in cst_firstname

SELECT cst_lastname FROM SLR_crm_cust
WHERE cst_lastname != TRIM(cst_lastname);
-- There is unwanted space in cst_lastname

SELECT cst_gndr FROM SLR_crm_cust
WHERE cst_gndr != TRIM(cst_gndr);
-- There is no unwanted space in cst_gndr

SELECT cst_marital_status FROM SLR_crm_cust
WHERE cst_marital_status != TRIM(cst_marital_status);
-- There is no unwanted space in cst_marital_status

SELECT cst_create_date FROM SLR_crm_cust
WHERE cst_create_date != TRIM(cst_create_date);
-- There is no unwanted space in cst_create_date

#====================================================
-- Checking for Data Standardization and consistency

select distinct cst_gndr from SLR_crm_cust;

select distinct cst_marital_status from SLR_crm_cust;


