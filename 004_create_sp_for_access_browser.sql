-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '004_create_sp_for_access_browser'

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

SET @sqlString = 'CREATE OR ALTER PROCEDURE sp_get_or_create_access_browser
	@user_agent NVARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @findId INT = NULL

	-- retrieve id of user agent, if it exists
	SELECT @findId = id FROM accesses_browsers WHERE user_agent_string LIKE @user_agent

	-- if not exists, create it
	IF (@findId) IS NULL
	BEGIN
		-- INSERT NEW ENTRY
		INSERT INTO [accesses_browsers]
				   ([user_agent_string])
			 VALUES
				   (@user_agent)

		-- RETRIEVE LAST ID
		SELECT @findId = SCOPE_IDENTITY()
	END

	SELECT @findId
END '
EXEC (@sqlString)
PRINT 'Stored procedure [sp_get_or_create_access_browser] created!'



---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF