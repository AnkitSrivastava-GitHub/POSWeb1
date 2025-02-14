USE [pos101.priorpos.com]
GO
/****** Object:  Table [dbo].[RoyaltyMaster]    Script Date: 11/28/2023 11:30:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoyaltyMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[AmtPerRoyaltyPoint] [decimal](18, 2) NULL,
	[MinOrderAmt] [decimal](18, 2) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Status] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
