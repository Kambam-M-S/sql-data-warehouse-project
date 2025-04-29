/*
Database Selection: 
USE datawarehouse; ensures the view is created in the right database.

View Creation: 
CREATE VIEW gld_dim_customers AS defines a virtual table. Views do not store data, they pull live results from the source tables.

Row Numbering: 
Uses ROW_NUMBER() to generate unique customer_key. Requires MySQL 8.0 or later.

Data Selection & Transformation: 
Extracts customer details (customer_id, name, country, etc.) and applies a gender fallback using CASE.

Joins: 
Uses LEFT JOIN to ensure slr_crm_cust remains the base, even if related tables (slr_erp_loc, slr_erp_cust) lack matching entries.
*/

use datawarehouse;

CREATE VIEW  gld_dim_customers as 
SELECT 
	row_number() over (order by cst_id) as customer_key,
    cst_id as customer_id,
    cst_key as customer_number,
    cst_firstname as first_name,
    cst_lastname as last_name,
    cntry as country,
    cst_marital_status as marital_status,
    CASE
        WHEN cc.cst_gndr != 'n/a' THEN cst_gndr
        ELSE COALESCE(ec.gen, 'n/a')
    END AS gender,
    bdate as birthdate,
    cst_create_date as create_date
    
FROM
    slr_crm_cust cc
        LEFT JOIN
    slr_erp_loc el ON cc.cst_key = el.cid
        LEFT JOIN
    slr_erp_cust ec ON cc.cst_key = ec.cid;
    
     -- Note: If any error raise because of views use :- `SHOW FULL TABLES IN datawarehouse WHERE table_type = 'VIEW';`
