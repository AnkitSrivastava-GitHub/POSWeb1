USE [PW_POS]
GO
/****** Object:  Table [dbo].[SchemeItemMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchemeItemMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[SchemeAutoId] [int] NULL,
	[ProductAutoId] [int] NULL,
	[PackingAutoId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](10, 2) NULL,
	[Tax]  AS ([dbo].[Fun_SchemeItemTax]([AutoId])),
	[Total]  AS ([dbo].[Fun_SchemeItemTotal]([AutoId]))
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SchemeItemMaster] ON 

INSERT [dbo].[SchemeItemMaster] ([AutoId], [SchemeAutoId], [ProductAutoId], [PackingAutoId], [Quantity], [UnitPrice]) VALUES (2, 1, 61538, 61580, 1, CAST(3.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [dbo].[SchemeItemMaster] OFF
GO
