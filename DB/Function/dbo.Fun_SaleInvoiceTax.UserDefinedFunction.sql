USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SaleInvoiceTax]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create function [dbo].[Fun_SaleInvoiceTax]
(
@AutoId int
)
returns decimal(18,3) 
as
begin
declare @result decimal(18,3)

Set @result=(Select  Sum(Tax)  from InvoiceSKUMaster where InvoiceAutoId=@AutoId)

return @result
end
GO
