SET NOEXEC OFF
BEGIN TRANSACTION;  

DECLARE @ip_exists BIT = 0
DECLARE @ip_id BIGINT = NULL
DECLARE @ip_address CHAR(128) = [test].[random_ips]()
DECLARE @host_name VARCHAR(255)

DECLARE @returnTable TABLE (ip_id BIGINT)
DECLARE @returnValue BIGINT = NULL

-- ARRANGE

-- Retrieve an existing ip and hostname
SELECT TOP 1 @ip_exists = 1, @ip_id = id, @ip_address = [value], @host_name = [host_name] FROM accesses_ips WHERE [value] = @ip_address AND [host_name] = @host_name

 --SELECT '@ip_exists', @ip_exists
 --SELECT '@ip_id', @ip_id
 --SELECT '@ip_address', @ip_address
 --SELECT '@host_name', @host_name

-- ACT
IF @ip_exists = 0
BEGIN 
	INSERT INTO @returnTable
		EXEC sp_get_or_create_access_ip @ip_address, @host_name

	SELECT TOP 1 @returnValue = ip_id FROM @returnTable
END

 --SELECT 'returnValue', @returnValue



-- ASSERT

IF @ip_exists = 1
BEGIN 
	ROLLBACK;
    raiserror('TEST FAIL: DATA EXISTS in table, return 1, expected 0', 11, 0)
    SET NOEXEC ON
END


IF @returnValue <> @ip_id
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