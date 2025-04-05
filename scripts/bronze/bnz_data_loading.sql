/*
===============================================================================================================================
Stored Procedure: Load_Bronze_Data
===============================================================================================================================
Purpose:
  This stored procedure is designed to load data into the 'datawarehouse' database from external CSV files. It automates 
  the process of data loading and ensures the following tasks:
  - Clears data from existing bronze tables [bronze_(tables)] using TRUNCATE command.
  - Utilizes the 'Bulk Insert' command to efficiently transfer data from CSV files into the bronze layer tables.
Parameters:
  None.
  This procedure does not accept any input parameters or return any values.

Usage:
  To execute the stored procedure:
  CALL Load_Bronze_Data();

Additional Notes:
1) Data without missing values and meeting completeness quality standards:
   Use this method to bulk insert data directly into the bronze tables.
2) Data with missing values and not satisfying completeness quality standards:
   Use the provided Python script to clean and prepare data before loading into the bronze tables.

Execution Options:
  - Use the stored procedure to load all data in bulk for streamlined ETL processing.
  - Alternatively, load specific table data by selecting only the desired subsets.
===============================================================================================================================
*/

  
CALL LOAD_BRONZE();#IF NEED TO CALL PROCEDURE WITH PARAMETERS "LOAD_BRONZE(VAR1,VAR2,@OUTPUT) --> SELECT @OUTPUT" 

DELIMITER //
CREATE PROCEDURE LOAD_BRONZE AS () # IF ATTRIBUTES ARE THE USE (IN VAR1 DATATYPE, IN VAR2 DATATYPE, IN VARN DATAYPE, OUT VAR DATAYPE)
BEGIN
	DECLARE @batch_start_time Datetime, @batch_end_time Datetime, @TOTAL_TIME INT
    SET @batch_strat_time = NOW()
	-- FOR ENTERING TABLE DATA OF BNZ_CRM_CUST ---------------------
	TRUNCATE TABLE bnz_crm_cust;
	LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/cust_info.csv'
	INTO TABLE bnz_crm_cust
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

	-- FOR ENTERING TABLE DATA OF BNZ_CRM_PRD ---------------------
	TRUNCATE TABLE bnz_crm_prd;
	LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/prd_info.csv'
	INTO TABLE bnz_crm_prd
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

	-- FOR ENTERING TABLE DATA OF BNZ_CRM_SALES ---------------------
	TRUNCATE TABLE bnz_crm_sales;
	LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_crm/sales_details.csv'
	INTO TABLE bnz_crm_sales
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

	-- FOR ENTERING TABLE DATA OF BNZ_ERP_CUST ---------------------
	TRUNCATE TABLE bnz_erp_cust;
	LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/cust_az12.csv'
	INTO TABLE bnz_erp_cust
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

	-- FOR ENTERING TABLE DATA OF BNZ_ERP_LOC ---------------------
	TRUNCATE TABLE bnz_erp_loc;
	LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/erp_loc_a101.csv'
	INTO TABLE bnz_erp_loc
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

	-- FOR ENTERING TABLE DATA OF BNZ_ERP_PX_CAT---------------------
	TRUNCATE TABLE bnz_erp_px_cat;
	LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/source_erp/px_cat_g1v2.csv'
	INTO TABLE bnz_erp_px_cat
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
	
    SET @batch_end_time = NOW()
    SET @total_time = DATEDIFF(SECONDS, @batch_start_time,@batch_end_time)
END;

DELIMITER ;

-- ---------------------------------------------------------------------------------------------------------------------------

/*

IN DATA QUALITY, COMPLETENESS IS MISSING USE PYTHON FOR EASY DATA LOADING  INTO TABLES


import pandas as pd
from sqlalchemy import create_engine


source = ['source_crm/cust_info.csv','source_crm/prd_info.csv','source_crm/sales_details.csv',
          'source_erp/cust_az12.csv','source_erp/loc_a101.csv','source_erp/px_cat_g1v2.csv']
tables = ['bnz_crm_cust','bnz_crm_prd','bnz_crm_sales',
        'bnz_erp_cust','bnz_erp_loc','bnz_erp_px_cat']


user = 'USERNAME'
password = 'PASSWORD'
host = 'localhost'
port = 3306
db = 'datawarehouse'
engine = create_engine(f'mysql+pymysql://{user}:{password}@{host}:{port}/{db}')

try:
    for src, table in zip(source,tables):
        df=pd.read_csv(src,header=0)
        
        df.to_sql(table,con=engine,if_exists='replace',index=False)
        print(f"Data from {src} Inserted successfully into the '{table}' table.")
except Exception as e:
    print("Error occured during data loading:",e) 

*/
