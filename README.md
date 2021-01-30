# my-simple-site-statistics-mssql
A simple database project to record the access statistics of a website.  

([Italian translate](README_IT.md))  

This project is created for an educational purpose and does not pretend to be ready for production or to comply with privacy laws, please inquire well before using it.  

This repository is part of the project [*learn-by-doing*](https://github.com/Magicianred/learn-by-doing).  

## SQLSERVER-DB-SCRIPT-MIGRATION-SYSTEM

In this project we will use the [SimpleDbScriptMigrationSystem](https://github.com/Magicianred/SimpleDbScriptMigrationSystem).  

## Instructions

Create a new Database in Sql Server and:  

1. Run the script 000_InitialScript.sql (to create table for initialize the system)  
2. Run the script 000b_CreateUniqueCostraintForMigrationName.sql (to create unique constraint for field MigrationName)  
3. Run the script 001_Create_Tables.sql

