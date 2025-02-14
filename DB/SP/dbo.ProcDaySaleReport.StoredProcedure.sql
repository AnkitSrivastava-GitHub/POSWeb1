USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcDaySaleReport]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ProcDaySaleReport]
@Opcode int= null,
@StartDate datetime=null,
@EndDate datetime=null,
@Who varchar(25)=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
BEGIN
BEGIN TRY
If @Opcode=41
BEGIN
   Select top 1 CompanyName, BillingAddress, State, City, Country, ZipCode, EmailId, Website, TeliPhoneNo, PhoneNo, Clogoprint,[CLogo]  from CompanyProfile

   Select convert(varchar(10),@StartDate,101) as StartDate, 
   convert(varchar(10),@EndDate,101) as EndDate,  
   convert(varchar(10),GETDATE(),101)+' ' +convert(varchar(5),GETDATE(),108) as PrintDate 

   Select isnull((Select sum(isnull(Total-Tax,0)) from InvoiceMaster
   where Tax=0 and convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate)),0) as NonTaxableSale, isnull((Select sum(isnull(Total-Tax,0)) from InvoiceMaster 
   where Tax>0 and convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate)),0) as TaxableSale, isnull((Select sum(isnull(Discount,0)) as Discount from InvoiceMaster where convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate)),0) as Discount

   Select convert(decimal(18,3),isnull(TaxPer,0)) as TaxPer, convert(decimal(18,2),sum(iim.Tax)) as Tax 
   from InvoiceItemMaster iim
   inner join InvoiceSKUMaster ism on iim.SKUAutoId=ism.AutoId
   inner join InvoiceMaster im on im.AutoId=ism.InvoiceAutoId
   where convert(date,im.InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate) 
   group by isnull(TaxPer,0)

   Select PaymentMethod, Count(1) as No_Count, sum(Total) as Total 
   from InvoiceMaster 
   where convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate) 
   group by PaymentMethod

    Select (udm.FirstName+' '+udm.LastName) as EName, sum(Total) as Total 
   from InvoiceMaster im
   inner join UserDetailMaster udm on udm.Userid=im.UserId
   where convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate) 
   group by udm.FirstName, udm.LastName


   Select COUNT(1) TransCount, sum(Total) as Total from InvoiceMaster  
   where convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate) 

   Select COUNT(1) TransCount, isnull(sum(Total),0) as Total from InvoiceMaster 
   where Status=0 and
   convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate) 

 
   Select pm.ProductName, sum((iim.Total-iim.Tax)*ism.Quantity) as Total from  InvoiceItemMaster iim
   inner join InvoiceSKUMaster ism on iim.SKUAutoId=ism.AutoId
   inner join InvoiceMaster im on im.AutoId=ism.InvoiceAutoId
   inner join ProductMaster pm on pm.AutoId=iim.ProductId
   where convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate)
   group by pm.ProductName

   Select COUNT(1) TransCount from DraftMaster 
   where Type='NO Sale' and
   convert(date,DraftDate) between convert(date,@StartDate) and convert(date,@EndDate) 

   Select  sum(isnull(OpeningBalance,0)) as OpeningBalance, sum(isnull(ClosingBalance,0)) as ClosingBalance from BalanceMaster
   where convert(date,CreatedDate) between convert(date,@StartDate) and convert(date,@EndDate) 

   SET @isException=0
END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
END

GO
