CREATE TABLE [dbo].[ModuleMaster](
    [AutoId] [int] IDENTITY(1,1) NOT NULL,
    [ModuleId] [varchar](50) NULL,
    [ModuleName] [varchar](200) NULL,
    [Status] [int] NULL,    
    [StoreId] [int] NULL,
    [CreatedOn] [date] NULL,
    [CreatedBy] [int] NULL,
    [UpdatedOn] [date] NULL,
    [UpdatedBy] [int] NULL,
    [SequenceNo] [int] NULL
) ON [PRIMARY]
GO