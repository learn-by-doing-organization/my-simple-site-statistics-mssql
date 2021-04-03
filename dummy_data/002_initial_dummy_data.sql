-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '002_initial_dummy_data'

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
DECLARE @PrerequisiteMigrationName AS VARCHAR(1000) = '001_Create_Random_Functions'
IF NOT EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @PrerequisiteMigrationName)
BEGIN 
    raiserror('YOU HAVE TO RUN SCRIPT %s ON THIS DB!!! STOP EXECUTION SCRIPT ', 11, 0, @PrerequisiteMigrationName)
    SET NOEXEC ON
END
-------------------- END SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem ---------------------------

-- INSERT SOME TEST USERS
INSERT INTO [dbo].[users]
           ([id]
           ,[username]
           ,[email]
           ,[created_date]
           ,[last_access_date])
     VALUES
           (1
           ,'testuser'
           ,'testuser@exampleemail.it'
           ,GETDATE()
           ,NULL),
           (2
           ,'testuser2'
           ,'testuser2@exampleemail.it'
           ,GETDATE()
           ,NULL),
           (3
           ,'testuser3'
           ,'testuser3@exampleemail.it'
           ,GETDATE()
           ,NULL)

-- INSERT SOME TEST WEB SITES
INSERT INTO [dbo].[websites]
           ([id]
           ,[name]
           ,[address])
     VALUES
           (1
           ,'my-web-site'
           ,'www.my-web-site.net'),
           (2
           ,'my-blog'
           ,'www.my-blog.net')

-- INSERT SOME BROWSER USER AGENT STRINGS
INSERT INTO [dbo].[accesses_browsers]
           ([user_agent_string])
     VALUES
           ('Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; Acoo Browser 1.98.744; .NET CLR 3.5.30729)'),
           ('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Avant Browser; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 2.0.50727)'),
           ('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_4) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.65 Safari/535.11'),
           ('Lynx/2.8.6rel.5 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/0.9.8b'),
           ('NCSA Mosaic/3.0 (Windows 95)'),
           ('Opera/9.80 (X11; Linux i686; Ubuntu/14.10) Presto/2.12.388 Version/12.16.2'),
           ('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A'),
           ('Surf/0.4.1 (X11; U; Unix; en-US) AppleWebKit/531.2+ Compatible (Safari; MSIE 9.0)'),
           ('w3m/0.5.2 (Linux i686; it; Debian-3.0.6-3)')


-- INSERT SOME RANDOM NOT ANONIMIZED IP ADDRESS
DECLARE @i int = 0

WHILE @i < 100
BEGIN
    SET @i = @i + 1

	INSERT INTO [dbo].[accesses_ips]
			   ([value])
		 VALUES
			   (test.random_ips()),
			   (test.random_ips()),
			   (test.random_ips()),
			   (test.random_ips()),
			   (test.random_ips()),
			   (test.random_ips()),
			   (test.random_ips()),
			   (test.random_ips()),
			   (test.random_ips()),
			   (test.random_ips())
		   
END

-- INSERT SOME PAGES
INSERT INTO [dbo].[accesses_pages]
           ([uri]
           ,[website_id])
     VALUES
           ('/' , 1),
           ('/aboutus' , 1),
           ('/contact' , 1),
           ('/' , 2),
           ('/posts' , 2),
           ('/posts/1' , 2),
           ('/posts/2' , 2),
           ('/posts/3' , 2),
           ('/about' , 2),
           ('/contact' , 2)


-- INSERT SOME RANDOM VISITS WITHOUT REFERER

SET @i = 0

WHILE @i < 1000
BEGIN
    SET @i = @i + 1
INSERT INTO [dbo].[accesses_visits]
           ([date]
           ,[page_id]
           ,[page_reference_id]
           ,[browser_id]
           ,[user_id])
     VALUES
           ((SELECT value FROM test.vw_getRandomDate)
           ,(SELECT TOP 1 id FROM accesses_pages ORDER BY NEWID())
           ,NULL
           ,(SELECT TOP 1 id FROM accesses_browsers ORDER BY NEWID())
           ,(SELECT TOP 1 id FROM users ORDER BY NEWID()))
END

-- INSERT SOME RANDOM VISITS WITH REFERER

SET @i = 0

WHILE @i < 1000
BEGIN
    SET @i = @i + 1

    INSERT INTO [dbo].[accesses_visits]
            ([date]
            ,[page_id]
            ,[page_reference_id]
            ,[browser_id]
            ,[user_id])
    SELECT (SELECT value FROM test.vw_getRandomDate) AS [date]
            ,(SELECT TOP 1 id FROM accesses_pages WHERE accesses_pages.website_id = websites.id ORDER BY NEWID()) AS [page_id]
            ,(SELECT TOP 1 id FROM accesses_pages WHERE accesses_pages.website_id = websites.id ORDER BY NEWID()) AS [page_reference_id]
            ,(SELECT TOP 1 id FROM accesses_browsers ORDER BY NEWID()) AS [browser_id]
            ,(SELECT TOP 1 id FROM users ORDER BY NEWID()) AS [user_id]
            FROM websites ORDER BY NEWID()
END

---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF
