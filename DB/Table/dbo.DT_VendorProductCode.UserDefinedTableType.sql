USE [pos101.priorpos.com]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_VendorProductCode]    Script Date: 10/24/2023 11:48:41 AM ******/
CREATE TYPE [dbo].[DT_VendorProductCode] AS TABLE(
	[VendorId] [int] NULL,
	[VendorProductCode] [varchar](50) NULL,
	[OtherVPC] [varchar](50) NULL
)
GO
