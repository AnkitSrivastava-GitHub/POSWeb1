USE [PW_POS]
GO
/****** Object:  Table [dbo].[PaxSetting]    Script Date: 6/16/2023 7:56:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaxSetting](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[DeviceName] [varchar](100) NULL,
	[DestPort] [varchar](20) NULL,
	[DestIP] [varchar](20) NULL,
	[SerialPort] [varchar](20) NULL,
	[TimeOut] [varchar](20) NULL,
	[CommType] [varchar](20) NULL,
	[BaudRate] [varchar](20) NULL
) ON [PRIMARY]
GO
