USE [PW_POS]
GO
/****** Object:  Table [dbo].[SerialKeyMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SerialKeyMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[SerialKey] [varchar](50) NULL,
	[UsedDate] [datetime] NULL,
	[SubscriptionDays] [int] NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SerialKeyMaster] ON 

INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (1, N'XYZ220230', CAST(N'2023-03-27T18:43:16.790' AS DateTime), 30)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (2, N'XYZ220230', CAST(N'2023-03-28T13:27:48.113' AS DateTime), 30)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (3, N'XYZ220230', CAST(N'2023-03-28T14:25:58.033' AS DateTime), 30)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (4, N'XYZ220230', CAST(N'2023-03-31T18:33:55.107' AS DateTime), 30)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (5, N'03512352041252512004', CAST(N'2023-04-03T14:33:11.937' AS DateTime), 30)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (6, N'03512352041252512004', CAST(N'2023-04-03T15:47:52.923' AS DateTime), 30)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (7, N'04222324041224222104', CAST(N'2023-04-06T11:44:44.693' AS DateTime), 30)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (8, N'03512341041241512004', CAST(N'2023-04-06T18:13:44.837' AS DateTime), 30)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (9, N'22102310050710100806', CAST(N'2023-05-22T19:12:44.200' AS DateTime), 90)
INSERT [dbo].[SerialKeyMaster] ([AutoId], [SerialKey], [UsedDate], [SubscriptionDays]) VALUES (10, N'10232355040155232704', CAST(N'2023-06-06T13:40:41.370' AS DateTime), 30)
SET IDENTITY_INSERT [dbo].[SerialKeyMaster] OFF
GO
