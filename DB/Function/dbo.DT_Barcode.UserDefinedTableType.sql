USE [PW_POS]
GO
/****** Object:  UserDefinedTableType [dbo].[DT_Barcode]    Script Date: 6/16/2023 8:01:22 PM ******/
CREATE TYPE [dbo].[DT_Barcode] AS TABLE(
	[Barcode] [varchar](200) NULL
)
GO
