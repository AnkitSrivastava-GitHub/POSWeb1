USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[tbl_SecurityPinMaster]    Script Date: 7/31/2023 7:58:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SecurityPinMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[SecurityPin] [varchar](50) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_tbl_SecurityPinMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tbl_SecurityPinMaster] ON 

INSERT [dbo].[tbl_SecurityPinMaster] ([AutoId], [UserId], [SecurityPin], [Status]) VALUES (1, 3, N'1234', 1)
SET IDENTITY_INSERT [dbo].[tbl_SecurityPinMaster] OFF
GO
