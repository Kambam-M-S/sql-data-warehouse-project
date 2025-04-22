/*
This script inserts transformed location data from bnz_erp_loc into slr_erp_loc, ensuring consistency. 

It modifies cid by removing characters from the third position while keeping the first two intact.

The cntry column is standardized by mapping 'DE' to 'Germany' and variants of 'US' to 'United States'. 

Blank or null values are replaced with 'n/a', and other country codes remain unchanged.
*/

use datawarehouse;

insert into slr_erp_loc(
cid,
CNTRY
)
select 
concat(substring(cid,1,2) , substring(cid,4,length(cid))) as cid,
case when upper(trim(cntry)) = 'DE' then 'Germany'
when upper(trim(cntry)) in ('US','USA') then 'United States'
when cntry is null  or upper(trim(cntry)) = '' then 'n/a'
else cntry
end as cntry
from bnz_erp_loc;
