-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '001_Create_Random_Functions'

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
DECLARE @PrerequisiteMigrationName AS VARCHAR(1000) = '000_InitialScript_For_DummyData'
IF NOT EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @PrerequisiteMigrationName)
BEGIN 
    raiserror('YOU HAVE TO RUN SCRIPT %s ON THIS DB!!! STOP EXECUTION SCRIPT ', 11, 0, @PrerequisiteMigrationName)
    SET NOEXEC ON
END
-------------------- END SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem ---------------------------

DECLARE @sqlString AS VARCHAR(MAX)


SET @sqlString = 'CREATE OR ALTER FUNCTION test.random_ips()
RETURNS CHAR(128) AS
BEGIN
	RETURN CONCAT(
	  CAST((SELECT Value FROM test.vw_getRANDValue) * 250 + 2 as INT) , ''.'',
	  CAST((SELECT Value FROM test.vw_getRANDValue) * 250 + 2 as INT),  ''.'',
	  CAST((SELECT Value FROM test.vw_getRANDValue) * 250 + 2 as INT), ''.'',
	  CAST((SELECT Value FROM test.vw_getRANDValue) * 250 + 2 as INT)
	)
END '
EXEC (@sqlString)
PRINT 'Function [test.random_ips] created!'


---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF