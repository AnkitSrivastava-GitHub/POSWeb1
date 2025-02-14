USE [PW_POS]
GO
/****** Object:  Table [dbo].[UserLogInLogMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLogInLogMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](50) NULL,
	[LogInID] [nvarchar](50) NULL,
	[LogInDate] [datetime] NULL,
	[Status] [varchar](50) NULL,
	[Type] [varchar](25) NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[UserLogInLogMaster] ON 

INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (1, N'EMP100001', N'Admin', CAST(N'2023-06-06T13:40:47.157' AS DateTime), N'Success', N'Login')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (2, N'EMP100001', N'Admin', CAST(N'2023-06-06T16:40:00.017' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (3, N'EMP100001', N'Admin', CAST(N'2023-06-06T19:19:52.523' AS DateTime), N'Success', N'Login')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (4, N'EMP100001', N'Admin', CAST(N'2023-06-06T19:30:27.700' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (5, N'EMP100001', N'Admin', CAST(N'2023-06-06T19:33:52.273' AS DateTime), N'Success', N'Login')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (6, N'EMP100001', N'Admin', CAST(N'2023-06-06T19:34:20.413' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (7, N'EMP100001', N'Admin', CAST(N'2023-06-06T19:39:08.010' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (8, N'EMP100001', N'Admin', CAST(N'2023-06-06T19:56:57.567' AS DateTime), N'Success', N'Login')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (9, N'EMP100001', N'Admin', CAST(N'2023-06-06T20:04:49.563' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (10, N'EMP100001', N'Admin', CAST(N'2023-06-07T17:02:46.197' AS DateTime), N'Success', N'Login')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (11, N'EMP100001', N'Admin', CAST(N'2023-06-09T11:34:37.853' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (12, N'EMP100001', N'Admin', CAST(N'2023-06-09T11:39:59.180' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (13, N'EMP100001', N'Admin', CAST(N'2023-06-09T11:56:02.633' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (14, N'EMP100001', N'Admin', CAST(N'2023-06-12T11:43:24.150' AS DateTime), N'Success', N'Login')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (15, N'EMP100001', N'Admin', CAST(N'2023-06-13T19:39:59.020' AS DateTime), N'Success', N'Return')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (16, N'EMP100001', N'Admin', CAST(N'2023-06-14T13:44:59.687' AS DateTime), N'Failed', N'Already Login')
INSERT [dbo].[UserLogInLogMaster] ([AutoId], [UserId], [LogInID], [LogInDate], [Status], [Type]) VALUES (17, N'EMP100001', N'Admin', CAST(N'2023-06-14T13:45:44.550' AS DateTime), N'Failed', N'Already Login')
SET IDENTITY_INSERT [dbo].[UserLogInLogMaster] OFF
GO
