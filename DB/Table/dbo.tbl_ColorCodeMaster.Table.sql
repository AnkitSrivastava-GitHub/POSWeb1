USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[tbl_ColorCodeMaster]    Script Date: 9/21/2023 4:47:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_ColorCodeMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[ElementName] [varchar](100) NULL,
	[ColorCode] [nvarchar](50) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_tbl_ColorCodeMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tbl_ColorCodeMaster] ON 

INSERT [dbo].[tbl_ColorCodeMaster] ([AutoId], [ElementName], [ColorCode], [Status]) VALUES (1, N'BG_ProductWithSignleUnit', N'#50C878', 1)
INSERT [dbo].[tbl_ColorCodeMaster] ([AutoId], [ElementName], [ColorCode], [Status]) VALUES (2, N'BG_SKU', N'#7FFF00', 1)
INSERT [dbo].[tbl_ColorCodeMaster] ([AutoId], [ElementName], [ColorCode], [Status]) VALUES (3, N'BG_ProductWithMultipleUnit', N'#29AB87', 1)
INSERT [dbo].[tbl_ColorCodeMaster] ([AutoId], [ElementName], [ColorCode], [Status]) VALUES (4, N'TEXT_ProductWithSignleUnit', N'white', 1)
INSERT [dbo].[tbl_ColorCodeMaster] ([AutoId], [ElementName], [ColorCode], [Status]) VALUES (5, N'TEXT_SKU', N'white', 1)
INSERT [dbo].[tbl_ColorCodeMaster] ([AutoId], [ElementName], [ColorCode], [Status]) VALUES (6, N'TEXT_ProductWithMultipleUnit', N'white', 1)
INSERT [dbo].[tbl_ColorCodeMaster] ([AutoId], [ElementName], [ColorCode], [Status]) VALUES (7, N'BG_Error', N'#aeaeae', 1)
INSERT [dbo].[tbl_ColorCodeMaster] ([AutoId], [ElementName], [ColorCode], [Status]) VALUES (8, N'TEXT_Error', N'black', 1)
SET IDENTITY_INSERT [dbo].[tbl_ColorCodeMaster] OFF
GO
