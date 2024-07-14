USE [pos201.priorpos.com]
GO

/****** Object:  Table [dbo].[InvoicePrintDetails]    Script Date: 12/19/2023 11:14:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InvoicePrintDetails](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[StoreName] [varchar](150) NULL,
	[ContactPersone] [varchar](150) NULL,
	[BillingAddress] [varchar](250) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[ZipCode] [int] NULL,
	[WebSite] [varchar](250) NULL,
	[EmailId] [varchar](150) NULL,
	[MobileNo] [varchar](10) NULL,
	[ShowHappyPoints] [int] NULL,
	[ShowFooter] [int] NULL,
	[Footer] [varchar](150) NULL,
	[StoreId] [int] NULL,
	[ShowLogo] [int] NULL,
 CONSTRAINT [PK_InvoicePrintDetails] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


