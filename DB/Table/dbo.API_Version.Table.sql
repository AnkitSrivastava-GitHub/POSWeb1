
CREATE TABLE [dbo].[API_Version](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[Version] [varchar](50) NULL,
	[Status] [int] NULL,
	[ExpiryDate] [date] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[API_Version] ON 

INSERT [dbo].[API_Version] ([AutoId], [Version], [Status], [ExpiryDate]) VALUES (1, N'1.1(22)', 0, NULL)
INSERT [dbo].[API_Version] ([AutoId], [Version], [Status], [ExpiryDate]) VALUES (2, N'1.1(23)', 0, NULL)
INSERT [dbo].[API_Version] ([AutoId], [Version], [Status], [ExpiryDate]) VALUES (3, N'1.1(24)', 0, NULL)
INSERT [dbo].[API_Version] ([AutoId], [Version], [Status], [ExpiryDate]) VALUES (4, N'1.1(25)', 0, NULL)
INSERT [dbo].[API_Version] ([AutoId], [Version], [Status], [ExpiryDate]) VALUES (5, N'1.1(26)', 0, NULL)
INSERT [dbo].[API_Version] ([AutoId], [Version], [Status], [ExpiryDate]) VALUES (6, N'1.1(27)', 0, CAST(N'2023-01-12' AS Date))
INSERT [dbo].[API_Version] ([AutoId], [Version], [Status], [ExpiryDate]) VALUES (7, N'1.1(28)', 0, CAST(N'2023-03-09' AS Date))
INSERT [dbo].[API_Version] ([AutoId], [Version], [Status], [ExpiryDate]) VALUES (8, N'1.1(29)', 1, CAST(N'2023-03-30' AS Date))
SET IDENTITY_INSERT [dbo].[API_Version] OFF
GO
