USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[API_ActivityLog]    Script Date: 8/3/2023 4:20:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[API_ActivityLog](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[APIName] [varchar](100) NULL,
	[AccessToken] [varchar](50) NULL,
	[Hashkey] [varchar](50) NULL,
	[DeviceId] [varchar](100) NULL,
	[LatLong] [varchar](100) NULL,
	[AppVersion] [varchar](20) NULL,
	[RequestSource] [varchar](20) NULL,
	[UserId] [int] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
