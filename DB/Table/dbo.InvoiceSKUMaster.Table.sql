USE [PW_POS]
GO
/****** Object:  Table [dbo].[InvoiceSKUMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceSKUMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceAutoId] [int] NULL,
	[SKUId] [int] NULL,
	[SchemeId] [int] NULL,
	[Quantity] [int] NULL,
	[Tax]  AS ([dbo].[Fun_SaleInvoiceSKUTotaltax]([AutoId],[Quantity])),
	[Total]  AS ([dbo].[Fun_SaleInvoiceSKUTotal]([AutoId],[Quantity]))
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[InvoiceSKUMaster] ON 

INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (1, 1, 21028, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (2, 1, 21027, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (3, 1, 21009, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (4, 1, 21006, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (5, 1, 21005, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (6, 1, 21004, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (7, 1, 21003, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (8, 1, 21002, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (9, 1, 21001, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (10, 2, 21000, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (11, 3, 58549, 0, 1)
INSERT [dbo].[InvoiceSKUMaster] ([AutoId], [InvoiceAutoId], [SKUId], [SchemeId], [Quantity]) VALUES (12, 3, 58548, 0, 1)
SET IDENTITY_INSERT [dbo].[InvoiceSKUMaster] OFF
GO
