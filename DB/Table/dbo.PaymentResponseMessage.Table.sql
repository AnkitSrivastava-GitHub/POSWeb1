USE [PW_POS]
GO
/****** Object:  Table [dbo].[PaymentResponseMessage]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentResponseMessage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TempInvoiceNo] [varchar](50) NULL,
	[CreditCardNo] [varchar](50) NULL,
	[ResponseCode] [varchar](50) NULL,
	[ResponseMessage] [nvarchar](max) NULL,
	[Amount] [decimal](10, 2) NULL,
	[EntryDate] [nvarchar](50) NULL,
	[Who] [varchar](50) NULL,
	[Type] [varchar](20) NULL,
	[TransactionID] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
