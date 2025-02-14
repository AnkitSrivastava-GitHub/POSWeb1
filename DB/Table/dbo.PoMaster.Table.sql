USE [PW_POS]
GO
/****** Object:  Table [dbo].[PoMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PoMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[PoNumber] [varchar](50) NULL,
	[PoDate] [datetime] NULL,
	[VendorId] [varchar](50) NULL,
	[ReMark] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[Status] [varchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
