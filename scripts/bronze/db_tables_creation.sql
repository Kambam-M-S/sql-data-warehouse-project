/*
==============================================================================
Script Name: Bronze Layer Tables - DDL Creation
==============================================================================
Purpose:
  This script defines the Data Definition Language (DDL) for creating
  tables in the 'datawarehouse' database. It ensures existing tables 
  are dropped before re-creating them to maintain structure integrity.
Execution:
  Use this script to re-establish the structure of Bronze Layer tables 
  as part of the Data Warehouse architecture.
==============================================================================
*/

CREATE DATABASE datawarehouse;


use datawarehouse;


drop table if exists bnz_crm_cust;
create table bnz_crm_cust(
cst_id int,
cst_key varchar(50),
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_material_status varchar(50),
cst_gndr varchar(50),
cst_create_date date
);


drop  table if exists bnz_crm_prd;
create table bnz_crm_prd(
prd_id int,
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line char(1),
prd_start_dt date, 
prd_end_dt date
);

drop table if exists bnz_crm_sales;
create table bnz_crm_sales(
sls_ord_num varchar(20),
sls_prd_key varchar(20), 
sls_cust_id int, 
sls_order_dt date, 
sls_ship_dt date, 
sls_due_dt date, 
sls_sales int, 
sls_quantity int, 
sls_price int
);

drop table if exists bnz_erp_cust;
create table bnz_erp_cust(
cid varchar(20),
bdate date, 
gen varchar(10)
);

drop table if exists bnz_erp_loc;
create table bnz_erp_loc(
cid varchar(10),
cntry varchar(20)
);

drop table if exists bnz_erp_px_cat;
create table bnz_erp_px_cat(
id varchar(10),
cat varchar(30), 
subcat varchar(50),
maintenance varchar(3)
);

-- -------------------------------------------------------------------------------------------	
