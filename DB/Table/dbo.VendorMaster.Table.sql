USE [PW_POS]
GO
/****** Object:  Table [dbo].[VendorMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [varchar](50) NOT NULL,
	[VendorName] [varchar](100) NULL,
	[Address1] [varchar](max) NULL,
	[Address2] [varchar](max) NULL,
	[Country] [varchar](50) NULL,
	[City] [varchar](200) NULL,
	[State] [varchar](100) NULL,
	[Zipcode] [varchar](50) NULL,
	[PhoneNo] [varchar](15) NULL,
	[Emailid] [varchar](100) NULL,
	[MobileNo] [varchar](15) NULL,
	[FaxNo] [varchar](20) NULL,
	[Status] [int] NULL,
	[IsDeleted] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
