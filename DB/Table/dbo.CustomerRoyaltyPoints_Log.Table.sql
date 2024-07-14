USE [pos201.priorpos.com]
GO

/****** Object:  Table [dbo].[CustomerRoyaltyPoints_Log]    Script Date: 12/29/2023 7:00:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustomerRoyaltyPoints_Log](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[AssignedRoyaltyPoints] [int] NULL,
	[StoreId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[Status] [int] NULL,
	[InvoiceAutoId] [int] NULL
) ON [PRIMARY]
GO


