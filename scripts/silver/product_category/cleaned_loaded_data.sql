use datawarehouse;

insert into slr_erp_px_cat(
id, cat, subcat,maintenance
)
select 
*
from bnz_erp_px_cat;
