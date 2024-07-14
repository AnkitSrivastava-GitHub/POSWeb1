CREATE TABLE [dbo].[ComponentMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[ComponentName] [varchar](200)  NULL,
	[ModuleAutoId] int  NULL,
	[SubModuleAutoId] int  NULL,
	[Description] [varchar](500)  NULL,
	[Status] int NOT NULL,
	[StoreId] int  NULL, 
	[CreatedOn] date  null,
	[CreatedBy] int  NULL, 
	[UpdatedOn] date  null,
	[UpdatedBy] int  NULL,
	[ComponentId] [varchar](20)  NULL,
) ON [PRIMARY]
GO