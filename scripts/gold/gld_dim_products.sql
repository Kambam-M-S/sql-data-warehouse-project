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

SELECT 
    *
FROM
    slr_erp_px_cat;
/*
-- Join tables
SELECT 
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt,
    cat,
    subcat,
    maintenance
FROM
    slr_crm_prd cp
        LEFT JOIN
    slr_erp_px_cat ep ON cp.cat_id = ep.id; 
    
-- Filter out all historical data from prd_end_dt EX: WHERE prd_end_dt IS NULL;

-- check for duplicates EX: select prd_key, count(*) from (select prd_id, cat_id, prd_key .......sub query) group by prd_key having count(*) > 1

-- Re arrange all the columns nice order

-- rename all the column

-- check table is dimensional or fact table

-- create a view 
*/

CREATE VIEW gld_dim_products AS 
SELECT 
	ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key) as product_key, -- this table is dimensional table so surrogate key is created
    prd_id as prdocut_id,
    prd_key as product_number,
    prd_nm as product_name,
    cat_id as category_id,
    cat as category,
    subcat as subcategory,
    maintenance,
    prd_cost as cost,
    prd_line as product_line,
    prd_start_dt as start_date
FROM
    slr_crm_prd cp
        LEFT JOIN
    slr_erp_px_cat ep ON cp.cat_id = ep.id
WHERE
    prd_end_dt IS NULL; -- Filter out all historical data, if null end_dt is there then that product is still active in production
    
