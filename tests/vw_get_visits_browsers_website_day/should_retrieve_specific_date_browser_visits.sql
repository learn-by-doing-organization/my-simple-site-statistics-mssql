SET NOEXEC OFF
BEGIN TRANSACTION;  

DECLARE @randomDate DATE = NULL
DECLARE @randomBrowser BIGINT = 0
DECLARE @randomWebSite INT = 0

DECLARE @returnTable TABLE (
        [visit_date] DATE,
        [visit_browser] BIGINT,
        [visit_website] INT,
        [num_visits] BIGINT
    )
DECLARE @returnValue BIGINT = NULL
DECLARE @expectedNumVisit BIGINT = NULL

-- ARRANGE

-- Retrieve a random website id
SELECT TOP 1 @randomWebSite = id FROM websites ORDER BY NEWID()

-- Retrieve a random browser id
SELECT TOP 1 @randomBrowser = id FROM accesses_browsers ORDER BY NEWID()

-- Retrieve an existing visit date
SELECT TOP 1 @randomDate = [date]
    FROM accesses_visits visits 
    INNER JOIN accesses_browsers browsers ON visits.browser_id = browsers.id 
    WHERE browsers.id = @randomBrowser
    ORDER BY NEWID()

-- Retrieve num visit for random page and date
SELECT @expectedNumVisit = COUNT(visits.id)
    FROM accesses_visits visits 
    INNER JOIN accesses_browsers browsers ON visits.browser_id = browsers.id 
    WHERE browsers.id = @randomBrowser
		AND CAST(visits.[date] AS DATE) = @randomDate

--SELECT 'randomWebSite', @randomWebSite
--SELECT 'randomBrowser', @randomBrowser
--SELECT 'randomDate', @randomDate
--SELECT 'expectedNumVisit', @expectedNumVisit

-- ACT
INSERT INTO @returnTable ([visit_date],[visit_browser],[visit_website],[num_visits])
SELECT [visit_date],[visit_browser],[visit_website],[num_visits]
    FROM vw_visits_browsers_website_day
    WHERE visit_browser = @randomBrowser
        AND visit_date = @randomDate

SELECT @returnValue = SUM(num_visits) FROM @returnTable


--SELECT 'returnValue', @returnValue


-- ASSERT

IF @randomDate IS NULL OR @randomWebSite IS NULL OR @randomBrowser IS NULL OR @expectedNumVisit IS NULL OR @expectedNumVisit = 0
BEGIN 
	ROLLBACK;
    raiserror('TEST FAIL: NO DATA EXISTS in table or other problem with test data', 11, 0)
    SET NOEXEC ON
END


IF @returnValue <> @expectedNumVisit
BEGIN 

	DECLARE @expected VARCHAR(1000)
	SET @expected=CAST(@expectedNumVisit AS VARCHAR(1000))
	
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