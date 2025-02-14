USE [pos101.priorpos.com]
GO
/****** Object:  Table [dbo].[VendorProductCodeList]    Script Date: 10/24/2023 11:48:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorProductCodeList](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NULL,
	[ProductId] [int] NULL,
	[ProductStoreId] [int] NULL,
	[VendorId] [int] NULL,
	[VendorProductCode] [varchar](50) NULL,
	[OtherVPC] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedByStoreId] [int] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK__VendorPr__6B2329058552D187] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
