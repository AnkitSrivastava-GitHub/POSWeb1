USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SKUItemTotal]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Fun_SKUItemTotal]
(
@SKUItemAutoId int
)
returns decimal(18,3) 
as
begin
declare @result decimal(18,3)
Set @result=(Select (UnitPrice * Quantity)-Discount + Tax from SKUItemMaster where AutoId=@SKUItemAutoId)
return @result
end
GO
