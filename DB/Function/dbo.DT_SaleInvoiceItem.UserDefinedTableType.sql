USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_SaleInvoiceItem]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_SaleInvoiceItem] AS TABLE(
	[SKUId] [int] NULL,
	[ProductId] [int] NULL,
	[PackingId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](18, 3) NULL,
	[Tax] [decimal](18, 3) NULL,
	[Total] [decimal](18, 3) NULL
)
GO
