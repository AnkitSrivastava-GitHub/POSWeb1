USE [PW_POS]
GO
/****** Object:  Table [dbo].[NoSale]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoSale](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[TerminalId] [int] NULL,
	[OpenDate] [datetime] NULL,
	[OpenBy] [varchar](25) NULL
) ON [PRIMARY]
GO
