USE [PW_POS]
GO
/****** Object:  Table [dbo].[SecurityCode]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecurityCode](
	[AutoId] [int] NOT NULL,
	[SecurityCode] [nvarchar](20) NULL,
	[Status] [int] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[SecurityCode] ([AutoId], [SecurityCode], [Status]) VALUES (1, N'123', 1)
GO
