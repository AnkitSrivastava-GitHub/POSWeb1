
Alter   proc [dbo].[Proc_ZReport]
@Opcode int=0,
@AutoId int=null,
@TerminalId int=null,
@ShiftId int=null,
@Who int=null,
@StoreId int=null,
@ShiftName varchar(100)=null,
@ZReportDate datetime=null,
@isException bit out,
@exceptionMessage varchar(max) out
as
begin
begin try
       SET @isException=0 
       SET @exceptionMessage='Success'
       if(@Opcode=41)
       begin
         begin try
	       begin tran
		           select * into #TempCatSale from(
				   select PM.CategoryId, CM.CategoryName CategoryName,
                   sum(isnull(IIM.ProductTotalSoldQty,0)) TotalCategoryWiseProductCnt,--sum(isnull(IIM.Quantity,1)*isnull(ISM.Quantity,1)),
                   sum(isnull(IIM.Total,1)*isnull(ISM.Quantity,1))TotalAmt
			       --into #Temp42
                   from InvoiceSKUMaster ISM
                   Inner join InvoiceItemMaster IIM on IIM.SKUAutoId=ISM.AutoId
                   inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
                   -- inner join SKUItemMaster SIM on SIM.SKUAutoId=ISM.SKUId
                   inner join ProductMaster PM on PM.AutoId=IIM.ProductId
                   inner join CategoryMaster CM on CM.AutoId=PM.CategoryId
                   --inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=@StoreId
                   where PM.ProductName not like '%Lottery%' and
			       IM.StoreId=@StoreId
                   and(@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId) 
                   and convert(date,IM.InvoiceDate)=convert(date,@ZReportDate)
				   and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
                   group by PM.CategoryId, CM.CategoryName
			       --order by CM.CategoryName asc

				   --union

				   --select 0 CategoryId ,ISM.SKUName CategoryName,sum(ISM.Quantity)totalUnitQty,isnull(sum(isnull(ISM.Total,0)),0)TotalCateSaleAmt
				   --from InvoiceSKUMaster ISM
				   --inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
				   --where ISM.SKUName like '%Lottery Sale%' and Im.StoreId=@StoreId
				   --and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId) 
				   --and convert(date,IM.InvoiceDate)=convert(date,@ZReportDate)
				   --and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
				   --group by ISM.SKUName
				   
				   union

			       select '0','Gift Card' CategoryName,count(1)totalUnitQty,sum(ISM.Total)TotalCateSaleAmt from 
                   InvoiceSKUMaster ISM
                   inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
                   where SKUName like '%Gift Card%' and IM.StoreId=@StoreId
			      and(@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId)
                   and (convert(date,IM.InvoiceDate)=convert(date,@ZReportDate))
			       and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
				   )t

				   select * into #TempLotterySales from(
	               select ROW_NUMBER() over(order by convert(int,replace(PM.ProductSizeName,'Lottery $','')) )RowNo,
				   PM.ProductSizeName as ProductName, --count(1)LotterySaleQty,
				   sum(ISM.Quantity)LotterySaleQty,
                   sum(isnull(IIM.Total,1)*isnull(ISM.Quantity,1))TotalLotterySale
                   from InvoiceSKUMaster ISM
                   Inner join InvoiceItemMaster IIM on IIM.SKUAutoId=ISM.AutoId
                   inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
                   --inner join SKUItemMaster SIM on SIM.SKUAutoId=ISM.SKUId
                   inner join ProductMaster PM on PM.AutoId=IIM.ProductId
                   inner join CategoryMaster CM on CM.AutoId=PM.CategoryId
                   --inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=3
                   where PM.ProductName like '%Lottery%' and Im.StoreId=@StoreId 
				   and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
                   and convert(date,IM.InvoiceDate)=convert(date,@ZReportDate)
				   and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
                   group by PM.ProductSizeName
			       
                   union 
                   
                   select 50 RowNo, ISM.SKUName ProductName,
				   SUM(ISM.Quantity)LotterySaleQty,
				   isnull(sum(isnull(ISM.Total,0)),0)TotalLotterySale
                   from InvoiceSKUMaster ISM
                   inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
                   where ISM.SKUName like '%Lottery Sale%' and Im.StoreId=@StoreId 
				   and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
                   and convert(date,IM.InvoiceDate)=convert(date,@ZReportDate)
				   and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
                   group by ISM.SKUName
			       ) t3

				   select * into #TempTrasactionDetails from (
				    select ITD.PaymentMode,count(IM.AutoId)TrsCnt,Sum(ITD.Amount)TrsTotalAMt from 
                    InvoiceTransactionDetail ITD
                    inner join InvoiceMaster IM on IM.AutoId=ITD.InvoiceAutoId
			        and IM.StoreId=@StoreId and isnull(ITD.Amount,0)>0 
                    and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
                    and convert(date,IM.InvoiceDate)=convert(date,@ZReportDate)
					and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
                    group by ITD.PaymentMode
                   
                    union

                    select 'Discount' PaymentMode,count(IM.AutoId),isnull(sum(isnull(Discount,0)),0) PaymentMethodwiseTotalAmount
                    from InvoiceMaster IM
                    where Discount>0
                    and StoreId=@StoreId
                    and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
                    and convert(date,IM.InvoiceDate)=convert(date,@ZReportDate)
					and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
				   
				   )t1

				   select * into #TempTaxBreakOut from (
				   select TaxPer,SUM(isnull(IM.Tax,0)*ISM.Quantity) TaxAmt 
                   from InvoiceItemMaster IM
                   inner join InvoiceSKUMaster ISM on ISM.AutoId=IM.SKUAutoId
                   inner join InvoiceMaster INM on INM.AutoId=ISM.InvoiceAutoId
                   where  INM.StoreId=@StoreId and
				   CONVERT(date,INM.InvoiceDate)=CONVERT(date,@ZReportDate) and TaxPer!=0
				   and(@TerminalId is null or @TerminalId=0 or INM.TerminalId=@TerminalId) 
				   and (@ShiftId is null or @ShiftId=0 or INM.ShiftAutoId=@ShiftId)
                   group By TaxPer
				   )t2

				   select * into #TempPayoutList from (
				   select PTM.PayoutType+' Payout' PayoutName,PM.PayoutMode,count(1)NoOfPayouts, isnull(sum(isnull(PM.Amount,0)),0)TotalPayout
		           from PayoutMaster PM
		           inner join PayoutTypeMaster PTM on PTM.AutoId=PM.PayoutType
		           where PM.PayoutMode='Cash'
		           and PM.CompanyId=@StoreId 
                   and (@TerminalId is null or @TerminalId=0 or isnull(PM.Terminal,0)=@TerminalId )
                   and (convert(date,isnull(PM.PayoutDate,GETDATE()))=convert(date,@ZReportDate))
		           and (@ShiftId is null or @ShiftId=0 or PM.ShiftId=@ShiftId)
		           group by PTM.PayoutType+' Payout',PM.PayoutMode
				   --order by PayoutName
				   union

				   select  'Lottery Payout' PayoutName,'Cash' PayoutMode,count(1)NoOfPayouts, isnull(sum(isnull(ISM.Total,0)),0)*-1 TotalPayout
		           from InvoiceSKUMaster ISM
                   inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
                   where ISM.SKUName like '%Lottery Payout%'
                   and Im.StoreId=@StoreId 
                   and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
                   and (convert(date,IM.InvoiceDate)=convert(date,@ZReportDate))
		           and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
                   group by ISM.SKUName
				  
				   )t4

		           ------------------------COMPANY DETAILS-------------------------------------
				   if(isnull(@ShiftId,0)=0)
				   begin
				      set @ShiftName='All Shift'
				   end
				   else
				   begin
				     set @ShiftName=(select FirstName+isnull(' '+LastName,'') +'('+format(BM.CreatedDate,'hh:mm tt')+' - '+(case when ClosingBalance is null then format(getdate(),'hh:mm tt') else format(BM.UpdatedDate,'hh:mm tt') end)+')' shiftName
		             from BalanceMaster BM
		             inner join UserDetailMaster UDM on UDM.UserAutoId=BM.UserId
		             where TerminalAutoId=@TerminalId and StoreId=@StoreId
		             and convert(date,BM.CreatedDate)=convert(date,@ZReportDate)
		             and (@ShiftId is null or @ShiftId=0 or BM.AutoId=@ShiftId))
				   end

                   select (isnull((
				   select top 1 
				   (Case when isnull(IPD.StoreName,'')!='' then IPD.StoreName else CompanyName end) CompanyName, 
				   (Case when isnull(IPD.BillingAddress,'')!='' then IPD.BillingAddress else CP.BillingAddress end)BillingAddress, 
                   (Case when isnull(IPD.BillingAddress,'')!='' then (IPD.City+', '+IPD.State+' - '+ convert(varchar(10),IPD.ZipCode)) else (CP.City+', '+CP.State+' - '+ convert(varchar(10),CP.ZipCode)) end) AddressLine2,
				   format(getdate(),'MM/dd/yyyy hh:mm tt')CurrentTime,
				   isnull((select TerminalName+isnull('<br/>'+@ShiftName,'')  from TerminalMaster where AutoId=@TerminalId),'')TerminalName
				   from CompanyProfile CP
				   left join InvoicePrintDetails IPD on IPD.StoreId=CP.AutoId
				   
				   where CP.AutoId=@StoreId 
				   for json path,include_null_values),'')
				   ) ComapnyDetail,
                   ---------------------SALES AND TAXES SUMMARY-----------------------------------
                   (isnull((

				   select 
				   count(1) NoOfTransactions,
				   convert(decimal(18,2),sum(convert(decimal(18,2),(Total-Tax)))) TotalWithoutTax,
				   convert(decimal(18,2),sum(convert(decimal(18,2),(Tax))))TotalTax,
                   convert(decimal(18,2),sum(convert(decimal(18,2),(Total)))) TotalWithTax 
                   from InvoiceMaster  IM
                   where StoreId=@StoreId and
				   CONVERT(date,InvoiceDate)=CONVERT(date,@ZReportDate) 
				   and(@TerminalId is null or @TerminalId=0 or TerminalId=@TerminalId) 
				   and (@ShiftId is null or @ShiftId=0 or ShiftAutoId=@ShiftId)
                   group by CONVERT(date,InvoiceDate)
                   order by CONVERT(date,InvoiceDate) desc
                   for json path,include_null_values),'[]')
				   ) SalesAndTaxesSummary,
				   ---------------------CATEGORY WISE SALE------------------------------------
                   (isnull((
				   select CategoryId,CategoryName,TotalCategoryWiseProductCnt,TotalAmt
				   from #TempCatSale
				   where TotalAmt!=0
				   order by CategoryName asc
				   for json path,include_null_values),'[]')
				   ) SaleCategories,
				   ---------------------Lottery SALE------------------------------------
				   (isnull((
				   select ProductName LotteryName, LotterySaleQty,TotalLotterySale
				   from #TempLotterySales
				   order by RowNo asc
				   for json path,include_null_values),'[]')
				   ) LotterySaleCategories,

				   -----------------------TOTAL NET SALES----------------------------------

				   (isnull((
				   select isnull(sum(isnull(TotalAmt,0)),0)TotalWithTax from #TempCatSale
                   for json path,include_null_values),'[]')
				   ) TotalNetSales,

				   -----------------------TOTAL Lottery SALES----------------------------------

				   (isnull((
				   select isnull(sum(isnull(TotalLotterySale,0)),0)TotalLotterySaleAmt from #TempLotterySales
                   for json path,include_null_values),'[]')
				   ) TotalLotterySalesAmt,

				   ---------------------PAYOUT Report------------------------------------
				   (isnull((
				   select PayoutName,PayoutMode, NoOfPayouts,TotalPayout
				   from #TempPayoutList
				   where  PayoutName!='Lottery Payout'
				   order by PayoutName asc
				   for json path,include_null_values),'[]')
				   ) PayoutReport,

				   -----------------------PAYOUT Report------------------------------------
				   (isnull((
				   select isnull(sum(isnull(TotalPayout,0)),0) TotalPayoutAmt
				   from #TempPayoutList
				   where  PayoutName!='Lottery Payout'
				   --order by PayoutName asc
				   
				   for json path,include_null_values),'[]')
				   ) TotalPayoutAmt,

				   -----------------------Lottery PAYOUT Report------------------------------------
				   (isnull((
				   select PayoutName,PayoutMode, NoOfPayouts,TotalPayout
				   from #TempPayoutList
				   where  PayoutName='Lottery Payout'
				   order by PayoutName asc
				   for json path,include_null_values),'[]')
				   ) LotteryPayoutReport,

                   ---------------------PAYMENT METHOD WISE TOTAL PAYMENT DETAILS--------------------
                   (isnull((

				    select PaymentMode PaymentMethod,isnull(sum(isnull(TrsTotalAMt,0)),0) TotalPaymentMethodWise 
					from #TempTrasactionDetails
					where PaymentMode in ('Cash','Credit Card')
					group by PaymentMode
				    for json path,include_null_values),'[]')
				   ) PaymentMethodDeatils,

				   ---------------------TOTAL PAYMENT DONE FROM ALL PAYEMENT METHODS--------------------
                   (isnull((

				   select isnull(sum(isnull(TrsTotalAMt,0)),0) TotalPaymentMethodWise 
				   from #TempTrasactionDetails
				   where PaymentMode in ('Cash','Credit Card')
				   for json path,include_null_values),'[]')
				   ) TotalAmtPaymentMethodWise,

                   ---------------------TOTAL DISCOUNT AMOUNT-------------------------------------
                   (isnull((
				    select PaymentMode PaymentMethod,TrsCnt CoupanCnt,isnull(sum(isnull(TrsTotalAMt,0)),0) TotalCoupanAmt 
					from #TempTrasactionDetails
					where PaymentMode not in ('Cash','Credit Card')
					group by PaymentMode,TrsCnt
				    for json path,include_null_values),'[]')
				   ) TotalDiscount,

				   (isnull((
				   select CTM.CardTypeName,isnull(sum(isnull(ITD.Amount,0)),0)CardTotal from 
                   InvoiceTransactionDetail ITD
                   inner join InvoiceMaster IM on Im.AutoId=ITD.InvoiceAutoId
                   inner join CardTypeMaster CTM on CTM.AutoId=ITD.CardType
                   where ITD.PaymentMode='Credit Card'
                   and StoreId=@StoreId
				   and CONVERT(date,InvoiceDate)=CONVERT(date,@ZReportDate)
				   and(@TerminalId is null or @TerminalId=0 or TerminalId=@TerminalId) 
				   and (@ShiftId is null or @ShiftId=0 or ShiftAutoId=@ShiftId)
                   group by CTM.CardTypeName
				   for json path,include_null_values),'[]')
				   ) CardBreakOut,

				   (isnull((
				   select isnull(sum(isnull(ITD.Amount,0)),0)CardTotal from 
                   InvoiceTransactionDetail ITD
                   inner join InvoiceMaster IM on Im.AutoId=ITD.InvoiceAutoId
                   inner join CardTypeMaster CTM on CTM.AutoId=ITD.CardType
                   where ITD.PaymentMode='Credit Card'
                   and StoreId=@StoreId
				   and CONVERT(date,InvoiceDate)=CONVERT(date,@ZReportDate)
				   and(@TerminalId is null or @TerminalId=0 or TerminalId=@TerminalId) 
				   and (@ShiftId is null or @ShiftId=0 or ShiftAutoId=@ShiftId)
                   --group by CTM.CardTypeName
				   
				   for json path,include_null_values),'[]')
				   ) CardTotal,

				   (isnull((
				   select PayoutMode,isnull(sum(isnull(Amount,0)),0)Amount 
				   from PayoutMaster
                   where CompanyId=@StoreId 
				   and CONVERT(date,CreatedDate)=CONVERT(date,@ZReportDate) 
				   and(@TerminalId is null or @TerminalId=0 or Terminal=@TerminalId) 
				   and (@ShiftId is null or @ShiftId=0 or ShiftId=@ShiftId)
                   group by PayoutMode

				   for json path,include_null_values),'[]')
				   ) TotalPayOut,

				   (isnull((
				   select isnull(sum(isnull(Amount,0)),0)Amount 
				   from PayoutMaster
                   where CompanyId=@StoreId 
				   and CONVERT(date,CreatedDate)=CONVERT(date,@ZReportDate) 
				   and(@TerminalId is null or @TerminalId=0 or Terminal=@TerminalId) 
				   and (@ShiftId is null or @ShiftId=0 or ShiftId=@ShiftId)
				   for json path,include_null_values),'[]')
				   ) TotalPayOutAmt,

				   (isnull((
				    select TaxPer,isnull(TaxAmt,0)TaxAmt from #TempTaxBreakOut
				    for json path,include_null_values),'[]')
				   ) TaxWiseAmt,

				   (isnull((
				    select isnull(sum(isnull(TaxAmt,0)),0) TaxAmt from #TempTaxBreakOut
				    for json path,include_null_values),'[]')
				   ) TaxTotalAmt,
				   --for json path,include_null_values,
				   (isnull((
				    select isnull(AllowLotterySale,0)AllowLotterySale from CompanyProfile where AutoId=@StoreId
				    for json path,include_null_values),'[]')
				   ) AllowLotterySale
				   for json path,include_null_values
				   -----------------------------------------------------------
	       commit tran
	     end try
	   begin catch
	         rollback tran
	         SET @isException=1 
             SET @exceptionMessage=ERROR_MESSAGE()
	   end catch
  end
       if(@Opcode=42)
       begin
         begin try
	       begin tran
                   select AutoId,TerminalName from TerminalMaster where Status=1 and CompanyId=@StoreId
	       commit tran
	     end try
	   begin catch
	         rollback tran
	         SET @isException=1 
             SET @exceptionMessage=ERROR_MESSAGE()
	   end catch
  end
  end try
  begin catch
        SET @isException=1 
        SET @exceptionMessage=ERROR_MESSAGE()
  end catch
end
GO
