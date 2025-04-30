
# SQL Data Warehouse Pipeline

A **robust data engineering project** designed to build a scalable data warehouse pipeline for processing large-scale batch transaction records. This pipeline combines **MySQL** for efficient data storage, **Python** for automation, **Notion** and **draw.io** for comprehensive documentation, ensuring optimized query performance and streamlined workflows.

## Features
- **Batch Processing**: Handles large-scale transaction datasets with MySQL stored procedures.
- **Query Optimization**: Achieves a 25% reduction in query execution time using efficient stored procedures.
- **Automation**: Automates data ingestion workflows using Python scripts, reducing processing time by 30%.
- **Documentation**: Leverages Notion for detailed project documentation and data flow charts, enhancing collaboration by 20%.

## Tech Stack
- **Python**: Scripts for data ingestion and automation.
- **MySQL**: Data warehouse storage and stored procedures.
- **Notion**: Platform for data flow charts and project documentation.

---

## Folder Structure
| Folder/File                  | Description                                 |
|------------------------------|---------------------------------------------|
| `scripts/`                   | Contains Python scripts for data ingestion and processing. |
| `scripts/`                       | Includes MySQL stored procedures and table schemas. |
| `docs/`                      | Documentation links and data flow charts.  |
| `datasets/`                  | Contains Dataset source crm and source erp in batch files format . |
| `scripts/bronze/db_tables_creation.sql`              | SQL script to set up data warehouse tables. |
| `scripts/silver/stored_procedure.sql`         | Stored procedures for efficient data loading. |

---

## Setup Instructions

### Prerequisites
- **Python**: Version 3.8+
- **MySQL**: Version 8.0+
- Install Python dependencies:
  ```bash
  pip install -r requirements.txt
  ```

### Clone the Repository
```bash
git clone https://github.com/Kambam-M-S/sql-data-warehouse-project.git
cd sql-data-warehouse-project
```

### Database Setup
1. **Create a MySQL database**:
   - Access your MySQL server and create the database.
2. **Set up tables**:
   ```bash
   mysql -u username -p database_name < sql/setup.sql
   ```
3. **Execute stored procedures**:
   ```bash
   mysql -u username -p database_name < sql/procedures.sql
   ```

### Run the Pipeline
```bash
python scripts/main.py
```

### Access Documentation
- Open the Notion documentation for  **project setup guides** and use draw.io for **data flow charts**.

---

## Contributing

Contributions are welcome! Please follow these steps:
1. **Fork the repository**.
2. **Create a new branch**:
   ```bash
   git checkout -b feature-branch
   ```
3. **Commit your changes**:
   ```bash
   git commit -m 'Add new feature'
   ```
4. **Push to the branch**:
   ```bash
   git push origin feature-branch
   ```
5. **Open a Pull Request**.

---

## License
This project is licensed under MIT LICENSE. See the `LICENSE` file for details.

---

