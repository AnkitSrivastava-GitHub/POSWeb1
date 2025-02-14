USE [PW_POS]
GO
/****** Object:  Table [dbo].[InvoiceMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[InvoiceNo] [varchar](25) NULL,
	[InvoiceDate] [datetime] NULL,
	[PaymentMethod] [varchar](25) NULL,
	[TaxType] [varchar](20) NULL,
	[Tax]  AS ([dbo].[Fun_SaleInvoiceTax]([AutoId])),
	[TempInvoiceNo] [varchar](50) NULL,
	[TransactionId] [varchar](100) NULL,
	[AuthCode] [varchar](50) NULL,
	[CustomerId] [int] NULL,
	[Status] [int] NULL,
	[UpdateDate] [datetime] NULL,
	[CancelDate] [datetime] NULL,
	[UpdateBy] [varchar](25) NULL,
	[LogInId] [int] NULL,
	[UserId] [varchar](25) NULL,
	[Discount] [decimal](10, 2) NULL,
	[Total]  AS ([dbo].[Fun_SaleInvoiceTotal]([AutoId])),
	[TerminalId] [int] NULL,
	[CardType] [varchar](20) NULL,
	[CardNo] [varchar](20) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[InvoiceMaster] ON 

INSERT [dbo].[InvoiceMaster] ([AutoId], [InvoiceNo], [InvoiceDate], [PaymentMethod], [TaxType], [TempInvoiceNo], [TransactionId], [AuthCode], [CustomerId], [Status], [UpdateDate], [CancelDate], [UpdateBy], [LogInId], [UserId], [Discount], [TerminalId], [CardType], [CardNo]) VALUES (1, N'100001', CAST(N'2023-06-06T13:42:41.203' AS DateTime), N'Cash', N'Excluding Tax', N'', N'', N'', 1, 0, CAST(N'2023-06-06T20:05:32.380' AS DateTime), CAST(N'2023-06-06T20:05:32.380' AS DateTime), N'EMP100001', 1, N'EMP100001', CAST(0.00 AS Decimal(10, 2)), 1, N'', N'')
INSERT [dbo].[InvoiceMaster] ([AutoId], [InvoiceNo], [InvoiceDate], [PaymentMethod], [TaxType], [TempInvoiceNo], [TransactionId], [AuthCode], [CustomerId], [Status], [UpdateDate], [CancelDate], [UpdateBy], [LogInId], [UserId], [Discount], [TerminalId], [CardType], [CardNo]) VALUES (2, N'100002', CAST(N'2023-06-06T14:14:22.400' AS DateTime), N'Cash', N'Excluding Tax', N'', N'', N'', 1, 0, CAST(N'2023-06-06T14:14:52.970' AS DateTime), CAST(N'2023-06-06T14:14:52.970' AS DateTime), N'EMP100001', 1, N'EMP100001', CAST(0.00 AS Decimal(10, 2)), 1, N'', N'')
INSERT [dbo].[InvoiceMaster] ([AutoId], [InvoiceNo], [InvoiceDate], [PaymentMethod], [TaxType], [TempInvoiceNo], [TransactionId], [AuthCode], [CustomerId], [Status], [UpdateDate], [CancelDate], [UpdateBy], [LogInId], [UserId], [Discount], [TerminalId], [CardType], [CardNo]) VALUES (3, N'100003', CAST(N'2023-06-07T18:40:01.473' AS DateTime), N'Cash', N'Excluding Tax', N'', N'', N'', 1, 0, CAST(N'2023-06-07T18:40:54.350' AS DateTime), CAST(N'2023-06-07T18:40:54.350' AS DateTime), N'EMP100001', 1, N'EMP100001', CAST(0.00 AS Decimal(10, 2)), 1, N'', N'')
SET IDENTITY_INSERT [dbo].[InvoiceMaster] OFF
GO
