-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '000b_CreateUniqueCostraintForMigrationName'

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
DECLARE @PrerequisiteMigrationName AS VARCHAR(1000) = '000b_CreateUniqueCostraintForMigrationName'
IF NOT EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @PrerequisiteMigrationName)
BEGIN 
    raiserror('YOU HAVET TO RUN SCRIPT %s ON THIS DB!!! STOP EXECUTION SCRIPT ', 11, 0, @PrerequisiteMigrationName)
    SET NOEXEC ON
END
-------------------- END SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem ---------------------------


IF EXISTS(SELECT * FROM   INFORMATION_SCHEMA.COLUMNS
        WHERE  TABLE_NAME = 'DbScriptMigration' AND COLUMN_NAME = 'MigrationName')
BEGIN
			  ALTER TABLE [dbo].[DbScriptMigration]   
			ALTER COLUMN [MigrationName] NVARCHAR(500) NOT NULL;   
			PRINT 'ALTER MigrationName Column'

			IF OBJECT_ID('dbo.[AK_MigrationName]', 'C') IS NOT NULL 
			BEGIN
			  ALTER TABLE [dbo].[DbScriptMigration]   
				ADD CONSTRAINT AK_MigrationName UNIQUE ([MigrationName]);   
				PRINT 'ADD UNIQUE CONSTRAINT AK_MigrationName'
			END
END



---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF