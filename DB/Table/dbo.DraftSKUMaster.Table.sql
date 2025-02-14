USE [PW_POS]
GO
/****** Object:  Table [dbo].[DraftSKUMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DraftSKUMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[DraftAutoId] [int] NULL,
	[SKUId] [int] NULL,
	[SchemeId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice]  AS ([dbo].[Fun_DraftSKUUnitPrice]([AutoId])),
	[Tax]  AS ([dbo].[Fun_DraftSKUTotaltax]([AutoId],[Quantity])),
	[Total]  AS ([dbo].[Fun_DraftSKUTotal]([AutoId],[Quantity]))
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[DraftSKUMaster] ON 

INSERT [dbo].[DraftSKUMaster] ([AutoId], [DraftAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (1, 1, 61562, 0, 7)
SET IDENTITY_INSERT [dbo].[DraftSKUMaster] OFF
GO
