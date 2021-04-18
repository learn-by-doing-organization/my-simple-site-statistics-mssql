SET NOEXEC OFF
BEGIN TRANSACTION;  

DECLARE @page_exists BIT = 0
DECLARE @page_id BIGINT = NULL
DECLARE @page_uri VARCHAR(500)
DECLARE @website_id BIGINT

DECLARE @returnTable TABLE (page_id BIGINT)
DECLARE @returnValue BIGINT = NULL

-- ARRANGE

-- Retrieve an existing page uri and website id
SELECT TOP 1 @page_exists = 1, @page_id = id, @page_uri = [uri], @website_id = [website_id] FROM accesses_pages ORDER BY NEWID()

 --SELECT '@page_exists', @page_exists
 --SELECT '@page_id', @page_id
 --SELECT '@page_uri', @page_uri
 --SELECT '@website_id', @website_id

-- ACT
IF @page_exists = 1
BEGIN 
	INSERT INTO @returnTable
		EXEC sp_get_or_create_access_page @page_uri, @website_id

	SELECT TOP 1 @returnValue = page_id FROM @returnTable
END

--SELECT 'returnValue', @returnValue


---- ASSERT

IF @page_exists = 0
BEGIN 
	ROLLBACK;
    raiserror('TEST FAIL: NO DATA EXISTS in table', 11, 0)
    SET NOEXEC ON
END


IF @returnValue <> @page_id
BEGIN 

	DECLARE @expected VARCHAR(1000)
	SET @expected=CAST(@page_id AS VARCHAR(1000))
	
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