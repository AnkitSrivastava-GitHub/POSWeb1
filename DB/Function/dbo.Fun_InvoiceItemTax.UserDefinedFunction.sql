
/****** Object:  UserDefinedFunction [dbo].[Fun_InvoiceItemTax]    Script Date: 6/16/2023 8:01:22 PM ******/

create or alter function [dbo].[Fun_InvoiceItemTax]
(
@AutoId int,
@StoreId int
)
returns decimal(18,3)
as
begin

declare @result decimal(18,3)
declare @InvoiceType varchar(20)=(Select SaleInvoice from CompanyProfile where AutoId=@StoreId)
if(@InvoiceType='Excluding Tax')
begin
   Set @result=(Select  (PUIM.ReceivedQty*PUIM.UnitPrice) * PUIM.TaxPer/100
   from PurchaseInvoiceMaster PIM
   inner join PurchaseItemMaster as PUIM on PUIM.InvoiceId=PIM.AutoId
   where PUIM.AutoId=@AutoId)
end
else
begin
   Set @result=(Select (PUIM.ReceivedQty*PUIM.UnitPrice) * PUIM.TaxPer/100-(PUIM.ReceivedQty*PUIM.UnitPrice) * PUIM.TaxPer/100
   from PurchaseInvoiceMaster PIM
   inner join PurchaseItemMaster as PUIM on PUIM.InvoiceId=PIM.AutoId
   where PUIM.AutoId=@AutoId)
end
return @result
end
GO
