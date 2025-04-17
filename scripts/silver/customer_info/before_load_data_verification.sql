/*
The script focuses on validating the integrity, consistency, and formatting of customer data stored in the bnz_crm_cust table. 
It highlights potential issues like null values, duplicate entries, unwanted spaces, and inconsistent data values
*/


-- check for null or duplicates in primary key
-- Expectation : No results for the test

SELECT cst_id, COUNT(*) 
FROM bnz_crm_cust 
GROUP BY cst_id 
HAVING COUNT(*)>1 OR cst_id IS NULL ;
-- There are null values and duplicate cst_id, 

SELECT * FROM BNZ_CRM_CUST WHERE CST_FIRSTNAME IS NULL;
SELECT * FROM BNZ_CRM_CUST WHERE CST_LASTNAME IS NULL;

#=========================================================================
-- check for unwanted space
-- Expectation : No result for the test 

SELECT cst_firstname FROM bnz_crm_cust
WHERE cst_firstname != TRIM(cst_firstname);
-- There is unwanted space in cst_firstname

SELECT cst_lastname FROM bnz_crm_cust
WHERE cst_lastname != TRIM(cst_lastname);
-- There is unwanted space in cst_lastname

SELECT cst_gndr FROM bnz_crm_cust
WHERE cst_gndr != TRIM(cst_gndr);
-- There is no unwanted space in cst_gndr

SELECT cst_marital_status FROM bnz_crm_cust
WHERE cst_marital_status != TRIM(cst_marital_status);
-- There is no unwanted space in cst_marital_status

SELECT cst_create_date FROM bnz_crm_cust
WHERE cst_create_date != TRIM(cst_create_date);
-- There is no unwanted space in cst_create_date

#====================================================
-- Checking for Data Standardization and consistency

select distinct cst_gndr from bnz_crm_cust;

select distinct cst_marital_status from bnz_crm_cust;
