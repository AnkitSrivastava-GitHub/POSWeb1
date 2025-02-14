USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SaleInvoiceTotal]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[Fun_SaleInvoiceTotal]
(
@AutoId int
)
returns decimal(18,3) 
as
begin
declare @result decimal(18,3)

Set @result=(Select  Sum(Total) from InvoiceSKUMaster where InvoiceAutoId=@AutoId)-isnull((Select Discount from InvoiceMaster where AutoId=@AutoId),0)

return @result
end
GO
