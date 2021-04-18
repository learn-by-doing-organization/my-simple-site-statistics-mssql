-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '009_create_sp_for_access_ip'

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
DECLARE @PrerequisiteMigrationName AS VARCHAR(1000) = '008_create_view_visits_users_website_day'
IF NOT EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @PrerequisiteMigrationName)
BEGIN 
    raiserror('YOU HAVE TO RUN SCRIPT %s ON THIS DB!!! STOP EXECUTION SCRIPT ', 11, 0, @PrerequisiteMigrationName)
    SET NOEXEC ON
END
-------------------- END SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem ---------------------------

DECLARE @sqlString AS VARCHAR(MAX)

SET @sqlString = 'CREATE OR ALTER PROCEDURE [dbo].[sp_get_or_create_access_ip]
	 @ip_address CHAR(128),
	 @host_name VARCHAR(255) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @findId INT = NULL

	-- HANDLE EMPTY STRING AND NULL VALUE
	IF(LTRIM(RTRIM(@host_name)) = '''') 
	BEGIN
		SET @host_name = NULL
	END

	-- retrieve id of ip and hostname, if it exists
	SELECT @findId = id FROM accesses_ips WHERE [value] = @ip_address AND COALESCE([host_name],'''') = COALESCE(@host_name,'''')

	-- if not exists, create it
	IF (@findId) IS NULL
	BEGIN
		-- INSERT NEW ENTRY
		INSERT INTO [accesses_ips]
				   ([value], [host_name])
			 VALUES
				   (@ip_address, @host_name)

		-- RETRIEVE LAST ID
		SELECT @findId = SCOPE_IDENTITY()
	END

	SELECT @findId
END  '
EXEC (@sqlString)
PRINT 'Stored procedure [sp_get_or_create_access_ip] created!'



---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF