USE [PW_POS]
GO
/****** Object:  Table [dbo].[TermConditionMaster]    Script Date: 6/30/2023 7:23:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TermConditionMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[Term] [varchar](max) NULL,
	[Type] [varchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[TermConditionMaster] ON 

INSERT [dbo].[TermConditionMaster] ([AutoId], [Term], [Type]) VALUES (4, N'Terms And Conditions', N'2')
INSERT [dbo].[TermConditionMaster] ([AutoId], [Term], [Type]) VALUES (3, N'Test1', N'1')
INSERT [dbo].[TermConditionMaster] ([AutoId], [Term], [Type]) VALUES (5, N'Test2', N'2')
INSERT [dbo].[TermConditionMaster] ([AutoId], [Term], [Type]) VALUES (6, N'Terms And Conditions', N'0')
INSERT [dbo].[TermConditionMaster] ([AutoId], [Term], [Type]) VALUES (7, N'test3', N'0')
INSERT [dbo].[TermConditionMaster] ([AutoId], [Term], [Type]) VALUES (8, N'test2', N'0')
INSERT [dbo].[TermConditionMaster] ([AutoId], [Term], [Type]) VALUES (9, N'test3', N'2')
SET IDENTITY_INSERT [dbo].[TermConditionMaster] OFF
GO
