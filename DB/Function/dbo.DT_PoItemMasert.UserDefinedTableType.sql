USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_PoItemMasert]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_PoItemMasert] AS TABLE(
	[PoItemAutoId] [int] Null,
	[ProductId] [varchar](200) NULL,
	[PackingId] [int] NULL,
	[RequiredQty] [int] NULL,
	[ActionId] [int] Null,
	[UnitPrice] decimal(18,2),
	[SecUnitPrice] decimal(18,2),
	[VendorProductCode] [varchar](30)
)
GO