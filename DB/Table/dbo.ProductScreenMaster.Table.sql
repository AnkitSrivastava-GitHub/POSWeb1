USE [pos101.priorpos.com]
GO

/****** Object:  Table [dbo].[ProductScreenMaster]    Script Date: 10/31/2023 4:02:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProductScreenMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ScreenId] [int] NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK_ProductScreenMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


