USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_CancelLeaveList]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_CancelLeaveList] AS TABLE(
	[LeaveAutoId] [int] NULL,
	[LeaveStatus] [varchar](50) NULL
)
GO
