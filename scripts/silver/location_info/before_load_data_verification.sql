/*
Customer ID Validation: Ensures cid in bnz_erp_loc has no null values and checks its relation to cst_key in slr_crm_cust.

CID Format Adjustment: Removes hyphens or modifies cid structure to match cst_key for better consistency.

Country Normalization: Identifies null values in cntry and standardizes country names like 'DE' to 'Germany' and 'US' to 'United States'.

Data Cleaning: Assigns 'n/a' to blank or null entries, improving data accuracy and consistency for location records.
*/

use datawarehouse;

-- check for null values
-- check wheather location cid is somehow related with customer cst_key or not
-- Expectation : No Results

select cid from bnz_erp_loc where cid is null; 
-- there are no null values 

#1method
-- select cid from bnz_erp_loc where replace(cid,'-','') not in (select cst_key from slr_crm_cust);

select replace(cid,'-','') from bnz_erp_loc ;

#2 method
select 
cid
from bnz_erp_loc where concat(substring(cid,1,2) , substring(cid,4,length(cid))) not in (select cst_key from slr_crm_cust);
-- with slight chances to cid column values of location table, we get match values from cst_key column of customer table.
  
#================================================================================================
-- check for null values , Data Normalization and Standardization

select cntry from bnz_erp_loc where cntry is null;
-- There are null values

select distinct cntry from bnz_erp_loc;
-- US, USA : United States, DE: Germany, Null and space : n/a

select distinct
case when upper(trim(cntry)) = 'DE' then 'Germany'
when upper(trim(cntry)) in ('US','USA') then 'United States'
when cntry is null  or upper(trim(cntry)) = '' then 'n/a'
else cntry
end as cntry
from bnz_erp_loc;
-- Finally CID and CNTRY columns are cleaned
