-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '008_create_view_visits_users_website_day'

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
DECLARE @PrerequisiteMigrationName AS VARCHAR(1000) = '007_create_view_visits_browsers_website_day'
IF NOT EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @PrerequisiteMigrationName)
BEGIN 
    raiserror('YOU HAVE TO RUN SCRIPT %s ON THIS DB!!! STOP EXECUTION SCRIPT ', 11, 0, @PrerequisiteMigrationName)
    SET NOEXEC ON
END
-------------------- END SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem ---------------------------

DECLARE @sqlString AS VARCHAR(MAX)

SET @sqlString = 'CREATE OR ALTER VIEW vw_visits_users_website_day
AS
SELECT CAST([date] AS DATE) AS visit_date, users.id AS visit_user, pages.website_id AS visit_website, COUNT(CAST([date] AS DATE)) AS num_visits
  FROM [accesses_visits] AS visits
	INNER JOIN [users] AS users ON visits.user_id = users.id
	INNER JOIN [accesses_pages] AS pages ON visits.page_id = pages.id
	GROUP BY CAST(visits.[date] AS DATE), users.id, pages.website_id '
EXEC (@sqlString)
PRINT 'View [vw_visits_users_website_day] created!'



---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF