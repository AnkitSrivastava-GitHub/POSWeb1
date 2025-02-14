USE [PW_POS]
GO
/****** Object:  Table [dbo].[InvoiceItemMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceItemMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[SKUAutoId] [int] NULL,
	[ProductId] [int] NULL,
	[PackingId] [int] NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](10, 2) NULL,
	[Tax] [decimal](10, 2) NULL,
	[Total] [decimal](10, 2) NULL,
	[TaxPer] [decimal](10, 3) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[InvoiceItemMaster] ON 

INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (1, 1, 21002, 21046, 1, CAST(11.95 AS Decimal(10, 2)), CAST(0.79 AS Decimal(10, 2)), CAST(12.74 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (2, 2, 21001, 21045, 1, CAST(11.95 AS Decimal(10, 2)), CAST(0.79 AS Decimal(10, 2)), CAST(12.74 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (3, 3, 20983, 21027, 1, CAST(52.95 AS Decimal(10, 2)), CAST(3.51 AS Decimal(10, 2)), CAST(56.46 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (4, 4, 20980, 21024, 1, CAST(49.95 AS Decimal(10, 2)), CAST(3.31 AS Decimal(10, 2)), CAST(53.26 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (5, 5, 20979, 21023, 1, CAST(49.95 AS Decimal(10, 2)), CAST(3.31 AS Decimal(10, 2)), CAST(53.26 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (6, 6, 20978, 21022, 1, CAST(7.00 AS Decimal(10, 2)), CAST(0.46 AS Decimal(10, 2)), CAST(7.46 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (7, 7, 20977, 21021, 1, CAST(7.00 AS Decimal(10, 2)), CAST(0.46 AS Decimal(10, 2)), CAST(7.46 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (8, 8, 20976, 21020, 1, CAST(7.00 AS Decimal(10, 2)), CAST(0.46 AS Decimal(10, 2)), CAST(7.46 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (9, 9, 20975, 21019, 1, CAST(7.00 AS Decimal(10, 2)), CAST(0.46 AS Decimal(10, 2)), CAST(7.46 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (10, 10, 20974, 21018, 1, CAST(7.00 AS Decimal(10, 2)), CAST(0.46 AS Decimal(10, 2)), CAST(7.46 AS Decimal(10, 2)), CAST(6.625 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (11, 11, 58525, 58567, 1, CAST(11.99 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(11.99 AS Decimal(10, 2)), CAST(0.000 AS Decimal(10, 3)))
INSERT [dbo].[InvoiceItemMaster] ([AutoId], [SKUAutoId], [ProductId], [PackingId], [Quantity], [UnitPrice], [Tax], [Total], [TaxPer]) VALUES (12, 12, 58524, 58566, 1, CAST(8.99 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), CAST(8.99 AS Decimal(10, 2)), CAST(0.000 AS Decimal(10, 3)))
SET IDENTITY_INSERT [dbo].[InvoiceItemMaster] OFF
GO
