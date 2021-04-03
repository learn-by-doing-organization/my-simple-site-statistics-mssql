SET NOEXEC OFF
BEGIN TRANSACTION;  

DECLARE @user_agent_exists BIT = 0
DECLARE @user_agent_id BIGINT = NULL
DECLARE @user_agent NVARCHAR(MAX)

DECLARE @returnTable TABLE (user_agent_id BIGINT)
DECLARE @returnValue BIGINT = NULL

-- ARRANGE

-- Retrieve an existing user agent
SELECT TOP 1 @user_agent_exists = 1, @user_agent_id = id, @user_agent = user_agent_string FROM accesses_browsers ORDER BY NEWID()

-- SELECT 'user_agent_exists', @user_agent_exists
-- SELECT 'user_agent_id', @user_agent_id
-- SELECT 'user_agent', @user_agent

-- ACT
IF @user_agent_exists = 1
BEGIN 
	INSERT INTO @returnTable
		EXEC sp_get_or_create_access_browser @user_agent

	SELECT TOP 1 @returnValue = user_agent_id FROM @returnTable
END

-- SELECT 'returnValue', @returnValue


-- ASSERT

IF @user_agent_exists = 0
BEGIN 
	ROLLBACK;
    raiserror('TEST FAIL: NO DATA EXISTS in table', 11, 0)
    SET NOEXEC ON
END


IF @returnValue <> @user_agent_id
BEGIN 

	DECLARE @expected VARCHAR(1000)
	SET @expected=CAST(@user_agent_id AS VARCHAR(1000))
	
	DECLARE @returned VARCHAR(1000)
	SET @returned=CAST(@returnValue AS VARCHAR(1000))
	
	-- SELECT '@expected', @expected
	-- SELECT '@returned', @returned

	ROLLBACK;
    raiserror('TEST FAIL: return data incorrect, expect %s, return %s ', 11, 0, @expected, @returned)
    SET NOEXEC ON
END

ROLLBACK;
PRINT 'TEST SUCCESS'



---------------- FOOTER OF Tese : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF