# Phone Rental Management using SQL

## Overview 
This project revamps a phone rental system database to improve efficiency, accuracy, and automation.

The phone rental company struggled with:
1. Messy data (duplicate & missing records)
2. Manually updating rental costs (leading to errors)
3. No easy way to track active, overdue, or completed rentals
4. Difficulty in generating revenue reports

This new system fixes these issues by implementing automated triggers, better table relationships, and pre-built SQL views for easy reporting.

## Features  
✔ **Prevent Duplicate Rentals** - A phone cannot be rented twice at the same time.  
✔ **IMEI Validation**  – Ensures only valid phone records exist.  
✔ **Views for Insights** - Includes reports on revenue, customer spending, utilization, and tracking of overdue rentals.  

## How to Set Up  
1️⃣ Clone this repo 
```bash
git clone https://github.com/yourusername/sql-driven-phone-rental-management.git
cd sql-driven-phone-rental-management
```

2️⃣ Set up the database
```bash
sqlite3 rental_system.db < sql_scripts/create_tables.sql
sqlite3 rental_system.db < sql_scripts/rental_cost_trigger.sql
sqlite3 rental_system.db < sql_scripts/customer_summary_view.sql
```

3️⃣ Run Queries & Reports
```bash
SELECT * FROM CustomerSummary;
SELECT * FROM ActiveRentals;
SELECT * FROM OverdueRentals;
SELECT * FROM MonthlyRevenue;
```

## Improvements
Currently, there is no trigger to notify customers when a rental is overdue. However, this can be implemented by sending an automated alert (if a notification system exists).
