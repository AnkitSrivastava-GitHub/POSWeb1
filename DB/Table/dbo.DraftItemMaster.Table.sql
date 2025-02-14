USE [PW_POS]
GO
/****** Object:  Table [dbo].[DraftItemMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DraftItemMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[SKUAutoId] [int] NULL,
	[ProductId] [int] NULL,
	[PackingId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](10, 2) NULL,
	[Tax] [decimal](10, 2) NULL,
	[Total] [decimal](10, 2) NULL,
	[DraftAutoId] [int] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DraftItemMaster] ON 

INSERT [dbo].[DraftItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [DraftAutoId]) VALUES (1, 1, 61538, 61580, 1, CAST(3.39 AS Decimal(10, 2)), CAST(0.23 AS Decimal(10, 2)), CAST(3.62 AS Decimal(10, 2)), 1)
SET IDENTITY_INSERT [dbo].[DraftItemMaster] OFF
GO
