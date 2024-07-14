USE [pos101.priorpos.com]
GO

/****** Object:  Table [dbo].[ManageStockMasterLog]    Script Date: 12/12/2023 11:40:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ManageStockMasterLog](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[StockQTY] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedByStore] [int] NULL,
	[IsDeleted] [int] NULL,
	[PreviousStock] [int] NULL,
	[MSMAutoId] [int] NULL,
	[InvoiceId] [int] NULL,
 CONSTRAINT [PK_ManageStockMasterLog] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


