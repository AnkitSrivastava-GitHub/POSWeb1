USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_SchemeProduct]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_SchemeProduct] AS TABLE(
	[ProductId] [int] NULL,
	[PackingId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](10, 3) NULL
)
GO
