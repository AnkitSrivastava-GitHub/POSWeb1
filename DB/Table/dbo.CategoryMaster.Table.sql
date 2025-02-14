USE [PW_POS]
GO
/****** Object:  Table [dbo].[CategoryMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[Categoryid] [varchar](50) NOT NULL,
	[CategoryName] [varchar](100) NULL,
	[Status] [int] NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[IsDeleted] [int] NULL,
	[APIStatus] [int] NULL,
 CONSTRAINT [PK_CategoryMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[CategoryMaster] ON 

INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9340, N'CAT101466', N'Ashtray', 1, N'1', CAST(N'2023-06-06T19:35:45.330' AS DateTime), N'1', CAST(N'2023-06-06T19:35:45.330' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9341, N'CAT101467', N'Candy', 1, N'1', CAST(N'2023-06-06T19:35:45.400' AS DateTime), N'1', CAST(N'2023-06-06T19:35:45.400' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9342, N'CAT101468', N'Canned', 1, N'1', CAST(N'2023-06-06T19:35:45.550' AS DateTime), N'1', CAST(N'2023-06-06T19:35:45.550' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9343, N'CAT101469', N'Cigarettes', 1, N'1', CAST(N'2023-06-06T19:35:45.603' AS DateTime), N'1', CAST(N'2023-06-06T19:35:45.603' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9344, N'CAT101470', N'CIGARS', 1, N'1', CAST(N'2023-06-06T19:35:46.687' AS DateTime), N'1', CAST(N'2023-06-06T19:35:46.687' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9345, N'CAT101471', N'Cleaning', 1, N'1', CAST(N'2023-06-06T19:35:47.490' AS DateTime), N'1', CAST(N'2023-06-06T19:35:47.490' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9346, N'CAT101472', N'delta 8/cbd', 1, N'1', CAST(N'2023-06-06T19:35:47.503' AS DateTime), N'1', CAST(N'2023-06-06T19:35:47.503' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9347, N'CAT101473', N'delta8/cbd', 1, N'1', CAST(N'2023-06-06T19:35:49.243' AS DateTime), N'1', CAST(N'2023-06-06T19:35:49.243' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9348, N'CAT101474', N'Disposable/vape products', 1, N'1', CAST(N'2023-06-06T19:35:49.917' AS DateTime), N'1', CAST(N'2023-06-06T19:35:49.917' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9349, N'CAT101475', N'Drinks', 1, N'1', CAST(N'2023-06-06T19:35:55.810' AS DateTime), N'1', CAST(N'2023-06-06T19:35:55.810' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9350, N'CAT101476', N'E-Liquid', 1, N'1', CAST(N'2023-06-06T19:35:55.967' AS DateTime), N'1', CAST(N'2023-06-06T19:35:55.967' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9351, N'CAT101477', N'GLASS', 1, N'1', CAST(N'2023-06-06T19:35:58.260' AS DateTime), N'1', CAST(N'2023-06-06T19:35:58.260' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9352, N'CAT101478', N'Grinder', 1, N'1', CAST(N'2023-06-06T19:35:58.477' AS DateTime), N'1', CAST(N'2023-06-06T19:35:58.477' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9353, N'CAT101479', N'Hemp', 1, N'1', CAST(N'2023-06-06T19:35:58.500' AS DateTime), N'1', CAST(N'2023-06-06T19:35:58.500' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9354, N'CAT101480', N'Hookah/hookah products', 1, N'1', CAST(N'2023-06-06T19:35:58.667' AS DateTime), N'1', CAST(N'2023-06-06T19:35:58.667' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9355, N'CAT101481', N'Household', 1, N'1', CAST(N'2023-06-06T19:35:58.850' AS DateTime), N'1', CAST(N'2023-06-06T19:35:58.850' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9356, N'CAT101482', N'Kratom', 1, N'1', CAST(N'2023-06-06T19:35:58.860' AS DateTime), N'1', CAST(N'2023-06-06T19:35:58.860' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9357, N'CAT101483', N'Lighter/torch', 1, N'1', CAST(N'2023-06-06T19:35:59.060' AS DateTime), N'1', CAST(N'2023-06-06T19:35:59.060' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9358, N'CAT101484', N'Misc.', 1, N'1', CAST(N'2023-06-06T19:35:59.483' AS DateTime), N'1', CAST(N'2023-06-06T19:35:59.483' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9359, N'CAT101485', N'Novelty/Accessories', 1, N'1', CAST(N'2023-06-06T19:36:00.143' AS DateTime), N'1', CAST(N'2023-06-06T19:36:00.143' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9360, N'CAT101486', N'Rolling paper/cone', 1, N'1', CAST(N'2023-06-06T19:36:00.650' AS DateTime), N'1', CAST(N'2023-06-06T19:36:00.650' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9361, N'CAT101487', N'Rolling papers/cone', 1, N'1', CAST(N'2023-06-06T19:36:00.863' AS DateTime), N'1', CAST(N'2023-06-06T19:36:00.863' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9362, N'CAT101488', N'Smoke odor', 1, N'1', CAST(N'2023-06-06T19:36:01.460' AS DateTime), N'1', CAST(N'2023-06-06T19:36:01.460' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9363, N'CAT101489', N'Snacks', 1, N'1', CAST(N'2023-06-06T19:36:01.723' AS DateTime), N'1', CAST(N'2023-06-06T19:36:01.723' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9364, N'CAT101490', N'Tabacco', 1, N'1', CAST(N'2023-06-06T19:36:01.740' AS DateTime), N'1', CAST(N'2023-06-06T19:36:01.740' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9365, N'CAT101491', N'Taxable', 1, N'1', CAST(N'2023-06-06T19:36:01.873' AS DateTime), N'1', CAST(N'2023-06-06T19:36:01.873' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9366, N'CAT101492', N'Tobacco', 1, N'1', CAST(N'2023-06-06T19:36:01.880' AS DateTime), N'1', CAST(N'2023-06-06T19:36:01.880' AS DateTime), 0, 1)
INSERT [dbo].[CategoryMaster] ([AutoId], [Categoryid], [CategoryName], [Status], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus]) VALUES (9367, N'CAT101493', N'Vitamins/Medicine', 1, N'1', CAST(N'2023-06-06T19:36:02.987' AS DateTime), N'1', CAST(N'2023-06-06T19:36:02.987' AS DateTime), 0, 1)
SET IDENTITY_INSERT [dbo].[CategoryMaster] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_CategoryMaster]    Script Date: 6/16/2023 7:56:29 PM ******/
ALTER TABLE [dbo].[CategoryMaster] ADD  CONSTRAINT [IX_CategoryMaster] UNIQUE NONCLUSTERED 
(
	[Categoryid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
