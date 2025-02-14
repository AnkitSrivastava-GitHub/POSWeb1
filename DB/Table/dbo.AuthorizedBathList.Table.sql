USE [PW_POS]
GO
/****** Object:  Table [dbo].[AuthorizedBathList]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthorizedBathList](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[batchId] [varchar](70) NULL,
	[settlementTimeUTC] [datetime] NULL,
	[settlementTimeLocal] [datetime] NULL,
	[PymentGetway] [int] NULL,
	[chargeAmount] [decimal](18, 2) NULL,
	[chargeCount] [int] NULL,
	[refundAmount] [decimal](18, 2) NULL,
	[refundCount] [int] NULL,
	[voidCount] [int] NULL,
	[declineCount] [int] NULL
) ON [PRIMARY]
GO
