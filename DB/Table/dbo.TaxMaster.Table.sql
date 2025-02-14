USE [PW_POS]
GO
/****** Object:  Table [dbo].[TaxMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[TaxId] [varchar](50) NOT NULL,
	[TaxName] [varchar](200) NULL,
	[TaxPer] [decimal](18, 3) NULL,
	[Status] [int] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[TaxMaster] ON 

INSERT [dbo].[TaxMaster] ([AutoId], [TaxId], [TaxName], [TaxPer], [Status]) VALUES (1, N'TAX100001', N'No Tax', CAST(10.000 AS Decimal(18, 3)), 1)
INSERT [dbo].[TaxMaster] ([AutoId], [TaxId], [TaxName], [TaxPer], [Status]) VALUES (2, N'TAX100002', N'6.625', CAST(6.625 AS Decimal(18, 3)), 1)
SET IDENTITY_INSERT [dbo].[TaxMaster] OFF
GO
