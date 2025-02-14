USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_PakingType]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_PakingType] AS TABLE(
	[PackingName] [varchar](50) NULL,
	[UnitPrice] [decimal](10, 3) NULL,
	[CostPrice] [decimal](10, 3) NULL,
	[Barcode] [varchar](50) NULL,
	[TaxAutoId] [varchar](50) NULL,
	[Status] [bit] NOT NULL
)
GO
