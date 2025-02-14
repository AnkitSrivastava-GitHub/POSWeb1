USE [PW_POS]
GO
/****** Object:  Table [dbo].[OrderTypeMaster]    Script Date: 6/30/2023 7:23:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderTypeMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[OrderType] [varchar](100) NULL,
 CONSTRAINT [PK_OrderTypeMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[OrderTypeMaster] ON 

INSERT [dbo].[OrderTypeMaster] ([AutoId], [OrderType]) VALUES (1, N'Invoice Order')
INSERT [dbo].[OrderTypeMaster] ([AutoId], [OrderType]) VALUES (2, N'Purchage Order')
SET IDENTITY_INSERT [dbo].[OrderTypeMaster] OFF
GO
