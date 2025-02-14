USE [PW_POS]
GO
/****** Object:  Table [dbo].[PurchaseInvoiceMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PurchaseInvoiceMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceNo] [varchar](50) NULL,
	[PoNumber] [int] NULL,
	[InvoiceDate] [datetime] NULL,
	[Remark] [varchar](200) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY]
GO
