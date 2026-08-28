# 🗄️ Monthly Render Database Reset & Restore Guide

This guide explains how to recreate, restore, and reconfigure your Render PostgreSQL database each month.

---

## 1. Create a New Database on Render

1. Open your Render dashboard  
2. Create a new PostgreSQL instance  
3. Copy the External Database URL

Example:

postgresql://app_db_qslm_user:767v2eMlfArfPr7zNfB01yQ6T5FCb@dpg-da8np9id5s73979ang-a.frankfurt-postgres.render.com/app_db_qsmm

---

## 2. Update psql_conn.env

Create or edit the file:

psql_conn.env

Insert exactly:

psql_conn="postgresql://app_db_qslm_user:767v2eMlfArfPr7zNfB01yQ6T5FCb@dpg-da8np9id5s73979ang-a.frankfurt-postgres.render.com/app_db_qsmm"

Rules:

- No extra spaces  
- No comments  
- No additional lines  
- Must be the external URL  

---

## 3. Restore the Database

Run:

.\restore_psql.ps1

This script:

- Reads psql_conn.env
- Connects to the new Render database
- Restores the backup from:

.\sql\backup.sql

---

## 4. Generate API Credentials

Run:

.\generate-db-cred.ps1

This script creates:

db_cred_env.txt

Containing:

database = <dbname>
port = 5432
username = <user>
password = <password>
DATABASE_URL=jdbc:postgresql://<host>:5432/<dbname>

---

## 5. Update API Settings

Open your API configuration and copy the values from:

db_cred_env.txt

This updates your backend to use the newly restored database.

---

## 6. Test the Frontend

Start your API and frontend, then verify the application works correctly.

---

## ✔️ Summary Checklist

- Create new DB on Render  
- Copy external DB URL  
- Update psql_conn.env  
- Run restore_psql.ps1  
- Run generate-db-cred.ps1  
- Update API settings  
- Test frontend  
