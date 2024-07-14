USE [pos101.priorpos.com]
GO

/****** Object:  Table [dbo].[SafeCash]    Script Date: 11/21/2023 7:07:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SafeCash](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[Mode] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Remark] [varchar](250) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [date] NULL,
	[Store] [int] NULL,
 CONSTRAINT [PK_SafeCash] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


