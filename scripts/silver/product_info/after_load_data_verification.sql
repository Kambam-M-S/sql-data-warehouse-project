/*
This SQL script is executed to verify data quality in the slr_crm_prd table after cleaning and transforming the data. 
It ensures that the loaded data meets the expected standards and identifies any remaining inconsistencies. 
Here’s what the script covers:

Check for Null Values and Duplicates:
- Ensures there are no null values or duplicate entries in the prd_id column, maintaining the uniqueness and integrity of data.

Verify Matching Column Values:
- Confirms whether the split column values (cat_id and prd_key) properly align with their reference tables (slr_erp_px_cat and slr_crm_sales).

Whitespace Validation:
- Detects any unwanted spaces in the prd_nm column, ensuring all entries are cleanly formatted.

Check for Nulls and Negative Values:
- Identifies rows with null or negative values in the prd_cost column and flags them for correction.

Data Standardization and Consistency:
- Verifies distinct values in the prd_line column for standardized and meaningful labels, referencing the prd_nm column as needed for interpretation.

Date Order Validation:
- Ensures proper chronological order between prd_start_dt and prd_end_dt:
  -> Confirms rows with null values in prd_end_dt indicate active products.
  -> Validates rows where prd_start_dt is greater than prd_end_dt, checking for potential errors

*/



-- check for the null values and duplicates
-- Expectation : No results
select  * from slr_crm_prd;

select prd_id, count(*) 
from slr_crm_prd
group by prd_id
having count(*) > 1 or prd_id is null;
#==============================================================================================
-- check whether spiltted column values are there in matching table or not 
-- Expectation : Might be Results
select  * from slr_crm_prd;

select 
replace(substring(prd_key,1,5),'-','_') as cat_id
from slr_crm_prd where replace(substring(prd_key,1,5),'-','_') not in # not is used to check if any prd_key is there or not, so finding can be easy  
(select id from slr_erp_px_cat);

select id from slr_erp_px_cat;
#==============================================================================================
-- check whether splitted column values are there in matching table or not
-- Expectation :  Might be results
select  * from slr_crm_prd;

select 
substring(prd_key,7,length(prd_key)) as prd_key
from bnz_crm_prd
where substring(prd_key,7,length(prd_key)) not in
(select sls_prd_key from slr_crm_sales);

select * from slr_crm_sales;
#==============================================================================================
-- check for the unwanted spaces
select  * from slr_crm_prd;
select count(*) as no_of_rows from slr_crm_prd; # to check no of rows in table

select prd_nm 
from slr_crm_prd
where prd_nm != trim(prd_nm); # we can notice that there aren't any row with unwanted space

#==============================================================================================

-- check for the nulls and negative numbers
select  * from slr_crm_prd;

select prd_cost
from slr_crm_prd
where prd_cost < 0 or prd_cost is null; #As there are null values need to replace that with '0' 


#==============================================================================================
-- Data Standardization and consistency
select  * from slr_crm_prd;

select distinct prd_line 
from slr_crm_prd; 
--  we can observe that there is only character which does not provide clear meaning 
--  to name the characters check prd_nm column to understand what this characters mean
--  use trim function to remove unwanted data

#==============================================================================================
-- check for invalid date orders
select  * from slr_crm_prd;

select  prd_end_dt from slr_crm_prd where prd_end_dt is null;
-- End date is null in some rows which means product is still active. so there is no end date for that product.

-- invalid date with start date, end date and null values
select prd_id, prd_start_dt, prd_end_dt
from slr_crm_prd
where prd_start_dt > prd_end_dt or prd_start_dt is null or prd_end_dt is null; 
-- There is start date for some products but no end date which tells that product started is still active 

-- invalid date with start date and end date
select prd_id, prd_start_dt, prd_end_dt
from slr_crm_prd
where prd_start_dt > prd_end_dt;
-- There are no rows where start date is greater than end date.

select prd_id, prd_start_dt, prd_end_dt
from slr_crm_prd
where prd_start_dt is null;
-- Neither start date nor end date is null in any row of table
#==============================================================================================
