USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcPrintInvoice]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProcPrintInvoice]
@Opcode int= null,
@InvoiceAutoId int=null,
@Who varchar(25)=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
BEGIN
BEGIN TRY
If @Opcode=41
BEGIN
   Select top 1 CompanyName, BillingAddress, State, City, Country, ZipCode, EmailId, Website, TeliPhoneNo, PhoneNo, Clogoprint,[CLogo], PrinterName  
   from CompanyProfile

   Select AutoId, InvoiceNo, convert(varchar(10),InvoiceDate,101) as IDate, PaymentMethod, 
   convert(decimal(18,2),(Total-Tax)) as SubTotal, convert(decimal(18,2),Tax) as Tax, convert(decimal(18,2),Total) as Total
   from InvoiceMaster 
   where AutoId=@InvoiceAutoId
   

   Select sm.SKUName, ism.Quantity, convert(decimal(18,2),(ism.Total-ism.Tax)/ism.Quantity) as UnitPrice, convert(decimal(18,2),ism.Tax) as Tax, convert(decimal(18,2),ism.Total) as Total
   from InvoiceSKUMaster ism
   inner join SKUMaster sm on ism.SKUId=sm.AutoId
   where InvoiceAutoId=@InvoiceAutoId

   Select * from TermConditionMaster where [Type]='Invoice'

 

   SET @isException=0
END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
END
GO
