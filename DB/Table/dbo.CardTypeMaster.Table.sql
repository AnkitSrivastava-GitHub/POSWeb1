USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[CardTypeMaster]    Script Date: 9/23/2023 4:36:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CardTypeMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CardTypeName] [varchar](100) NULL,
	[Status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CardTypeMaster] ON 

INSERT [dbo].[CardTypeMaster] ([AutoId], [CardTypeName], [Status]) VALUES (1, N'Amex Card', 1)
INSERT [dbo].[CardTypeMaster] ([AutoId], [CardTypeName], [Status]) VALUES (2, N'Visa Card', 1)
INSERT [dbo].[CardTypeMaster] ([AutoId], [CardTypeName], [Status]) VALUES (3, N'Master Card', 1)
SET IDENTITY_INSERT [dbo].[CardTypeMaster] OFF
GO
