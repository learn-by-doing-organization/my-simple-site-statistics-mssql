DECLARE @sqlString AS VARCHAR(1000)

IF OBJECT_ID (N'DbScriptMigration', N'U') IS NULL
BEGIN 
    SET @sqlString = 'CREATE TABLE [dbo].[DbScriptMigration] (
            [MigrationId] [uniqueidentifier] NOT NULL,
            [MigrationName] [nvarchar](1000) NOT NULL,
            [MigrationDate] [datetime] NOT NULL,
        CONSTRAINT [PK_DbScriptMigration] PRIMARY KEY CLUSTERED 
        (
            [MigrationId] ASC
        ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
        ) ON [PRIMARY] '
    EXEC (@sqlString)
    PRINT 'Table [DbScriptMigration] created!'

    SET @sqlString = 'INSERT INTO [dbo].[DbScriptMigration]
            ([MigrationId],[MigrationName],[MigrationDate])
        VALUES (NEWID(),''000_InitialScript.sql'',GETDATE()) '
    EXEC (@sqlString)
    PRINT 'Insert ''000_InitialScript.sql'' into table [DbScriptMigration]!'
END
GO


PRINT 'DbScriptMigrationSystem initialized successfully!'
GO
