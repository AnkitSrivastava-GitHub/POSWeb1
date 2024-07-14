
CREATE TABLE [dbo].[PageMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[PageName] [varchar](200)  NULL,
	[ParentModuleAutoId] int  NULL,
	[PageUrl] [varchar](200)  NULL,
	[Description] [varchar](500)  NULL,
	[Status] int NOT NULL,
	[StoreId] int  NULL, 
	[CreatedOn] date  null,
[CreatedBy] int  NULL, 
 [UpdatedOn] date  null,
 [UpdatedBy] int  NULL,
 [PageId] [varchar](20)  NULL,
) ON [PRIMARY]
GO