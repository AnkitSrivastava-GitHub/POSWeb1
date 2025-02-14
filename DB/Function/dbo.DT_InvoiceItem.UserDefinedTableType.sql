USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_InvoiceItem]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_InvoiceItem] AS TABLE(
	[ProductId] [int] NULL,
	[Packingid] [int] NULL,
	[ReceivedQty] [int] NULL,
	[UnitPrice] [decimal](18, 3) NULL,
	[Taxper] [decimal](18, 3) NULL,
	[ProductUnitPrice] [decimal](18, 3) NULL,
	[SecUnitPrice] [decimal](18, 3) NULL,
	[VendorProductCode] [varchar](30)
)
GO