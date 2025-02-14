
CREATE TABLE  [dbo].[PurchaseItemMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceId] [int] NULL,
	[StoreId] [int] NULL,
	[ProductId] [int] NULL,
	[Packingid] [int] NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[createddate] [datetime] NULL,
	[ReceivedQty] [int] NULL,
	[TaxType] [varchar](50) NULL,
	[TaxPer] [decimal](18, 2) NULL,
	[Tax]  AS ([dbo].[Fun_InvoiceItemTax]([AutoId],[StoreId])),
	[Total]  AS ([dbo].[Fun_InvoiceItemTotal]([AutoId],[StoreId]))
) ON [PRIMARY]
GO

alter table [PurchaseItemMaster] drop Column Tax,Total

alter table [PurchaseItemMaster] add [Tax]  AS ([dbo].[Fun_InvoiceItemTax]([AutoId],[StoreId])),
	[Total]  AS ([dbo].[Fun_InvoiceItemTotal]([AutoId],[StoreId]))