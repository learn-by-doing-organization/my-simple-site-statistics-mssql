SET NOEXEC OFF
BEGIN TRANSACTION;  

DECLARE @randomDate DATE = NULL
DECLARE @randomWebSite INT = 0

DECLARE @returnTable TABLE (
        [visit_date] DATE,
        [visit_website] INT,
        [num_visits] BIGINT
    )
DECLARE @returnValue BIGINT = NULL
DECLARE @expectedNumVisit BIGINT = NULL

-- ARRANGE

-- Retrieve a random website id
SELECT TOP 1 @randomWebSite = id FROM websites ORDER BY NEWID()

-- Retrieve an existing visit date
SELECT TOP 1 @randomDate = [date]
    FROM accesses_visits visits 
    INNER JOIN accesses_pages pages ON visits.page_id = pages.id 
    WHERE pages.website_id = @randomWebSite 
    ORDER BY NEWID()

-- Retrieve num visit for random website and date
SELECT @expectedNumVisit = COUNT(visits.id)
    FROM accesses_visits visits 
    INNER JOIN accesses_pages pages ON visits.page_id = pages.id 
    WHERE pages.website_id = @randomWebSite
		AND CAST(visits.[date] AS DATE) = @randomDate

--SELECT 'randomWebSite', @randomWebSite
--SELECT 'randomDate', @randomDate
--SELECT 'expectedNumVisit', @expectedNumVisit

-- ACT
INSERT INTO @returnTable ([visit_date],[visit_website],[num_visits])
SELECT [visit_date],[visit_website],[num_visits]
    FROM vw_visits_website_day
    WHERE visit_website = @randomWebSite
        AND visit_date = @randomDate

SELECT TOP 1 @returnValue = num_visits FROM @returnTable


--SELECT 'returnValue', @returnValue


-- ASSERT

IF @randomDate IS NULL OR @randomWebSite IS NULL OR @expectedNumVisit IS NULL OR @expectedNumVisit = 0
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