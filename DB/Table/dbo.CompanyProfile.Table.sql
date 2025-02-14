USE [PW_POS]
GO
/****** Object:  Table [dbo].[CompanyProfile]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyProfile](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [varchar](50) NOT NULL,
	[CompanyName] [varchar](max) NULL,
	[ContactName] [varchar](max) NULL,
	[BillingAddress] [varchar](max) NULL,
	[Country] [varchar](100) NULL,
	[State] [varchar](100) NULL,
	[City] [varchar](200) NULL,
	[ZipCode] [varchar](50) NULL,
	[EmailId] [varchar](max) NULL,
	[Website] [varchar](max) NULL,
	[TeliPhoneNo] [varchar](20) NULL,
	[PhoneNo] [varchar](20) NULL,
	[FaxNo] [varchar](20) NULL,
	[VatNo] [varchar](20) NULL,
	[CDiscription] [varchar](max) NULL,
	[SaleInvoice] [varchar](50) NULL,
	[CLogo] [varchar](200) NULL,
	[ClogoReport] [bit] NULL,
	[Clogoprint] [bit] NULL,
	[Inventory] [bit] NULL,
	[Verification] [bit] NULL,
	[PrinterName] [varchar](200) NULL,
	[UseCreditCard] [varchar](20) NULL,
	[CardSettlement] [varchar](20) NULL,
	[SettlementTime] [varchar](20) NULL,
	[SerialKey] [varchar](50) NULL,
	[CompanyKey] [varchar](50) NULL,
	[SubscriptionStartDate] [datetime] NULL,
	[SubscriptionEndDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CompanyProfile] ON 

INSERT [dbo].[CompanyProfile] ([AutoId], [CompanyId], [CompanyName], [ContactName], [BillingAddress], [Country], [State], [City], [ZipCode], [EmailId], [Website], [TeliPhoneNo], [PhoneNo], [FaxNo], [VatNo], [CDiscription], [SaleInvoice], [CLogo], [ClogoReport], [Clogoprint], [Inventory], [Verification], [PrinterName], [UseCreditCard], [CardSettlement], [SettlementTime], [SerialKey], [CompanyKey], [SubscriptionStartDate], [SubscriptionEndDate]) VALUES (12, N'CMP100009', N'Arvind', N'', N'66 Middlesex Ave, Suite 205', N'USA', N'NJ', N'Iselin', N'08830', N'', N'', N'', N'', N'', N'', NULL, N'Excluding Tax', NULL, 0, 1, 0, 1, N'', N'No', NULL, NULL, N'22102310050710100806', N'1104617502', CAST(N'2023-05-22T19:12:44.023' AS DateTime), CAST(N'2023-08-20T19:12:44.023' AS DateTime))
SET IDENTITY_INSERT [dbo].[CompanyProfile] OFF
GO
