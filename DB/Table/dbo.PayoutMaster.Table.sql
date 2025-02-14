USE [pos101.priorpos.com]
GO
/****** Object:  Table [dbo].[PayoutMaster]    Script Date: 11/3/2023 11:50:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayoutMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[PayTo] [varchar](50) NULL,
	[Remark] [varchar](200) NULL,
	[Amount] [decimal](18, 2) NULL,
	[PayoutMode] [varchar](50) NULL,
	[TransactionId] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CompanyId] [int] NULL,
	[Expense] [int] NULL,
	[Vendor] [int] NULL,
	[PayoutType] [int] NULL
) ON [PRIMARY]
GO
