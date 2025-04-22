/*
This script ensures data integrity and validation within the datawarehouse, 
specifically focusing on the slr_erp_loc table after data loading.

Customer ID Verification: 
Confirms that cid has no null values and checks its relationship with cst_key in slr_crm_cust using a LEFT JOIN.

Data Matching: 
Retrieves cst_firstname to verify consistency between customer and location records in the silver layer.

Country (cntry) Validation: 
Ensures no null values exist in cntry and extracts distinct country values for standardization checks.

*/


use datawarehouse;

-- check for null values
-- check wheather location cid is somehow related with customer cst_key or not
-- Expectation : No Results

select cid from slr_erp_loc where cid is null; 
-- there are no null values 

select cst_firstname 
from slr_erp_loc a 
left join 
slr_crm_cust b
on
a.cid = b.cst_key;
-- For Verifying matching column values in customer table and location table of silver layer 
  
#================================================================================================
-- check for null values , Data Normalization and Standardization

select cntry from slr_erp_loc where cntry is null;
-- There are no null values

select distinct cntry from slr_erp_loc;

#============================================================================================
