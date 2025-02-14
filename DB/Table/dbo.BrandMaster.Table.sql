USE [PW_POS]
GO
/****** Object:  Table [dbo].[BrandMaster]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BrandMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[BrandId] [varchar](50) NOT NULL,
	[BrandName] [varchar](100) NULL,
	[Status] [int] NULL,
	[APIStatus] [int] NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[IsDeleted] [int] NULL,
 CONSTRAINT [PK_BrandMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[BrandMaster] ON 

INSERT [dbo].[BrandMaster] ([AutoId], [BrandId], [BrandName], [Status], [APIStatus], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted]) VALUES (8350, N'BRN101385', N'Brand', 1, 1, N'1', CAST(N'2023-06-06T19:35:45.323' AS DateTime), N'1', CAST(N'2023-06-06T19:35:45.323' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[BrandMaster] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_BrandMaster]    Script Date: 6/16/2023 7:56:29 PM ******/
ALTER TABLE [dbo].[BrandMaster] ADD  CONSTRAINT [IX_BrandMaster] UNIQUE NONCLUSTERED 
(
	[BrandId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
