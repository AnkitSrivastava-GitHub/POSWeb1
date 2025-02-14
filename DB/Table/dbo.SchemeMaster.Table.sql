USE [PW_POS]
GO
/****** Object:  Table [dbo].[SchemeMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchemeMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[SchemeName] [varchar](100) NULL,
	[SKUAutoId] [int] NULL,
	[Quantity] [int] NULL,
	[Status] [int] NULL,
	[MaxQuantity]  AS ([dbo].[Fun_MaxQuantityScheme]([AutoId])),
	[Tax]  AS ([dbo].[Fun_SchemeTotalTax]([AutoId])),
	[UnitPrice]  AS ([dbo].[Fun_SchemeUnitPrice]([AutoId]))
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SchemeMaster] ON 

INSERT [dbo].[SchemeMaster] ([AutoId], [SchemeName], [SKUAutoId], [Quantity], [Status]) VALUES (1, N'sch1', 61562, 5, 0)
SET IDENTITY_INSERT [dbo].[SchemeMaster] OFF
GO
