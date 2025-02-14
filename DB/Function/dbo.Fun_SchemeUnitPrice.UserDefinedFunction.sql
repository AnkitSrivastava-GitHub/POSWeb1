USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SchemeUnitPrice]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Fun_SchemeUnitPrice]
(
@AutoId int
)
returns decimal(18,2) 
as
begin
declare @result decimal(18,2)
set @result = (Select sum(UnitPrice*Quantity) from SchemeItemMaster where SchemeAutoId=@AutoId)
return @result
end
GO
