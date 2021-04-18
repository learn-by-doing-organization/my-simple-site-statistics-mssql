-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '011_create_sp_for_visites'

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
DECLARE @PrerequisiteMigrationName AS VARCHAR(1000) = '010_create_sp_for_page'
IF NOT EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @PrerequisiteMigrationName)
BEGIN 
    raiserror('YOU HAVE TO RUN SCRIPT %s ON THIS DB!!! STOP EXECUTION SCRIPT ', 11, 0, @PrerequisiteMigrationName)
    SET NOEXEC ON
END
-------------------- END SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem ---------------------------

DECLARE @sqlString AS VARCHAR(MAX)

SET @sqlString = 'CREATE OR ALTER PROCEDURE [dbo].[sp_get_or_create_access_visit]
	@uri VARCHAR(500),
	@uri_referer VARCHAR(500),
	@user_agent NVARCHAR(MAX),
	@user_id BIGINT,
	@website_id BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @returnTable TABLE (item_id BIGINT)

	DECLARE @pageId INT = NULL
	DECLARE @refererPageId INT = NULL
	DECLARE @browserId INT = NULL
	
	-- get or insert page
	INSERT INTO @returnTable
		EXEC sp_get_or_create_access_page @uri, @website_id
	SELECT TOP 1 @pageId = item_id FROM @returnTable
	DELETE FROM @returnTable
	
	-- get or insert referer page
	INSERT INTO @returnTable
		EXEC sp_get_or_create_access_page @uri_referer, @website_id
	SELECT TOP 1 @refererPageId = item_id FROM @returnTable
	DELETE FROM @returnTable
	
	-- get or insert browser
	INSERT INTO @returnTable
		EXEC sp_get_or_create_access_browser @user_agent
	SELECT TOP 1 @browserId = item_id FROM @returnTable
	DELETE FROM @returnTable
	

	-- INSERT NEW ENTRY
	INSERT INTO [accesses_visits]
				([date], [page_id], [page_reference_id], [browser_id], [user_id])
			VALUES
				(GETDATE(), @pageId, @refererPageId, @browserId, @user_id)

	-- RETRIEVE LAST ID
	SELECT SCOPE_IDENTITY()
END  '
EXEC (@sqlString)
PRINT 'Stored procedure [sp_get_or_create_access_visit] created!'



---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF