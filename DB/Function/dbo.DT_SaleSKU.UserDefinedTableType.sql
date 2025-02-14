USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_SaleSKU]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_SaleSKU] AS TABLE(
	[SKUId] [int] NULL,
	[SKUName] [varchar](500) NULL,
	[SchemeId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](18, 3) NULL,
	[Tax] [decimal](18, 3) NULL,
	[Amount] [decimal](18, 3) NULL
)
GO
