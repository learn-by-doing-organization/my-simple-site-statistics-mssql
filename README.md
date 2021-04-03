# my-simple-site-statistics-mssql
A simple database project to record the access statistics of a website.  

([Italian translate](README_IT.md))  

The [*project's idea*](https://github.com/Magicianred/accesses_statistics_system).  

This project is created for an educational purpose and does not pretend to be ready for production or to comply with privacy laws, please inquire well before using it.  

This repository is part of the project [*learn-by-doing*](https://github.com/Magicianred/learn-by-doing).  

## Instructions

Create a new Database in Sql Server and:  

1. Run the script *000_InitialScript.sql* (to create table for initialize the system)  
2. Run the script *000b_CreateUniqueCostraintForMigrationName.sql* (to create unique constraint for field MigrationName)  
3. Run the script *001_Create_Tables.sql* (to create tables for the system)
4. Run the script *002_DropAndCreate_Tables.sql* (drop some tables created and recreate them for added some auto increment field)
5. Run the script *003_Create_View_CompletePages.sql* (create a view for show pages complete data)

(For create dummy data)  

1. Run the script *dummy_data/000_InitialScript_For_DummyData.sql* (to create schema *test* and create some views for create test data)  
2. Run the script *dummy_data/001_Create_Random_Functions.sql* (to create a function for random data)  
3. Run the script *dummy_data/002_initial_dummy_data.sql* (to generate random data to valorize tables of system)


## References
### SQLSERVER-DB-SCRIPT-MIGRATION-SYSTEM

In this project we will use the [SimpleDbScriptMigrationSystem](https://github.com/Magicianred/SimpleDbScriptMigrationSystem).  

The [*project's idea*](https://github.com/Magicianred/accesses_statistics_system).  

This repository is part of the project [*learn-by-doing*](https://github.com/Magicianred/learn-by-doing).  

