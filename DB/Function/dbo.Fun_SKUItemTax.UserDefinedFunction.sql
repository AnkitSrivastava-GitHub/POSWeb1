USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SKUItemTax]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Fun_SKUItemTax]
(
@SKUItemAutoId int
)
returns decimal(18,3) 
as
begin
declare @result decimal(18,3)
--- For excluding Tax
Set @result=(Select ((sim.Quantity*sim.UnitPrice)-sim.Discount)* (tm.TaxPer/100) 
from SKUItemMaster sim 
inner join ProductMaster pm on pm.AutoId=SIM.ProductAutoId
inner join TaxMaster tm on tm.AutoId=pm.TaxAutoId
where sim.AutoId=@SKUItemAutoId)
return @result
end
GO
