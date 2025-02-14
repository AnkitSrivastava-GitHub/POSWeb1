USE [PW_POS]
GO
/****** Object:  Table [dbo].[CustomerMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [varchar](20) NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[DOB] [varchar](20) NULL,
	[MobileNo] [varchar](20) NULL,
	[PhoneNo] [varchar](20) NULL,
	[EmailId] [varchar](100) NULL,
	[Address] [varchar](200) NULL,
	[State] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[Country] [varchar](100) NULL,
	[ZipCode] [varchar](20) NULL,
	[Status] [int] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CustomerMaster] ON 

INSERT [dbo].[CustomerMaster] ([AutoId], [CustomerId], [FirstName], [LastName], [DOB], [MobileNo], [PhoneNo], [EmailId], [Address], [State], [City], [Country], [ZipCode], [Status]) VALUES (1, N'C100001', N'Walk In', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1)
SET IDENTITY_INSERT [dbo].[CustomerMaster] OFF
GO
