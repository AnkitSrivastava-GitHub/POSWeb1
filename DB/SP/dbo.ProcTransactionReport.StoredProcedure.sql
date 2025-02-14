USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcTransactionReport]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   PROCEDURE [dbo].[ProcTransactionReport]
@Opcode int= null,
@StartDate datetime=null,
@EndDate datetime=null,
@PaymentMode varchar(25)=null,
@Who varchar(25)=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
BEGIN
BEGIN TRY
If @Opcode=41
BEGIN
   Select *  into #temp41 from 
  (Select convert(date,InvoiceDate) as Date, 'Sale' as Type, PaymentMethod, sum(Tax) as Tax, sum(Total) as Total, isnull(CardType,'') as CardType, 1 as Seq
  --case when CardType='' then 'Cash' else CardType end as CardType    
  from InvoiceMaster
  where Status=1 and  (@PaymentMode is null or @PaymentMode='All'  or PaymentMethod=@PaymentMode)
   and (@StartDate is null or @StartDate='' or @EndDate is null or @EndDate=''  or  convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate))
  group by  convert(date,InvoiceDate), PaymentMethod, CardType
  union 
  Select convert(date,UpdateDate) as Date, 'Return' as Type, PaymentMethod,(-1)*sum(Tax) as Tax, (-1)*sum(Total) as Total, isnull(CardType,'') as CardType, 2 as Seq
  --case when CardType='' then 'Cash' else CardType end as CardType    
  from InvoiceMaster
  where Status=0 and  (@PaymentMode is null or @PaymentMode='All'  or PaymentMethod=@PaymentMode)
   and (@StartDate is null or @StartDate='' or @EndDate is null or @EndDate=''  or  convert(date,InvoiceDate) between convert(date,@StartDate) and convert(date,@EndDate))
  group by  convert(date,UpdateDate), PaymentMethod, CardType) as t
  order by Date desc, Seq asc

   Select Date, PaymentMethod, CardType, convert(decimal(18,2),sum(Tax)) as Tax, convert(decimal(18,2),sum(Total)) as Total from #temp41 
   group by Date, PaymentMethod, CardType

  SET @isException=0
END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
END
GO
