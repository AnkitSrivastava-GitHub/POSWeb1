USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[TerminalLoginLog]    Script Date: 9/22/2023 1:39:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TerminalLoginLog](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[TerminalId] [int] NULL,
	[UserId] [int] NULL,
	[LoginTime] [datetime] NULL,
	[LogOutTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
