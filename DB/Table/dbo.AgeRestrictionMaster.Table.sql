USE [PW_POS]
GO
/****** Object:  Table [dbo].[AgeRestrictionMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AgeRestrictionMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[AgeRestrictionName] [varchar](100) NULL,
	[Age] [int] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AgeRestrictionMaster] ON 

INSERT [dbo].[AgeRestrictionMaster] ([AutoId], [AgeRestrictionName], [Age]) VALUES (8, N'18+', 18)
INSERT [dbo].[AgeRestrictionMaster] ([AutoId], [AgeRestrictionName], [Age]) VALUES (31, N'No', 0)
SET IDENTITY_INSERT [dbo].[AgeRestrictionMaster] OFF
GO
