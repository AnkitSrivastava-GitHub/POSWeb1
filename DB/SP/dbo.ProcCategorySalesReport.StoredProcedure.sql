
Create or alter  proc [dbo].[ProcCategorySalesReport]
@Opcode int=null,
@Who int=null,
@StoreId int=null,
@TerminalId int=null,
@ReportDate datetime=null,
@PageIndex INT=1,
@PageSize INT=10,
@ShiftId int=null,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as
BEGIN

BEGIN TRY
begin tran
       SET @isException=0
       SET @exceptionMessage='Success!'
       if @Opcode=41
       begin
            select AutoId,TerminalName from TerminalMaster where CompanyId=@StoreId
       end
	   else if @Opcode=42
       begin
            select ROW_NUMBER() over(order by CategoryName asc) RowNumber,* into #Temp42 from (
			select PM.CategoryId, CM.CategoryName,
            sum(isnull(IIM.Total,1)*isnull(ISM.Quantity,1))TotalCateSaleAmt
            from InvoiceSKUMaster ISM
            Inner join InvoiceItemMaster IIM on IIM.SKUAutoId=ISM.AutoId
            inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
           -- inner join SKUItemMaster SIM on SIM.SKUAutoId=ISM.SKUId
            inner join ProductMaster PM on PM.AutoId=IIM.ProductId
            inner join CategoryMaster CM on CM.AutoId=PM.CategoryId
            --inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=@StoreId
            where PM.ProductName not like '%Lottery%' and IM.StoreId=@StoreId
            and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId) 
            and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
            group by PM.CategoryId, CM.CategoryName

			union

			select '0','Gift Card' CategoryName,sum(ISM.Total)TotalCateSaleAmt from 
            InvoiceSKUMaster ISM
            inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
            where SKUName like '%Gift Card%' and IM.StoreId=@StoreId
			and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId) 
            and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
            --group by SKUName
			)t
			order by CategoryName asc

			SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Category Name Asc' as SortByString FROM #Temp42      
      
		    Select  * from #Temp42 t      
		    WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
		    and TotalCateSaleAmt>0
			order by CategoryName asc

			select sum(isnull(TotalCateSaleAmt,0))TotalCateSaleAmt from #Temp42

		    --------------------------------------------------------
		    select OpeningBalance,ClosingBalance,Mode
			into #TempOpeningBalanceDetail
			from BalanceMaster BM
			inner join UserDetailMaster UDM on UDM.UserAutoId=BM.UserId
			where StoreId=@StoreId
			and (@TerminalId is null or @TerminalId=0 or BM.TerminalAutoId=@TerminalId) 
            and (@ReportDate is null or @ReportDate='' or convert(date,BM.CreatedDate)=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or BM.AutoId=@ShiftId)

			select sum(isnull(Amount,0)) TotalCashTrns
			into #TempTotalCashTrns
			from InvoiceTransactionDetail ITD
			inner join InvoiceMaster IM on IM.AutoId=ITD.InvoiceAutoId
			where PaymentMode='Cash' and StoreId=@StoreId and isnull(ITD.Amount,0)>0
			and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
            and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)

			select * into #TempPayoutList from(
			select  'Lottery Payout' Payout,'Cash' PayoutMode,isnull(sum(isnull(ISM.Total,0)),0)*-1 TotalPayout
		    from InvoiceSKUMaster ISM
            inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
            where ISM.SKUName like '%Lottery Payout%'
            and Im.StoreId=@StoreId 
            and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
            and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
            group by ISM.SKUName

			union
			
			select PTM.PayoutType+' Payout' Payout,PM.PayoutMode, isnull(sum(isnull(PM.Amount,0)),0)TotalPayout
			from PayoutMaster PM
			inner join PayoutTypeMaster PTM on PTM.AutoId=PM.PayoutType
			where PM.PayoutMode='Cash'
			and PM.CompanyId=@StoreId 
            and (@TerminalId is null or @TerminalId=0 or isnull(PM.Terminal,0)=@TerminalId )
            and (@ReportDate is null or @ReportDate='' or convert(date,isnull(PM.PayoutDate,GETDATE()))=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or PM.ShiftId=@ShiftId)
			group by PTM.PayoutType,PM.PayoutMode
			)t

			select isnull(Sum(isnull(Amount,0)),0)as safeCashAmt
			into #TempSafeCash
			from SafeCash SC
			where (@TerminalId is null or @TerminalId=0 or isnull(SC.Terminal,0)=@TerminalId )
            and (@ReportDate is null or @ReportDate='' or convert(date,isnull(SC.CreatedDate,GETDATE()))=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or SC.ShiftId=@ShiftId)
			and Mode=1 and Store=@StoreId
			--------------------------------------------------------------
			select ISNULL(Sum(isnull(TotalCashTrns,0)),0)as TotalCashTrns from #TempTotalCashTrns

			select ISNULL(Sum(isnull(TotalPayout,0)),0)as TotalPayOut from #TempPayoutList

			select ISNULL(Sum(isnull(OpeningBalance,0)),0)OpeningBalance from #TempOpeningBalanceDetail 

			select ISNULL(Sum(isnull(safeCashAmt,0)),0)safeCashAmt from #TempSafeCash

			select (select ISNULL(Sum(isnull(TotalCashTrns,0)),0)as TotalPayOut from #TempTotalCashTrns)
			+(select ISNULL(Sum(isnull(OpeningBalance,0)),0)OpeningBalance from #TempOpeningBalanceDetail)
			-(select ISNULL(Sum(isnull(TotalPayout,0)),0)as TotalPayOut from #TempPayoutList)
			-(select ISNULL(Sum(isnull(safeCashAmt,0)),0)safeCashAmt from #TempSafeCash) CurrentCashAmt
       end
	   else if @Opcode=43
       begin
	        select * into #Temp43 from(
	             select PM.ProductName, 
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
                 and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
				 and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
                 group by PM.ProductName
			     
                 union 
                 
                 select  ISM.SKUName ProductName,isnull(sum(isnull(ISM.Total,0)),0)TotalLotterySale
                 from InvoiceSKUMaster ISM
                 inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
                 where ISM.SKUName like '%Lottery Sale%' and Im.StoreId=@StoreId 
				 and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
                 and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
				 and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
                 group by ISM.SKUName
			) t

            select ROW_NUMBER() over(order by ProductName asc) RowNumber,ProductName,TotalLotterySale
			into #Temp431
            from #Temp43 
			order by  ProductName asc

			SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Lottery Asc' as SortByString FROM #Temp431      
      
		    Select  * from #Temp431 t      
		    WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
		    order by ProductName asc

			select isnull(sum(isnull(TotalLotterySale,0)),0)TotalLotterySale from #Temp431

			select  'Lottery Payout' ProductName,'Cash' PayoutMode,isnull(sum(isnull(ISM.Total,0)),0)*-1 TotalLottoPayout
		    from InvoiceSKUMaster ISM
            inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
            where ISM.SKUName like '%Lottery Payout%'
            and Im.StoreId=@StoreId 
            and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
            and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
		    and (@ShiftId is null or @ShiftId=0 or IM.ShiftAutoId=@ShiftId)
            group by ISM.SKUName

			select isnull(AllowLotterySale,0)AllowLotterySale from CompanyProfile where AutoId=@StoreId
       end
	   else if @Opcode=44
	   begin
	      
		  select PTM.PayoutType+' Payout' ProductName,PM.PayoutMode, isnull(sum(isnull(PM.Amount,0)),0)TotalLottoPayout
		  Into #TempPayout
		  from PayoutMaster PM
		  inner join PayoutTypeMaster PTM on PTM.AutoId=PM.PayoutType
		  where PM.PayoutMode='Cash'
		  and PM.CompanyId=@StoreId 
          and (@TerminalId is null or @TerminalId=0 or isnull(PM.Terminal,0)=@TerminalId )
          and (@ReportDate is null or @ReportDate='' or convert(date,isnull(PM.PayoutDate,GETDATE()))=convert(date,@ReportDate))
		  and (@ShiftId is null or @ShiftId=0 or PM.ShiftId=@ShiftId)
		  group by PTM.PayoutType,PM.PayoutMode

		  select * from #TempPayout

		  select isnull(sum(isnull(TotalLottoPayout,0)),0)PayoutTotal from #TempPayout

	   end
	   else if @Opcode=45
       begin
	       select * into #Temp45 from(
	        select ITD.PaymentMode,isnull(sum(isnull(ITD.Amount,0)),0)PaymentMethodwiseTotalAmount
            from InvoiceTransactionDetail ITD
            inner join InvoiceMaster IM on IM.AutoId=ITD.InvoiceAutoId
			where IM.StoreId=@StoreId and isnull(ITD.Amount,0)>0 and isnull(ITD.PaymentMode,'')!='Credit Card'
            and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
            and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or Im.ShiftAutoId=@ShiftId)
            group by ITD.PaymentMode
            
            union

			select ITD.PaymentMode+'('+CTM.CardTypeName+')',isnull(sum(isnull(ITD.Amount,0)),0)PaymentMethodwiseTotalAmount
            from InvoiceTransactionDetail ITD
            inner join InvoiceMaster IM on IM.AutoId=ITD.InvoiceAutoId
			left join CardTypeMaster CTM on CTM.AutoId=ITD.CardType
			where IM.StoreId=@StoreId and isnull(ITD.Amount,0)>0 and isnull(ITD.PaymentMode,'')='Credit Card'
            and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
            and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or Im.ShiftAutoId=@ShiftId)
            group by CTM.CardTypeName,ITD.PaymentMode

			union
            
            select 'Discount' PaymentMode,isnull(sum(isnull(Discount,0)),0) PaymentMethodwiseTotalAmount
            from InvoiceMaster IM
            where StoreId=@StoreId
            and (@TerminalId is null or @TerminalId=0 or IM.TerminalId=@TerminalId )
            and (@ReportDate is null or @ReportDate='' or convert(date,IM.InvoiceDate)=convert(date,@ReportDate))
			and (@ShiftId is null or @ShiftId=0 or Im.ShiftAutoId=@ShiftId)
			)t

			select PaymentMode,PaymentMethodwiseTotalAmount into #Temp451 from #Temp45
            
			select * from #Temp45

			select Sum(isnull(PaymentMethodwiseTotalAmount,0))TrasactionGrandTotal from #Temp45
	  
	  end
	  else if(@Opcode=46)
	  begin
	      select BM.AutoId,FirstName+isnull(' '+LastName,'') +'('+format(BM.CreatedDate,'MM/dd/yyyy hh:mm tt')+' - '+(case when ClosingBalance is null then 'Till Now' else format(BM.UpdatedDate,'MM/dd/yyyy hh:mm tt') end)+')' shiftName
		  from BalanceMaster BM
		  inner join UserDetailMaster UDM on UDM.UserAutoId=BM.UserId
		  where TerminalAutoId=@TerminalId and StoreId=@StoreId
		  and convert(date,BM.CreatedDate)=convert(date,@ReportDate)
		  and (@ShiftId is null or @ShiftId=0 or BM.AutoId=@ShiftId)
	  end
commit tran
end try
begin catch
 rollback tran
 set @isException=1
 set @exceptionMessage=ERROR_MESSAGE()
end catch
end
    
GO
