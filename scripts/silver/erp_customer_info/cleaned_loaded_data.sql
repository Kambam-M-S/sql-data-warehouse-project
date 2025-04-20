/*
This script is designed to insert standardized and validated data into the slr_erp_cust table by transforming source data from bnz_erp_cust. 
It includes three primary operations:

CID Transformation: 
- Removes the prefix "NAS" from customer IDs when applicable, ensuring a clean identifier format.

Date Validation: 
- Filters out future dates in the bdate column, replacing them with NULL to maintain data accuracy.

Gender Normalization: 
- Standardizes gender values, mapping variations such as "F," "Female," "M," and "Male" to consistent categories ("Female" and "Male")
- while assigning "n/a" to unrecognized or null entries.
*/

use datawarehouse;

insert into slr_erp_cust (
cid,
bdate,
gen
)
select 
case 
when cid like 'NAS%' then substring(cid,4,char_length(cid))
else cid
end as cid,
case when bdate > now() then null
else bdate
end as bdate,
case when upper(trim(gen)) in ('F','Female') then 'Female' 
when upper(trim(gen)) in ('M','Male') then 'Male'
else 'n/a'
end as gen
from bnz_erp_cust;
