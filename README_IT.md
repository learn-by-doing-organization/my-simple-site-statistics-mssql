# my-simple-site-statistics-mssql
Un semplice progetto database per registrare le statistiche di accesso di un sito web.  

([English translate](Readme.md))  

L'[*idea del progetto*](https://github.com/Magicianred/accesses_statistics_system).  

Questo progetto è creato per uno scopo didattico e non ha pretese di essere pronto per la produzione o di essere conforme alle leggi in materia di privacy, informarsi bene prima di utilizzarlo.  

Questo repository fa parte di un progetto [*learn-by-doing*](https://github.com/Magicianred/learn-by-doing/blob/main/README_IT.md).  

## Istruzioni

Crea un nuovo database in Sql Server e:  

1. Esegui lo script 000_InitialScript.sql (per creare le tabelle che inizializzano il sistema di migrazione)  
2. Esegui lo script 000b_CreateUniqueCostraintForMigrationName.sql (per creare le unique costraint per il database)  
3. Esegui lo script 001_Create_Tables.sql (per creare le tabelle per il sistema di statistiche)


## Riferimenti
### SQLSERVER-DB-SCRIPT-MIGRATION-SYSTEM

In questo progetto useremo [SimpleDbScriptMigrationSystem](https://github.com/Magicianred/SimpleDbScriptMigrationSystem).  

L'[*idea del progetto*](https://github.com/Magicianred/accesses_statistics_system).  

Questo repository fa parte di un progetto [*learn-by-doing*](https://github.com/Magicianred/learn-by-doing/blob/main/README_IT.md).  