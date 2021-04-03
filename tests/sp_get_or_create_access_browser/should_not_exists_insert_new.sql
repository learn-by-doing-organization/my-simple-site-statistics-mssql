SET NOEXEC OFF
BEGIN TRANSACTION;  

DECLARE @user_agent_exists BIT = 0
DECLARE @user_agent NVARCHAR(MAX) = 'not existing user agents'

DECLARE @returnTable TABLE (user_agent_id BIGINT)
DECLARE @returnValue BIGINT = NULL

-- ARRANGE

-- Try to retrieve not exists user agent
SELECT TOP 1 @user_agent_exists = 1 FROM accesses_browsers WHERE user_agent_string LIKE @user_agent

-- SELECT 'user_agent_exists', @user_agent_exists
-- SELECT 'user_agent', @user_agent

-- ACT
IF @user_agent_exists = 0
BEGIN 
	INSERT INTO @returnTable
		EXEC sp_get_or_create_access_browser @user_agent

	SELECT TOP 1 @returnValue = user_agent_id FROM @returnTable
END

-- SELECT 'returnValue', @returnValue



-- ASSERT

IF @user_agent_exists = 1
BEGIN 
	ROLLBACK;
    raiserror('TEST FAIL: DATA EXISTS in table, return 1, expected 0', 11, 0)
    SET NOEXEC ON
END


IF @returnValue IS NULL OR @returnValue <= 0
BEGIN 
	DECLARE @returned VARCHAR(1000)
	SET @returned=CAST(@returnValue AS VARCHAR(1000))
	
	-- SELECT '@returned', @returned

	ROLLBACK;
    raiserror('TEST FAIL: return data incorrect, return %s ', 11, 0, @returned)
    SET NOEXEC ON
END

ROLLBACK;
PRINT 'TEST SUCCESS'


---------------- FOOTER OF Tese : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF