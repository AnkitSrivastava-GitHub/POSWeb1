USE [PW_POS]
GO
/****** Object:  Table [dbo].[DraftMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DraftMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[DraftNo] [varchar](25) NULL,
	[DraftDate] [datetime] NULL,
	[CustomerId] [int] NULL,
	[TerminalId] [int] NULL,
	[DraftName] [varchar](200) NULL,
	[Discount] [decimal](10, 2) NULL,
	[Type] [varchar](20) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DraftMaster] ON 

INSERT [dbo].[DraftMaster] ([AutoId], [DraftNo], [DraftDate], [CustomerId], [TerminalId], [DraftName], [Discount], [Type]) VALUES (1, N'D100001', CAST(N'2023-06-09T12:08:20.850' AS DateTime), 1, 1, N'Draft 1', CAST(0.00 AS Decimal(10, 2)), N'Draft')
SET IDENTITY_INSERT [dbo].[DraftMaster] OFF
GO
