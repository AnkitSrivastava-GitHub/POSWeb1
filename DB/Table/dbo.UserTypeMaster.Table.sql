USE [PW_POS]
GO
/****** Object:  Table [dbo].[UserTypeMaster]    Script Date: 6/23/2023 1:11:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserTypeMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[UserType] [varchar](50) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_UserTypeMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[UserTypeMaster] ON 

INSERT [dbo].[UserTypeMaster] ([AutoId], [UserType], [Status]) VALUES (1, N'Admin', 1)
INSERT [dbo].[UserTypeMaster] ([AutoId], [UserType], [Status]) VALUES (2, N'Cashier', 1)
SET IDENTITY_INSERT [dbo].[UserTypeMaster] OFF
GO
