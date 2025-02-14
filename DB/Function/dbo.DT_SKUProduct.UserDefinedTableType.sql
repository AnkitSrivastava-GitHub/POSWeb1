USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_SKUProduct]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_SKUProduct] AS TABLE(
	[ProductId] [int] NULL,
	[PackingId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](10, 3) NULL,
	[Discount] [decimal](10, 3) NULL
)
GO
