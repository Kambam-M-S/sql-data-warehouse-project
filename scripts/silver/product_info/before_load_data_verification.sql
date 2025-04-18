/*
This SQL script is designed for comprehensive data validation and cleaning in the bnz_crm_prd table. 
It includes the following checks:

Null Values and Duplicate Checks:
- Ensures prd_id does not contain null values or duplicates, maintaining data integrity.

Verification of Matching Column Values:
- Validates if derived values ('cat_id' and 'prd_key') from prd_key are present in reference tables 'bnz_erp_px_cat' and 'bnz_crm_sales'.

Whitespace Removal:
- Identifies unwanted spaces in the prd_nm column to ensure consistent formatting.

Null and Negative Value Checks:
- Detects and handles null or negative values in the prd_cost column, replacing null values with 0.

Data Standardization:
- Analyzes the prd_line column for consistent and meaningful labels by correlating with prd_nm.

Date Validations:
- Ensures valid date order where prd_start_dt is not greater than prd_end_dt.
- Validates rows where prd_end_dt is null, indicating active products

*/

-- check for the null values and duplicates
-- Expectation : No results
select  * from bnz_crm_prd;

select prd_id, count(*) 
from bnz_crm_prd
group by prd_id
having count(*) > 1 or prd_id is null;
#==============================================================================================
-- check whether spiltted column values are there in matching table or not 
-- Expectation : Might be Results
select  * from bnz_crm_prd;

select 
replace(substring(prd_key,1,5),'-','_') as cat_id
from bnz_crm_prd where replace(substring(prd_key,1,5),'-','_') not in # not is used to check if any prd_key is there or not, so finding can be easy  
(select id from bnz_erp_px_cat);

select id from bnz_erp_px_cat;
#==============================================================================================
-- check whether splitted column values are there in matching table or not
-- Expectation :  Might be results
select  * from bnz_crm_prd;

select 
substring(prd_key,7,length(prd_key)) as prd_key
from bnz_crm_prd
where substring(prd_key,7,length(prd_key)) not in
(select sls_prd_key from bnz_crm_sales);

select * from bnz_crm_sales;
#==============================================================================================
-- check for the unwanted spaces
select  * from bnz_crm_prd;
select count(*) as no_of_rows from bnz_crm_prd; # to check no of rows in table

select prd_nm 
from bnz_crm_prd
where prd_nm != trim(prd_nm); # we can notice that there aren't any row with unwanted space

#==============================================================================================
-- check for the nulls and negative numbers
select  * from bnz_crm_prd;

select prd_cost
from bnz_crm_prd
where prd_cost < 0 or prd_cost is null; #As there are null values need to replace that with '0' 


#==============================================================================================
-- Data Standardization and consistency
select  * from bnz_crm_prd;

select distinct prd_line 
from bnz_crm_prd; 
--  we can observe that there is only character which does not provide clear meaning 
--  to name the characters check prd_nm column to understand what this characters mean
--  use trim function to remove unwanted data

#==============================================================================================
-- check for invalid date orders
select  * from bnz_crm_prd;
select  prd_end_dt from bnz_crm_prd where prd_end_dt is null;
-- invalid date with start date, end date and null values
select prd_id, prd_start_dt, prd_end_dt
from bnz_crm_prd
where prd_start_dt > prd_end_dt or prd_start_dt is null or prd_end_dt is null; 

-- invalid date with start date and end date
select prd_id, prd_start_dt, prd_end_dt
from bnz_crm_prd
where prd_start_dt > prd_end_dt;
-- There are rows where start date is greater than end date, which shouldn't be there.

select prd_id, prd_start_dt, prd_end_dt
from bnz_crm_prd
where prd_start_dt is null;

#==============================================================================================
