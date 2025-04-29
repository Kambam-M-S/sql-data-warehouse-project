/*
Replacing Identifiers: 
PRD_KEY and CUST_ID in SLR_CRM_SALES are replaced with surrogate keys (product_key and customer_key) from dimensional tables.

Joining Dimension Tables: 
Links sales data (SLR_CRM_SALES) with customer (GLD_DIM_CUSTOMERS) and product (GLD_DIM_PRODUCTS) tables.

Renaming & Organizing Columns: 
Improves readability by using meaningful column names and grouping logically.

Creating a Fact Table (GLD_FACT_SALES):
Stores transactional sales data with references to dimension tables.

Quality Check for GLD_FACT_SALES: 
Ensures data consistency with SELECT * query.
-------------------------------------------------------------------------------------------
Data Integration Validation:

    Joins fact table (GLD_FACT_SALES) with customers and products.

    Identifies missing foreign key mappings using WHERE C.CUSTOMER_KEY IS NULL
-------------------------------------------------------------------------------------------
Check for NULL Keys in Joins If CUSTOMER_KEY or PRODUCT_KEY are NULL, ensure:

    Source tables (GLD_DIM_CUSTOMERS, GLD_DIM_PRODUCTS) have correct data.

    Join conditions are correctly matching.
----------------------------------------------------------------------------------------
Index CUSTOMER_ID, PRODUCT_NUMBER in dimension tables.

Ensure joins do not cause excessive scan operations.
*/


/*
-- PRD_KEY AND CUST_ID OF SALES TABLE ARE NOT NECESSARY THAT NEED TO BE REPLACED WITH SURROGATE KEY WE CREATED FOR CUSTOMER AND PRODUCT TABLE
-- JOIN CUSTOMER AND PRODUC TABLES FOR SURROGATE KEYS
-- RENAME THE COLUMNS FOR READABILITY
-- SORT THE COLUMNS INTO LOGICAL GROUPS TO IMPROVE READABILITY
-- CREATE VIEW FROM THE RESULTS
*/


SELECT * FROM SLR_CRM_SALES;
SELECT * FROM GLD_DIM_CUSTOMERS;
SELECT * FROM GLD_DIM_PRODUCTS;

CREATE VIEW GLD_FACT_SALES AS  
SELECT 
SLS_ORD_NUM AS order_number,
product_key ,
customer_key ,
SLS_ORDER_DT AS order_date ,
SLS_SHIP_DT AS shipping_date,
SLS_DUE_DT AS due_date,
SLS_SALES AS sales_amount,
SLS_QUANTITY AS quantity,
SLS_PRICE AS price
FROM SLR_CRM_SALES CS
LEFT JOIN GLD_DIM_CUSTOMERS GDM
ON CS.SLS_CUST_ID = GDM.CUSTOMER_ID
LEFT JOIN GLD_DIM_PRODUCTS GDP
ON CS.SLS_PRD_KEY = GDP.PRODUCT_NUMBER;

#=========================================================

-- CHECK QUALITY OF GOLD TABLE

SELECT * FROM GLD_FACT_SALES;

#===========================================================================

-- DATA INTEGRATION CHECK
-- FOREIGN KEY INTEGRATION

SELECT  * FROM GLD_FACT_SALES S
LEFT JOIN GLD_DIM_CUSTOMERS C
ON S.CUSTOMER_KEY = C.CUSTOMER_KEY
LEFT JOIN GLD_DIM_PRODUCTS P
ON S.PRODUCT_KEY = P.PRODUCT_KEY
WHERE C.CUSTOMER_KEY IS NULL;
