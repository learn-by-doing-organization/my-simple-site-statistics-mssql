-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '000_InitialScript_For_DummyData'

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

DECLARE @sqlString AS VARCHAR(MAX)

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'test')
BEGIN
    SET @sqlString = 'CREATE SCHEMA test '
    EXEC (@sqlString)
    PRINT 'Schema [test] created!'
END
ELSE
BEGIN
    PRINT 'Schema [test] exists!'
END

-- https://stackoverflow.com/questions/31468836/use-rand-in-user-defined-function
SET @sqlString = 'CREATE VIEW test.vw_getRANDValue
AS
SELECT RAND() AS Value '
EXEC (@sqlString)
PRINT 'View [test.vw_getRANDValue] created!'

SET @sqlString = 'CREATE VIEW test.vw_getNEWID
AS
SELECT NEWID() AS Value '
EXEC (@sqlString)
PRINT 'View [test.vw_getNEWID] created!'


-- https://stackoverflow.com/questions/50018103/how-to-get-random-datetime-of-specific-date
SET @sqlString = 'CREATE VIEW test.vw_getRandomDate
AS
SELECT (DATEADD(day, ROUND(DATEDIFF(day, ''2018-01-01 00:00:00'', ''2021-04-01 23:59:59'') 
        * RAND(CHECKSUM(NEWID())), 5),DATEADD(second, abs(CHECKSUM(NEWID())) % 86400, 
        ''2018-01-01 00:00:00'')))  AS Value '
EXEC (@sqlString)
PRINT 'View [test.vw_getRandomDate] created!'

---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF