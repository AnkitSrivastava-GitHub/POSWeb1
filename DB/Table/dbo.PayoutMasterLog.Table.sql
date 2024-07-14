USE [pos201.priorpos.com]
GO

/****** Object:  Table [dbo].[PayoutMaster]    Script Date: 01/06/2024 12:32:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PayoutMasterLog](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[PayTo] [varchar](50) NULL,
	[Remark] [varchar](200) NULL,
	[Amount] [decimal](18, 2) NULL,
	[PayoutMode] [varchar](50) NULL,
	[TransactionId] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[CompanyId] [int] NULL,
	[Expense] [int] NULL,
	[Vendor] [int] NULL,
	[PayoutType] [int] NULL,
	[Terminal] [int] NULL,
	[PayoutDate] [datetime] NULL,
	[PayoutTime] [varchar](50) NULL,
	[ShiftId] [int] NULL,
	[PayoutId] [int] NULL
) ON [PRIMARY]
GO


