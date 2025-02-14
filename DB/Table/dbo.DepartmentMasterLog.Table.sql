USE [PW_POS_Final]
GO
/****** Object:  Table [dbo].[DepartmentMasterLog]    Script Date: 9/28/2023 5:29:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DepartmentMasterLog](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [varchar](50) NULL,
	[DepartmentName] [varchar](50) NULL,
	[AgeRestrictionId] [int] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[Status] [int] NULL,
	[IsDeleted] [int] NULL,
	[ReferenceID] [int] NULL,
 CONSTRAINT [PK_DepartmentMasterLog] PRIMARY KEY CLUSTERED 
(
	[AutoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
