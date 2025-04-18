/*
This SQL script cleans, restructures, and loads data into the slr_crm_prd table in the data warehouse. 
It performs the following tasks:

Table Recreation:
- Drops the existing table and recreates it with updated columns like cat_id and prd_end_dt.

Data Transformation:
- Cleans and formats data (e.g., trimming spaces, replacing null values).
- Adds a new cat_id column derived from prd_key.
- Standardizes prd_line values to readable descriptions (e.g., 'R' becomes 'Road').

Dynamic Date Calculation:
- Uses the LEAD() function to calculate the prd_end_dt based on prd_start_dt.

Data Loading:
- Inserts transformed data from the bnz_crm_prd table into the slr_crm_prd table.

Verification:
- Includes a query to display all records from the slr_crm_prd table for review.

*/

-- -----------------------------------------------------------------------------------------------


use datawarehouse;

/*
Some time when cleaning, new columns we create in silver layer 
for that table, table structure need to be modified or table can be droped and re-create once again 
*/

drop table slr_crm_prd;
create table slr_crm_prd(
prd_id int,
cat_id varchar(50),
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line varchar(50),
prd_start_dt date,
prd_end_dt date,
dwh_create_date datetime default now()
);

/*
Insert outcome of select statement into slr_crm_prd table
error indication mark will be shown at prd_end_dt ignore it and run query
*/

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

select * from slr_crm_prd;
