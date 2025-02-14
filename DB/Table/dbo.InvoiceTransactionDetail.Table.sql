USE [PW_POS]
GO
/****** Object:  Table [dbo].[InvoiceTransactionDetail]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceTransactionDetail](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceAutoId] [int] NULL,
	[TransactionId] [varchar](50) NULL,
	[AuthCode] [varchar](50) NULL,
	[PaymentMode] [varchar](20) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](20) NULL,
	[TempInvoiceNo] [varchar](50) NULL,
	[RefundAgainstId] [varchar](50) NULL,
	[Amount] [decimal](18, 2) NULL,
	[CardType] [varchar](50) NULL,
	[CardNo] [varchar](50) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[InvoiceTransactionDetail] ON 

INSERT [dbo].[InvoiceTransactionDetail] ([AutoId], [InvoiceAutoId], [TransactionId], [AuthCode], [PaymentMode], [CreatedDate], [CreatedBy], [TempInvoiceNo], [RefundAgainstId], [Amount], [CardType], [CardNo]) VALUES (1, 1, N'', N'', N'Cash', CAST(N'2023-06-06T13:42:41.203' AS DateTime), N'EMP100001', N'', NULL, NULL, N'', N'')
INSERT [dbo].[InvoiceTransactionDetail] ([AutoId], [InvoiceAutoId], [TransactionId], [AuthCode], [PaymentMode], [CreatedDate], [CreatedBy], [TempInvoiceNo], [RefundAgainstId], [Amount], [CardType], [CardNo]) VALUES (2, 2, N'', N'', N'Cash', CAST(N'2023-06-06T14:14:22.400' AS DateTime), N'EMP100001', N'', NULL, NULL, N'', N'')
INSERT [dbo].[InvoiceTransactionDetail] ([AutoId], [InvoiceAutoId], [TransactionId], [AuthCode], [PaymentMode], [CreatedDate], [CreatedBy], [TempInvoiceNo], [RefundAgainstId], [Amount], [CardType], [CardNo]) VALUES (3, 3, N'', N'', N'Cash', CAST(N'2023-06-07T18:40:01.473' AS DateTime), N'EMP100001', N'', NULL, NULL, N'', N'')
SET IDENTITY_INSERT [dbo].[InvoiceTransactionDetail] OFF
GO
