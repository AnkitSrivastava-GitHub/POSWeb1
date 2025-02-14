USE [PW_POS]
GO
/****** Object:  Table [dbo].[InventoryMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[ProductAutoId] [int] NULL,
	[PackingAutoId] [int] NULL,
	[UnitPrice] [decimal](10, 2) NULL,
	[Quantity] [int] NULL
) ON [PRIMARY]
GO
