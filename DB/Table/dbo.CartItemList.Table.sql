USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[CartItemList]    Script Date: 9/7/2023 6:11:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CartItemList](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[CartId] [int] NULL,
	[OrderNo] [varchar](15) NULL,
	[SKUId] [int] NULL,
	[Quantity] [int] NULL,
	[Barcode] [varchar](50) NULL,
	[SchemeId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
