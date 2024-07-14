USE [pos201.priorpos.com]
GO

/****** Object:  Table [dbo].[BreakLog]    Script Date: 12/29/2023 10:58:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[BreakLog](
	[AutoId] [int] NOT NULL,
	[UserId] [int] NULL,
	[StoreId] [int] NULL,
	[TerminalId] [int] NULL,
	[ShiftId] [int] NULL,
	[BreakDateTime] [datetime] NULL,
 CONSTRAINT [PK_BreakLog] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


