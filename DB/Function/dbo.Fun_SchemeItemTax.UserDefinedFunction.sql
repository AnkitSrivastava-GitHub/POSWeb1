USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SchemeItemTax]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create function [dbo].[Fun_SchemeItemTax]
(
@AutoId int
)
returns decimal(18,3) 
as
begin

declare @result decimal(18,3)
declare @InvoiceType varchar(20)=(Select SaleInvoice from CompanyProfile)
if(@InvoiceType='Excluding Tax')
begin
    Set @result=(Select  (sim.UnitPrice*sim.Quantity) * case when PTM.TaxAutoId=0 then 0 else TM.TaxPer end/100 
    from SchemeItemMaster SIM
	inner join PackingTypeMaster PTM on PTM.AutoId=SIM.PackingAutoId
	left join TaxMaster TM on TM.AutoId=PTM.TaxAutoId
	where SIM.AutoId=@AutoId)
end
else
begin
    Set @result=(Select (SIM.Quantity*SIM.UnitPrice)-((SIM.Quantity*SIM.UnitPrice) *100)/
	(100 + case when PTM.TaxAutoId=0 then 0 else TM.TaxPer end)
    from SchemeItemMaster SIM
	inner join PackingTypeMaster PTM on PTM.AutoId=SIM.PackingAutoId
	left join TaxMaster TM on TM.AutoId=PTM.TaxAutoId
	where SIM.AutoId=@AutoId)
end
return @result
end
GO
