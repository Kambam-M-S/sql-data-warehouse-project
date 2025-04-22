/*
This script verifies data integrity and consistency in the bnz_erp_px_cat table before transferring it to the silver layer.

Null Value Check: 
Ensures the id column contains no null values, confirming data completeness.

Product Category Validation: 
Identifies mismatches where id values in bnz_erp_px_cat do not exist in the slr_crm_prd product table.

Data Cleaning: 
Checks for unwanted spaces and null values in the cat, subcat, and maintenance columns, ensuring standardized data.

Upload Readiness:
Confirms no modifications are needed, allowing a direct transfer of erp_px_cat from the bronze layer to the silver layer.
*/

-- check for null values in ID of erp_px_cat table
-- Expectation : No Results

select * from bnz_erp_px_cat where id is null;
-- There are no null values

-- check values of id column of erp_px_cat table is somehow match with product table 
select id from bnz_erp_px_cat where id not in (select cat_id from slr_crm_prd);
-- There is 1 results where CO_PD product Category is not there in product info table
 
-- check for unwanted spaces and null values 
select cat from bnz_erp_px_cat 
where cat != trim(cat) or cat is null;

select subcat from bnz_erp_px_cat 
where subcat != trim(subcat) or  subcat is null;

select maintenance from bnz_erp_px_cat 
where maintenance != trim(maintenance) or maintenance is null;

-- All the 3 columns are free from missing values and unwanted space

# No Changes done in the table erp_px_cat. Direct upload of erp_px_cat table from bronze layer to silver layer can be done
