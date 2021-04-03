-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '003_Create_View_CompletePages'

IF EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @MigrationName)
BEGIN 
    raiserror('MIGRATION ALREADY RUNNED ON THIS DB!!! STOP EXECUTION SCRIPT', 11, 0)
    SET NOEXEC ON
END

INSERT INTO [DbScriptMigration]
    (MigrationId, MigrationName, MigrationDate)
    VALUES
    (NEWID(), @MigrationName, GETDATE())
GO
PRINT 'Insert record into [DbScriptMigration]!'
-------------------- END SCRIPT TO CHECK OF DbScriptMigrationSystem ---------------------------


-------------------- SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem -------------------------------
DECLARE @PrerequisiteMigrationName AS VARCHAR(1000) = '002_DropAndCreate_Tables'
IF NOT EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @PrerequisiteMigrationName)
BEGIN 
    raiserror('YOU HAVE TO RUN SCRIPT %s ON THIS DB!!! STOP EXECUTION SCRIPT ', 11, 0, @PrerequisiteMigrationName)
    SET NOEXEC ON
END
-------------------- END SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem ---------------------------

DECLARE @sqlString AS VARCHAR(MAX)

SET @sqlString = 'CREATE OR ALTER VIEW vw_complete_pages
AS
SELECT sites.id AS web_site_id, sites.[address] as web_site, CONCAT([address], uri) AS complete_address, pages.id AS page_id, pages.uri
  FROM [accesses_pages] pages
	INNER JOIN websites sites ON pages.website_id = sites.id '
EXEC (@sqlString)
PRINT 'View [vw_complete_pages] created!'



---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF