SET NOEXEC OFF
BEGIN TRANSACTION;  

DECLARE @ip_exists BIT = 0
DECLARE @ip_id BIGINT = NULL
DECLARE @ip_address CHAR(128)
DECLARE @host_name VARCHAR(255)

DECLARE @returnTable TABLE (ip_id BIGINT)
DECLARE @returnValue BIGINT = NULL

-- ARRANGE

-- Retrieve an existing ip and hostname
SELECT TOP 1 @ip_exists = 1, @ip_id = id, @ip_address = [value], @host_name = [host_name] FROM accesses_ips ORDER BY NEWID()

 --SELECT '@ip_exists', @ip_exists
 --SELECT '@ip_id', @ip_id
 --SELECT '@ip_address', @ip_address
 --SELECT '@host_name', @host_name

-- ACT
IF @ip_exists = 1
BEGIN 
	INSERT INTO @returnTable
		EXEC sp_get_or_create_access_ip @ip_address, @host_name

	SELECT TOP 1 @returnValue = ip_id FROM @returnTable
END

 --SELECT 'returnValue', @returnValue


---- ASSERT

IF @ip_exists = 0
BEGIN 
	ROLLBACK;
    raiserror('TEST FAIL: NO DATA EXISTS in table', 11, 0)
    SET NOEXEC ON
END


IF @returnValue <> @ip_id
BEGIN 

	DECLARE @expected VARCHAR(1000)
	SET @expected=CAST(@ip_id AS VARCHAR(1000))
	
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