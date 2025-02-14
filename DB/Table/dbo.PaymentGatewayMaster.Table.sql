USE [PW_POS]
GO
/****** Object:  Table [dbo].[PaymentGatewayMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentGatewayMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[DisplayName] [varchar](100) NULL,
	[Description] [nvarchar](max) NULL,
	[AccessKey] [nvarchar](100) NULL,
	[HashKey] [nvarchar](100) NULL,
	[TestMode] [bit] NULL,
	[creationDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
