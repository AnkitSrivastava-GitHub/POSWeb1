USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SchemeItemTotal]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[Fun_SchemeItemTotal]
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
    Set @result=(Select (UnitPrice * Quantity) + Tax from SchemeItemMaster where AutoId=@AutoId)
end
else
begin 
    Set @result=(Select (UnitPrice * Quantity)  from SchemeItemMaster where AutoId=@AutoId)
end
return @result
end
GO
