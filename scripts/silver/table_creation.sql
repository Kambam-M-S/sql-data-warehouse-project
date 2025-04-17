/*
This script is designed to manage and structure tables in a data warehouse environment. 
It includes commands for dropping existing tables (if any) and creating new ones with predefined columns and default values.
*/

use datawarehouse;

drop table if exists slr_crm_cust;
create table slr_crm_cust(
cst_id int null,
cst_key varchar(50) null,
cst_firstname varchar(50) null,
cst_lastname varchar(50) null,
cst_material_status varchar(50) null,
cst_gndr varchar(50) null,
cst_create_date date null,
dwh_create_date datetime default now()
);


drop  table if exists slr_crm_prd;
create table slr_crm_prd(
prd_id int,
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line char(1),
prd_start_dt date, 
prd_end_dt date,
dwh_create_date datetime default now()
);

drop table if exists slr_crm_sales;
create table slr_crm_sales(
sls_ord_num varchar(20),
sls_prd_key varchar(20), 
sls_cust_id int, 
sls_order_dt date, 
sls_ship_dt date, 
sls_due_dt date, 
sls_sales int, 
sls_quantity int, 
sls_price int,
dwh_create_date datetime default now()
);

drop table if exists slr_erp_cust;
create table slr_erp_cust(
cid varchar(20),
bdate date, 
gen varchar(10),
dwh_create_date datetime default now()
);

drop table if exists slr_erp_loc;
create table slr_erp_loc(
cid varchar(10),
cntry varchar(20),
dwh_create_date datetime default now()
);

drop table if exists slr_erp_px_cat;
create table slr_erp_px_cat(
id varchar(10),
cat varchar(30), 
subcat varchar(50),
maintenance varchar(3),
dwh_create_date datetime default now()
);

-- -------------------------------------------------------------------------------------------	
