-------------------- SCRIPT TO CHECK OF DbScriptMigrationSystem -------------------------------
DECLARE @MigrationName AS VARCHAR(1000) = '001_ExampleScriptName'

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
DECLARE @PrerequisiteMigrationName AS VARCHAR(1000) = '000b_CreateUniqueCostraintForMigrationName'
IF NOT EXISTS(SELECT MigrationId FROM [DbScriptMigration] WHERE MigrationName = @PrerequisiteMigrationName)
BEGIN 
    raiserror('YOU HAVET TO RUN SCRIPT %s ON THIS DB!!! STOP EXECUTION SCRIPT ', 11, 0, @PrerequisiteMigrationName)
    SET NOEXEC ON
END
-------------------- END SCRIPT TO CHECK PREREQUISITES OF DbScriptMigrationSystem ---------------------------


/****** Object:  Table [dbo].[accesses_browsers]    Script Date: 1/30/2021 7:38:39 PM ******/
CREATE TABLE [dbo].[accesses_browsers](
	[id] [bigint] NOT NULL,
	[user_agent_string] [text] NOT NULL,
 CONSTRAINT [PK_accesses_browsers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[accesses_ips]    Script Date: 1/30/2021 7:38:39 PM ******/
CREATE TABLE [dbo].[accesses_ips](
	[id] [bigint] NOT NULL,
	[value] [char](128) NOT NULL,
	[host_name] [varchar](255) NULL,
 CONSTRAINT [PK_accesses_ips] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[accesses_pages]    Script Date: 1/30/2021 7:38:39 PM ******/
CREATE TABLE [dbo].[accesses_pages](
	[id] [bigint] NOT NULL,
	[uri] [varchar](500) NOT NULL,
	[website_id] [bigint] NOT NULL,
 CONSTRAINT [PK_accesses_pages] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[accesses_visits]    Script Date: 1/30/2021 7:38:39 PM ******/
CREATE TABLE [dbo].[accesses_visits](
	[id] [bigint] NOT NULL,
	[date] [datetime] NOT NULL,
	[page_id] [bigint] NOT NULL,
	[page_reference_id] [bigint] NULL,
	[browser_id] [bigint] NOT NULL,
	[user_id] [bigint] NULL,
 CONSTRAINT [PK_accesses_visits] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[users]    Script Date: 1/30/2021 7:38:39 PM ******/
CREATE TABLE [dbo].[users](
	[id] [bigint] NOT NULL,
	[username] [varchar](100) NOT NULL,
	[email] [varchar](255) NULL,
	[created_date] [datetime] NOT NULL,
	[last_access_date] [datetime] NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[websites]    Script Date: 1/30/2021 7:38:39 PM ******/
CREATE TABLE [dbo].[websites](
	[id] [bigint] NOT NULL,
	[name] [varchar](100) NOT NULL,
	[address] [varchar](500) NULL,
 CONSTRAINT [PK_websites] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[accesses_visits] ADD  CONSTRAINT [DF_accesses_visits_date]  DEFAULT (getdate()) FOR [date]
GO

ALTER TABLE [dbo].[users] ADD  CONSTRAINT [DF_users_created_date]  DEFAULT (getdate()) FOR [created_date]
GO

ALTER TABLE [dbo].[accesses_pages]  WITH CHECK ADD  CONSTRAINT [FK_accesses_pages_websites] FOREIGN KEY([id])
REFERENCES [dbo].[websites] ([id])
GO

ALTER TABLE [dbo].[accesses_pages] CHECK CONSTRAINT [FK_accesses_pages_websites]
GO

ALTER TABLE [dbo].[accesses_visits]  WITH CHECK ADD  CONSTRAINT [FK_accesses_visits_accesses_browsers] FOREIGN KEY([browser_id])
REFERENCES [dbo].[accesses_browsers] ([id])
GO

ALTER TABLE [dbo].[accesses_visits] CHECK CONSTRAINT [FK_accesses_visits_accesses_browsers]
GO

ALTER TABLE [dbo].[accesses_visits]  WITH CHECK ADD  CONSTRAINT [FK_accesses_visits_accesses_pages] FOREIGN KEY([page_id])
REFERENCES [dbo].[accesses_pages] ([id])
GO

ALTER TABLE [dbo].[accesses_visits] CHECK CONSTRAINT [FK_accesses_visits_accesses_pages]
GO

ALTER TABLE [dbo].[accesses_visits]  WITH CHECK ADD  CONSTRAINT [FK_accesses_visits_accesses_pages1] FOREIGN KEY([id])
REFERENCES [dbo].[accesses_pages] ([id])
GO

ALTER TABLE [dbo].[accesses_visits] CHECK CONSTRAINT [FK_accesses_visits_accesses_pages1]
GO

ALTER TABLE [dbo].[accesses_visits]  WITH CHECK ADD  CONSTRAINT [FK_accesses_visits_accesses_visits] FOREIGN KEY([id])
REFERENCES [dbo].[accesses_visits] ([id])
GO

ALTER TABLE [dbo].[accesses_visits] CHECK CONSTRAINT [FK_accesses_visits_accesses_visits]
GO

ALTER TABLE [dbo].[accesses_visits]  WITH CHECK ADD  CONSTRAINT [FK_accesses_visits_accesses_visits1] FOREIGN KEY([id])
REFERENCES [dbo].[accesses_visits] ([id])
GO

ALTER TABLE [dbo].[accesses_visits] CHECK CONSTRAINT [FK_accesses_visits_accesses_visits1]
GO

ALTER TABLE [dbo].[accesses_visits]  WITH CHECK ADD  CONSTRAINT [FK_accesses_visits_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO

ALTER TABLE [dbo].[accesses_visits] CHECK CONSTRAINT [FK_accesses_visits_users]
GO

---------------- FOOTER OF DbScriptMigrationSystem : REMEMBER TO INSERT -----------------------
SET NOEXEC OFF