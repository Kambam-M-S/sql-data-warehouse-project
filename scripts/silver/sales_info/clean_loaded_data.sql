/*
This SQL script is executed to transform and load cleaned data 
from the bnz_crm_sales table into the slr_crm_sales table. 
- It ensures that the final data is accurate, consistent, and ready for analytical purposes. 
Here's what the script covers:

Date Column Validation and Transformation: 
- Validates date columns (sls_order_dt, sls_ship_dt, sls_due_dt) by checking 
  for invalid values (e.g., 0 or incorrect length) and converts them to the DATE format. 
- Invalid dates are set to NULL.

Sales Column Validation: 
- Ensures sls_sales is correct by recalculating it as sls_quantity * ABS(sls_price) 
- when the value is missing, less than or equal to zero, or inconsistent with the formula.

Price Column Correction: 
- Fixes invalid sls_price values, recalculating them as sls_sales / sls_quantity 
- when missing or less than or equal to zero, ensuring meaningful pricing data.

Final Data Loading: 
- Inserts the cleaned and validated data into slr_crm_sales, 
- ensuring it meets the expected standards for further analysis.
*/

use datawarehouse;

select * from bnz_crm_sales;

desc slr_crm_sales;

insert into slr_crm_sales(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)
select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
case 
when sls_order_dt = 0 or length(sls_order_dt) != 8 then null
else cast(cast(sls_order_dt as char(12)) as date)
end as sls_order_dt,
case when sls_ship_dt = 0 or length(sls_ship_dt) != 8  then null
else cast(cast(sls_ship_dt as char(12)) as date)
end as sls_ship_dt,
case when sls_due_dt = 0 or length(sls_due_dt) != 8 then null
else cast(cast(sls_due_dt as char(12)) as date)
end as sls_due_dt,
case when sls_sales is null or sls_sales <= 0 or sls_sales != (sls_quantity * abs(sls_price)) 
then sls_quantity * abs(sls_price)
else sls_sales
end as sls_sales,
sls_quantity,
case when sls_price is null or sls_price <= 0 then sls_sales / ifnull(sls_quantity,0)
else sls_price
end as sls_price
from bnz_crm_sales;
