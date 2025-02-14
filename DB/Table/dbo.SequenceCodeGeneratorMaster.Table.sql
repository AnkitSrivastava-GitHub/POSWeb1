USE [PW_POS]
GO
/****** Object:  Table [dbo].[SequenceCodeGeneratorMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SequenceCodeGeneratorMaster](
	[AutoID] [int] IDENTITY(1,1) NOT NULL,
	[SequenceCode] [nvarchar](50) NOT NULL,
	[PreSample] [nvarchar](10) NOT NULL,
	[PostSample] [nvarchar](15) NOT NULL,
	[currentSequence] [numeric](15, 0) NOT NULL,
	[Description] [nvarchar](100) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SequenceCodeGeneratorMaster] ON 

INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (1, N'CompanyId', N'CMP', N'100000', CAST(0 AS Numeric(15, 0)), N'Company id')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (2, N'BrandId', N'BRN', N'100000', CAST(1385 AS Numeric(15, 0)), N'Brand Id')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (3, N'CategoryId', N'CAT', N'100000', CAST(1493 AS Numeric(15, 0)), N'Category id')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (4, N'ProductId', N'PRD', N'100000', CAST(38242 AS Numeric(15, 0)), N'product Id')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (5, N'VendorId', N'VND', N'100000', CAST(0 AS Numeric(15, 0)), N'Vendor Id')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (6, N'TaxId', N'TAX', N'100000', CAST(0 AS Numeric(15, 0)), N'Tax ID')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (7, N'SKU', N'SKU', N'100000', CAST(38242 AS Numeric(15, 0)), N'SKU')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (8, N'PoNumber', N'PO', N'100000', CAST(0 AS Numeric(15, 0)), N'PoNumber')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (9, N'PInvoice', N'PI', N'100000', CAST(0 AS Numeric(15, 0)), NULL)
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (10, N'InvoiceNo', N'', N'100000', CAST(3 AS Numeric(15, 0)), N'InvoiceNo')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (11, N'CustomerNo', N'C', N'100000', CAST(1 AS Numeric(15, 0)), N'CustomerNo')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (12, N'Employee', N'EMP', N'100000', CAST(2 AS Numeric(15, 0)), NULL)
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (13, N'TerminalId', N'Te', N'100000', CAST(0 AS Numeric(15, 0)), NULL)
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (14, N'Draft', N'D', N'100000', CAST(1 AS Numeric(15, 0)), NULL)
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (15, N'TempInvoice', N'T', N'100000', CAST(0 AS Numeric(15, 0)), N'For Temp Invoice No')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (15, N'ModuleId', N'M', N'100000', CAST(0 AS Numeric(15, 0)), N'For Module Id')
INSERT [dbo].[SequenceCodeGeneratorMaster] ([AutoID], [SequenceCode], [PreSample], [PostSample], [currentSequence], [Description]) VALUES (15, N'SubModuleId', N'SM', N'100000', CAST(0 AS Numeric(15, 0)), N'For Sub Module Id')
SET IDENTITY_INSERT [dbo].[SequenceCodeGeneratorMaster] OFF
GO
