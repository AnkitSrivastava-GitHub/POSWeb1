USE [PW_POS]
GO
/****** Object:  Table [dbo].[TerminalMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TerminalMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[TerminalId] [varchar](50) NOT NULL,
	[TerminalName] [varchar](100) NULL,
	[TerminalAddress] [varchar](500) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[TerminalMaster] ON 

INSERT [dbo].[TerminalMaster] ([AutoId], [TerminalId], [TerminalName], [TerminalAddress]) VALUES (1, N'Te100001', N'Terminal 1', NULL)
SET IDENTITY_INSERT [dbo].[TerminalMaster] OFF
GO
