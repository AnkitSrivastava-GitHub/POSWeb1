USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[CouponMaster]    Script Date: 8/4/2023 6:53:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CouponMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CouponName] [varchar](200) NULL,
	[CouponCode] [varchar](200) NULL,
	[TermsAndDescription] [varchar](max) NULL,
	[CouponType] [int] NULL,
	[Discount] [decimal](18, 2) NULL,
	[CouponAmount] [decimal](18, 2) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Status] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
