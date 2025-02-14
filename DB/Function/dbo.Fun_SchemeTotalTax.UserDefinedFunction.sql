USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SchemeTotalTax]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create function [dbo].[Fun_SchemeTotalTax]
(
@AutoId int
)
returns decimal(18,3) 
as
begin

declare @result decimal(18,3)
Set @result=(Select SUM(Tax) from SchemeItemMaster where SchemeAutoId=@AutoId)
return @result
end
GO
