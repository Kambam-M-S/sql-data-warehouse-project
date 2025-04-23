/*
This stored procedure, LOAD_SILVER(), automates data movement and standardization within 
the datawarehouse by transferring records from bronze-layer tables (bnz_*) to silver-layer tables (slr_*).

Batch Processing: 
Captures start and end timestamps to measure execution time.

Customer Data (slr_crm_cust): 
Cleans names, standardizes gender and marital status, and selects the latest records per customer.

Product Data (slr_crm_prd): 
Formats category IDs, trims names, ensures cost consistency, and refines product lifecycle dates.

Sales Data (slr_crm_sales): 
Validates and formats date fields, corrects pricing inconsistencies, and computes missing sales values.

ERP Customer & Location Data (slr_erp_cust, slr_erp_loc): 
Cleans customer identifiers, filters future birthdates, and standardizes country names.

Product Category Data (slr_erp_px_cat): 
Transfers all category records directly without modification.
*/

use datawarehouse;

CALL LOAD_SILVER();       #IF NEED TO CALL PROCEDURE WITH PARAMETERS "LOAD_SILVER(VAR1,VAR2,@OUTPUT) --> SELECT @OUTPUT" 

DELIMITER //
CREATE PROCEDURE LOAD_SILVER() # IF ATTRIBUTES ARE THE USE (IN VAR1 DATATYPE, IN VAR2 DATATYPE, IN VARN DATAYPE, OUT VAR DATAYPE)
BEGIN
	DECLARE batch_start_time Datetime; 
    DECLARE batch_end_time Datetime;
    DECLARE TOTAL_TIME INT;
    
    SET batch_start_time = NOW();
    
-- ---- FOR ENTERING TABLE DATA OF SLR_CRM_CUST ---------------------

#==============================================
truncate table slr_crm_cust;
#==============================================
INSERT INTO slr_crm_cust(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date)

SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT 
        cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS FLAG_LAST
    FROM bnz_crm_cust 
    WHERE cst_id IS NOT NULL
) T
WHERE FLAG_LAST = 1 ;

#==============================================================================================

-- ---- FOR ENTERING TABLE DATA OF SLR_CRM_PRD ---------------------


#==============================================
truncate table slr_crm_prd;
#==============================================

insert into slr_crm_prd(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
select 
prd_id,
trim(replace(substring(prd_key,1,5),'-','_')) as cat_id,
substring(prd_key,7,length(prd_key)) as prd_key,
trim(prd_nm) as prd_nm,
ifnull(prd_cost, 0) as prd_cost,
case 
when upper(trim(prd_line)) = 'R' then 'Road'
when upper(trim(prd_line)) = 'S' then 'Other Sales'
when upper(trim(prd_line)) = 'M' then 'Mountain'
when upper(trim(prd_line)) = 'T' then 'Touring'
else 'n/a'
end as prd_line,
cast(prd_start_dt as DATE) as prd_start_dt,
CAST((LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL 1 DAY) AS DATE) AS prd_end_dt
from bnz_crm_prd;

#===============================================================================================================

-- ---- FOR ENTERING TABLE DATA OF SLR_CRM_SALES ---------------------

#==============================================
truncate table slr_crm_sales;
#==============================================

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

#=========================================================================================

-- ---- FOR ENTERING TABLE DATA OF SLR_ERP_CUST ---------------------

#==============================================
truncate table slr_erp_cust;
#==============================================

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

#===================================================================================

-- ---- FOR ENTERING TABLE DATA OF SLR_ERP_LOC ---------------------

#==============================================
truncate table slr_erp_loc;
#==============================================

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

#=========================================================================================

-- ---- FOR ENTERING TABLE DATA OF SLR_ERP_PX_CAT ---------------------

#==============================================
truncate table slr_erp_px_cat;
#==============================================

insert into slr_erp_px_cat(
id, cat, subcat,maintenance
)
select 
*
from bnz_erp_px_cat;

SET batch_end_time = now();

SET total_time = TIMESTAMPDIFF(second, batch_start_time, batch_end_time);

END //

DELIMITER ;
