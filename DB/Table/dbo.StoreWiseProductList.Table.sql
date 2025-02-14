USE [pos101.priorpos.com]
GO
/****** Object:  Table [dbo].[StoreWiseProductList]    Script Date: 10/10/2023 4:46:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreWiseProductList](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NULL,
	[ProductId] [int] NULL,
	[Preferred_VendorId] [int] NULL,
	[IsFavourite] [int] NULL,
	[ImageName] [varchar](500) NULL,
	[ManageStock] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Status] [int] NULL,
	[IsDeleted] [int] NULL,
	[CreatedStoreId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
