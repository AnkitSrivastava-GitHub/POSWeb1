USE [pos101.priorpos.com]
GO
/****** Object:  Table [dbo].[EmployeeStoreList]    Script Date: 10/7/2023 7:35:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeStoreList](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NULL,
	[CompanyId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[EmployeeStoreList] ON 

INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (1, 6, 12, 1, CAST(N'2023-10-06T16:03:39.837' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (2, 6, 13, 1, CAST(N'2023-10-06T16:03:39.837' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (3, 6, 14, 1, CAST(N'2023-10-06T16:03:39.837' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (13, 7, 12, 1, CAST(N'2023-10-06T16:37:06.533' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (14, 7, 13, 1, CAST(N'2023-10-06T16:37:06.533' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (18, 3, 12, 1, CAST(N'2023-10-06T19:35:53.233' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (19, 3, 13, 1, CAST(N'2023-10-06T19:35:53.233' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (21, 4, 12, 1, CAST(N'2023-10-06T19:36:20.250' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (22, 5, 12, 1, CAST(N'2023-10-06T19:36:33.130' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (23, 5, 13, 1, CAST(N'2023-10-06T19:36:33.130' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (24, 5, 14, 1, CAST(N'2023-10-06T19:36:33.130' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (25, 1, 12, 1, CAST(N'2023-10-07T13:36:39.527' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (26, 1, 13, 1, CAST(N'2023-10-07T13:36:39.527' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (27, 1, 14, 1, CAST(N'2023-10-07T13:36:39.527' AS DateTime), 1)
INSERT [dbo].[EmployeeStoreList] ([AutoId], [EmployeeId], [CompanyId], [CreatedBy], [CreatedDate], [Status]) VALUES (32, 2, 14, 1, CAST(N'2023-10-07T17:58:33.030' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[EmployeeStoreList] OFF
GO
