USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SKUUnitTotal]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Fun_SKUUnitTotal]
(
@AutoId int
)
returns decimal(18,3) 
as
begin

declare @result decimal(18,3)
Set @result=(Select SUM((Quantity*UnitPrice)-Discount) from SKUItemMaster where SKUAutoId=@AutoId)
return @result
end
GO
