/*
This script validates data integrity in the slr_erp_px_cat table after loading it into the silver layer, ensuring consistency and accuracy.

Null Value Check: 
Confirms that the id column contains no null values, ensuring completeness.

Product Category Verification: 
Identifies any id values not present in slr_crm_prd, confirming potential mismatches.

Data Cleaning: 
Checks for unwanted spaces and null values in the cat, subcat, and maintenance columns, ensuring standardization.

Upload Readiness: 
Confirms that all data integrity checks align with previous verification steps, allowing direct transfer from the bronze layer to the silver layer.
*/

-- check for null values in ID of erp_px_cat table
-- Expectation : No Results

select * from slr_erp_px_cat where id is null;
-- There are no null values

-- check values of id column of erp_px_cat table is somehow match with product table 
select id from slr_erp_px_cat where id not in (select cat_id from slr_crm_prd);
-- There is 1 results where CO_PD product Category is not there in product info table
 
-- check for unwanted spaces and null values 
select cat from slr_erp_px_cat 
where cat != trim(cat) or cat is null;

select subcat from slr_erp_px_cat 
where subcat != trim(subcat) or  subcat is null;

select maintenance from slr_erp_px_cat 
where maintenance != trim(maintenance) or maintenance is null;

-- All the 3 columns are free from missing values and unwanted space 

# No Changes done in the table erp_px_cat. Direct upload of erp_px_cat table from bronze layer to silver layer can be done
