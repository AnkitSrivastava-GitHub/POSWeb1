USE [PW_POS]
GO
/****** Object:  Table [dbo].[PaymentMethod]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentMethod](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentType] [varchar](50) NULL,
	[PaymentCode] [varchar](10) NULL
) ON [PRIMARY]
GO
