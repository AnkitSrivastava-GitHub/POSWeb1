
create or alter function [dbo].[Fun_InvoiceItemTotal]
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
    Set @result=(Select ((ReceivedQty*UnitPrice) + Tax) from PurchaseItemMaster where AutoId=@AutoId)
end
else
begin 
    Set @result=(Select(ReceivedQty*UnitPrice)  from PurchaseItemMaster where AutoId=@AutoId)
end
return @result
end
GO
