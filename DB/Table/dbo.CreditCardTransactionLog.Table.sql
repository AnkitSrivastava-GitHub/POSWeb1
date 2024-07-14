USE [pos201.priorpos.com]
GO

/****** Object:  Table [dbo].[CreditCardTransactionLog]    Script Date: 01/10/2024 1:40:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CreditCardTransactionLog](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NULL,
	[DraftAutoId] [int] NULL,
	[InvoiceNo] [varchar](50) NULL,
	[CardType] [int] NULL,
	[CardNo] [varchar](50) NULL,
	[TransactionId] [varchar](50) NULL,
	[TotalAmt] [decimal](18, 2) NULL,
	[StoreId] [int] NULL,
	[TrnsStatus] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


