USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[DepartmentMaster]    Script Date: 9/28/2023 5:29:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DepartmentMaster](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [varchar](50) NULL,
	[DepartmentName] [varchar](50) NULL,
	[AgeRestrictionId] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[Status] [int] NULL,
	[IsDeleted] [int] NULL,
 CONSTRAINT [PK_DepartmentMaster] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
