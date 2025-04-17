/*
This SQL script inserts filtered and formatted customer data into the slr_crm_cust table. Here's a breakdown of its key features:

Data Extraction from bnz_crm_cust:
Retrieves customer information like cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, and cst_gndr, alongside cst_create_date.
Uses ROW_NUMBER() with PARTITION BY on cst_id to ensure only the most recent record (based on cst_create_date) for each customer is selected (FLAG_LAST = 1).

Data Cleaning:
Applies TRIM() to remove any extra spaces from cst_firstname and cst_lastname.
Converts marital status (cst_marital_status) and gender (cst_gndr) to standardized values using CASE statements:
For marital status: Maps 'M' to 'Married', 'S' to 'Single', and assigns 'n/a' to any other value.
For gender: Maps 'M' to 'Male', 'F' to 'Female', and assigns 'n/a' for unspecified values.

Insert into slr_crm_cust:
Populates the target table slr_crm_cust with the cleaned and formatted data.

*/

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

