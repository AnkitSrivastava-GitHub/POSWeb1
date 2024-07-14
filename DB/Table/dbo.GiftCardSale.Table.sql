
CREATE TABLE [dbo].[GiftCardSale](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[GiftCardName] [varchar](100) NULL,
	[GiftCardCode] [varchar](25) NOT NULL,
	[TotalAmt] [decimal](18, 2) NOT NULL,
	[LeftAmt] [decimal](18, 2) NULL,
	[GiftCardPurchaseInvoice] [varchar](25) NULL,
	[SoldDate] [datetime] NULL,
	[SoldBy] [int] NULL,
	[SoldStatus] [int] NULL,
	[StoreId] [int] NULL,
	[TerminalId] [int] NULL,
	CustomerAutoId int null,
 CONSTRAINT [PK_GiftCardSale] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


