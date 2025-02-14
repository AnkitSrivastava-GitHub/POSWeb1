USE [PW_POS]
GO
/****** Object:  Table [dbo].[BalanceMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BalanceMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](50) NOT NULL,
	[TerminalAutoId] [int] NOT NULL,
	[OpeningBalance] [decimal](18, 2) NULL,
	[ClosingBalance] [decimal](18, 2) NULL,
	[Mode] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[ActualBalance] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[BalanceMaster] ON 

INSERT [dbo].[BalanceMaster] ([AutoId], [UserId], [TerminalAutoId], [OpeningBalance], [ClosingBalance], [Mode], [CreatedDate], [UpdatedDate], [ActualBalance]) VALUES (1, N'EMP100001', 1, CAST(0.00 AS Decimal(18, 2)), CAST(239.28 AS Decimal(18, 2)), N'LogOut', CAST(N'2023-06-06T13:40:47.173' AS DateTime), CAST(N'2023-06-12T11:45:18.850' AS DateTime), CAST(239.28 AS Decimal(18, 2)))
INSERT [dbo].[BalanceMaster] ([AutoId], [UserId], [TerminalAutoId], [OpeningBalance], [ClosingBalance], [Mode], [CreatedDate], [UpdatedDate], [ActualBalance]) VALUES (2, N'EMP100001', 1, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'LogOut', CAST(N'2023-06-06T19:19:52.550' AS DateTime), CAST(N'2023-06-06T19:30:51.303' AS DateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[BalanceMaster] ([AutoId], [UserId], [TerminalAutoId], [OpeningBalance], [ClosingBalance], [Mode], [CreatedDate], [UpdatedDate], [ActualBalance]) VALUES (3, N'EMP100001', 1, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'LogOut', CAST(N'2023-06-06T19:33:52.293' AS DateTime), CAST(N'2023-06-06T19:39:39.197' AS DateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[BalanceMaster] ([AutoId], [UserId], [TerminalAutoId], [OpeningBalance], [ClosingBalance], [Mode], [CreatedDate], [UpdatedDate], [ActualBalance]) VALUES (4, N'EMP100001', 1, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'LogOut', CAST(N'2023-06-06T19:56:57.583' AS DateTime), CAST(N'2023-06-06T20:35:48.673' AS DateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[BalanceMaster] ([AutoId], [UserId], [TerminalAutoId], [OpeningBalance], [ClosingBalance], [Mode], [CreatedDate], [UpdatedDate], [ActualBalance]) VALUES (5, N'EMP100001', 1, CAST(0.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(18, 2)), N'LogOut', CAST(N'2023-06-07T17:02:46.213' AS DateTime), CAST(N'2023-06-09T13:26:54.033' AS DateTime), CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[BalanceMaster] ([AutoId], [UserId], [TerminalAutoId], [OpeningBalance], [ClosingBalance], [Mode], [CreatedDate], [UpdatedDate], [ActualBalance]) VALUES (6, N'EMP100001', 1, CAST(0.00 AS Decimal(18, 2)), NULL, N'Login', CAST(N'2023-06-12T11:43:24.170' AS DateTime), NULL, CAST(0.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[BalanceMaster] OFF
GO
