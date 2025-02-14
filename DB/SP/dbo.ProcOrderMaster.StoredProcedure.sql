
ALTER   PROCEDURE [dbo].[ProcOrderMaster]
@Opcode int= null,
@BrandAutoId int=null,
@CategoryAutoId int=null,
@Department int =null,
@ScreenName varchar(100)=null,
@Status int=null,
@TrnsStatus varchar(50)=null,
@ShiftId int=null,
@CartItemId int=null,
@ScreenId int=null,
@DateTime varchar(50)=null,
@CouponCode varchar(50)=null,
@BalanceAutoId int=null,
@CurrentBalStatus varchar(30)=null,
@CurrentBalance decimal(18,2)=null,
@TotalAmt decimal(18,2)=null, 
@LeftAmt decimal(18,2)=null,
@DraftAutoId Varchar(25)=null,
@CustomerId varchar(20)= null,
@CustomerIdG varchar(30)=null,
@UserTypeId int=null,
@OrderId int=null,
@OrderNo varchar(50)=null,
@SKUNames varchar(max)=null,
@GiftCardCode varchar(50)=null,
@SKUAmt decimal(18,2)=null,
@StoreId int=null,
@Type varchar(50)=null,
@InvoiceAutoId int=null,
@InvoiceNo Varchar(25)=null,
@DraftName Varchar(200)=null,
@Remark Varchar(300)=null,
@DraftType Varchar(20)=null,
@FromDate datetime=null,
@ToDate  datetime=null,
@Email Varchar(50)=null,
@ContactNo Varchar(50)=null,
@CreatedFrom Varchar(50)=null,
@PaidAmount decimal(18,3)=null,
@TerminalId int=null,
@OpeningBalance decimal(18,2)=null,
@ClosingBalance decimal(18,2)=null,
@PaymentMethod varchar(50)=null,
@TempInvoiceNo varchar(50)=null,
@TransactionId varchar(100)=null,
@CreditCardLastFourDigits varchar(100)=null,
@AuthCode varchar(100)=null,
@SKUId  int=null,
@SKUAutoId int=null,
@SchemeAutoId  int=null,
@ProductName varchar(200)=null,
@CouponAmt varchar(200)=null,
@Product varchar(200)=null,
@ProductAutoId int=null,
@CustomerName varchar(100)=null,
@PackingAutoId int=null,
@CategoryId varchar(50)=null,
@SecuirtyCode varchar(50)=null,
@Fav int=null,
@Quantity int=null,
@MinAge  int=null,
@SchemeId int=null,
@FirstName varchar(100)=null,
@LastName varchar(100)=null,
@MobileNo varchar(13)=null,
@EmailId  varchar(100)=null,
@Address  varchar(500)=null,
@City     varchar(100)=null,
@State    int=null,
@ZipCode  varchar(10)=null,
@DOB datetime=null,
@GiftCardAmt decimal(18,2)=null,
@GiftCardLftAmt decimal(18,2)=null,
@GiftCardUsedAmt decimal(18,2)=null,
@RoyaltyAmount  decimal(18,2)=null,
@UsedRoyaltyPoints int=null,
@GiftCardNo varchar(25)=null,
@InvoiceDate datetime=null,
@Discount decimal(10,2)=null,
@DiscType nvarchar(20)=null,
@Barcode nvarchar(200)=null,
@BarcodeType varchar(50)=null,
@DT_SaleSku DT_SaleSKU  readonly,
@DT_SKUDraft DT_SKUDraft readonly,
@DT_SaleInvoiceItem DT_SaleInvoiceItem  readonly,
@DT_TransactionDetails DT_TransactionDetails readonly,
@CurrencyTable DT_CurrencyTable readonly,
@CardType varchar(50)=null,
@CardNo varchar(50)=null,
@Disc decimal(18,2)=0,
@Who varchar(50)=null,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
BEGIN
BEGIN TRY
         SET @exceptionMessage='Success'
         SET @isException=0
If @Opcode=11
      BEGIN
      BEGIN TRY
     	 BEGIN TRAN
		 declare @TransAutoId int;
		 
     	 SET @InvoiceNo = (SELECT DBO.SequenceCodeGenerator('InvoiceNo'))  	
     	 insert into InvoiceMaster(InvoiceNo, InvoiceDate,[PaymentMethod], [TransactionId], [TempInvoiceNo],[AuthCode], [CustomerId],[Status],[LogInId],[UserId], Discount, TerminalId, CardType, CardNo,Coupon,CouponAmt,CreatedFrom,AppVersion,StoreId,GiftCardNo,GiftCardUsedAmt,UsedRoyaltyPoints ,UsedRoyaltyAmt,ShiftAutoId,LeftAmt )
     	 values (@InvoiceNo, GETDATE(), @PaymentMethod, @TransactionId, @TempInvoiceNo, @AuthCode,  @CustomerId, 1,  @BalanceAutoId, @Who, @Discount,@TerminalId, @CardType, @CardNo,@CouponCode,@CouponAmt,'Web','',@StoreId,@GiftCardNo,@GiftCardUsedAmt,@UsedRoyaltyPoints,@RoyaltyAmount,@ShiftId,@LeftAmt)
     	 set @InvoiceAutoId=(SELECT SCOPE_IDENTITY())
    	 
		 if(isnull(@GiftCardNo,'')!='')
		 begin
		     update GiftCardSale set LeftAmt=@GiftCardLftAmt ,SoldStatus=(Case when @GiftCardLftAmt=0 then 2 else SoldStatus end) where CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and StoreId=@StoreId
		 end

		 --update CouponMaster set Applied=1 where AutoId=@CouponCode

     	 Insert into InvoiceTransactionDetail( InvoiceAutoId, TransactionId, AuthCode, PaymentMode,Amount, CreatedDate, CreatedBy, TempInvoiceNo, CardType, CardNo)
     	 --values(@InvoiceAutoId, @TransactionId, @AuthCode, @PaymentMethod, GETDATE(), @Who, @TempInvoiceNo, @CardType, @CardNo) 
     	 
		 select @InvoiceAutoId,
		 --PaymentCode,
		 (case when t.PaymentBy='Credit Card' then @TransactionId else PaymentCode end),
		 @AuthCode, t.PaymentBy,t.PaymentAmt, GETDATE(), @Who, @TempInvoiceNo, 
		 (case when t.PaymentBy='Credit Card' then @CardType else '' end),
		 (case when t.PaymentBy='Credit Card' then @CreditCardLastFourDigits  else '' end)
		 from @DT_TransactionDetails t
		 
		 set @TransAutoId=(SELECT SCOPE_IDENTITY())

     	 declare @i int=1, @row int=0,@SKUName varchar(200),@SoldQty int=0;
     	 Select ROW_NUMBER() over (order by SKUId desc) as RowNumber,SKUUnitPrice UnitPrice,AutoId as CartItemId, * into #temp11 from CartSKUMaster where OrderAutoId=@OrderId
     	 Set @row=(Select COUNT(1) from #temp11)
     	 
     	 While(@row>=@i)
     	 begin
     	      insert into InvoiceSKUMaster( InvoiceAutoId, SKUId, SchemeId, Quantity,SKUName,ScreenUnitPrice,ProductAddedSeq)
     	      Select @InvoiceAutoId, SKUId, SchemeId , Quantity,SKUName,UnitPrice,CartItemId from #temp11 where RowNumber=@i
     	      set @SKUAutoId=(SELECT SCOPE_IDENTITY())
              --Set @SKUId=(Select SKUId from #temp11 where RowNumber=@i)
			  Set @SKUName=(Select SKUName from #temp11 where RowNumber=@i)
			  --set @SchemeId=(Select SchemeId from #temp11 where RowNumber=@i)
			  --set @SoldQty=(Select Quantity from #temp11 where RowNumber=@i)
     	      set @CartItemId=(Select CartItemId from #temp11 where RowNumber=@i)
			  if(@SKUName like '%Gift Card%')
			  begin
			      update GiftCardSale set SoldStatus=1 , GiftCardPurchaseInvoice=@InvoiceAutoId,CustomerAutoId=@CustomerId where CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(replace(@SKUName,'Gift Card - ', '')) AS VARBINARY(100)) and StoreId=@StoreId
			  end
			  insert into InvoiceItemMaster(SKUAutoId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice,ProductTotalSoldQty)
			  select @SKUAutoId,ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice,ProductTotalSoldQty from CartItemMaster where CartItemId=@CartItemId and CartAutoId=@OrderId
			  --if(@SKUId=0)
			  --begin
			  --    insert into InvoiceItemMaster(SKUAutoId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice,ProductTotalSoldQty)
				 -- Select @SKUAutoId, 0,0 , Quantity,UnitPrice,0, UnitPrice*Quantity,0,0,1 from #temp11 where RowNumber=@i

				 -- if(@SKUName like '%Gift Card%')
				 -- begin
				 --     update GiftCardSale set SoldStatus=1 , GiftCardPurchaseInvoice=@InvoiceAutoId,CustomerAutoId=@CustomerId where GiftCardCode= replace(@SKUName,'Gift Card - ', '')
				 -- end
			  --end
     --	      else if(@SchemeId!=0)
			  --begin
			  
			  --    insert into InvoiceItemMaster(SKUAutoId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice,ProductTotalSoldQty)
     --	          Select @SKUAutoId, dt.ProductAutoId, dt.PackingAutoId,dt.Quantity, dt.UnitPrice, dt.Tax, dt.Total,
				 -- isnull(tm.TaxPer,0),isnull(pm.CostPrice,0),@SoldQty*pm.NoOfPieces*dt.Quantity
     --	          from SchemeItemMaster as dt 
     --	          inner join ProductUnitDetail as pm on (pm.AutoId=dt.PackingAutoId) and StoreId=@StoreId
     --	          left join TaxMaster as tm on (tm.AutoId=pm.TaxAutoId)
     --	          where dt.SchemeAutoId=@SchemeId

			  --end
			  --else
			  --begin
			  --    insert into InvoiceItemMaster(SKUAutoId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice,ProductTotalSoldQty)
     --	          Select @SKUAutoId, dt.ProductId, dt.ProductUnitAutoId, dt.Quantity, dt.UnitPrice, dt.Tax, dt.SKUItemTotal, 
				 -- isnull(tm.TaxPer,0),ISNULL(pm.CostPrice,0),@SoldQty*pm.NoOfPieces*dt.Quantity
     --	          from SKUItemMaster as dt 
     --	          inner join ProductUnitDetail as pm on (pm.AutoId=dt.ProductUnitAutoId) and StoreId=@StoreId
     --	          left join TaxMaster as tm on (tm.AutoId=pm.TaxAutoId)
     --	          where dt.SKUAutoId=@SKUId
			  --end

     	      set @i=@i+1
     	 end
		 
		    ;with CTE as (
			     select Itm.ProductId,sum(isnull(ProductTotalSoldQty,0))as productqty
                 from InvoiceItemMaster ITM
                 inner join InvoiceSKUMaster ISM on ISM.AutoId=ITM.SKUAutoId
                 where ISM.InvoiceAutoId=@InvoiceAutoId
                 group by Itm.ProductId
			  )
			  select * into #TempUpdateProductQty from CTE

			  update MSM set MSM.StockQty=MSM.StockQty-isnull(CTE.productqty,0)
			  from ManageStockMaster MSM
			  inner join #TempUpdateProductQty cte on cte.ProductId=MSM.ProductId
			  where MSM.StoreId=@StoreId

			  update SPL set SPL.InstockQty=SPL.InstockQty-isnull(CTE.productqty,0)
			  from StoreWiseProductList SPL
			  inner join #TempUpdateProductQty cte on cte.ProductId=SPL.ProductId
			  where SPL.StoreId=@StoreId

         update CartMaster set DraftName='',DraftDateTime='',ShowAsDraft=0,InvoiceId=@InvoiceAutoId,Isdeleted=1 where AutoId=@OrderId

		 set @PaidAmount=(select Total from InvoiceMaster where AutoId=@InvoiceAutoId and StoreId=@StoreId)
		 if(@PaymentMethod='Cash' and (select UTM.UserType from UserDetailMaster UDM inner join UserTypeMaster UTM on UTM.AutoId=UDM.UserType where UDM.UserAutoId=@Who)!='Cashier')
     	 begin
		     if exists(select * from BalanceMaster where UserId=@Who and TerminalAutoId=isnull(@TerminalId,0) and StoreId=@StoreId and cast(CreatedDate as date)=convert(date,GETDATE())) --
			 begin
			      Update BalanceMaster set [ActualBalance]=isnull(ActualBalance,0)+@PaidAmount,UpdatedBy=@Who where  UserId=@Who and @TerminalId=isnull(@TerminalId,0) and StoreId=@StoreId and cast(CreatedDate as date)=convert(date,GETDATE())
			 end
			 else
			 begin
			      insert into BalanceMaster(UserId,TerminalAutoId,OpeningBalance,ClosingBalance,CreatedDate,ActualBalance,CreatedBy,StoreId)
				  values(@Who,@TerminalId,0,0,GETDATE(),@PaidAmount,@Who,@StoreId)
			 end
     	 end	

     	 --update InvoiceTransactionDetail set  Amount=(select Total from InvoiceMaster where AutoId=@InvoiceAutoId and StoreId=@StoreId) where AutoId=@TransAutoId
        --- select * from InvoiceTransactionDetail
		 if((Select FirstName from CustomerMaster where  AutoId=@CustomerId and StoreId=@StoreId)!='Walk In')
         begin
		 if((select Status from AmountWiseRoyaltyPointMaster where StoreId=@StoreId)=1)
		 begin
            declare @RoyaltyPoint int=0,@TempOrderAmt decimal(18,2)=0,@TempMinAmt decimal(18,2)=0,@TempRoyalPoints int=0,
			@TempLotterySaleAmt decimal(18,2)=0,@TempLotteryPayoutAmt decimal(18,2)=0;
			
			set @TempLotterySaleAmt=(select isnull(sum(isnull(Total,0)),0) from InvoiceSKUMaster
            where SKUName like '%lottery%' and SKUName!='Lottery Payout'
            and InvoiceAutoId=@InvoiceAutoId
            group by InvoiceAutoId)
            
            set @TempLotteryPayoutAmt=(select isnull(sum(isnull(Total,0))*(-1),0) from InvoiceSKUMaster
            where SKUName='Lottery Payout' --and SKUName not like '%lottery%' 
            and InvoiceAutoId=@InvoiceAutoId
            group by InvoiceAutoId)

            if((select (Total)+isnull(@TempLotteryPayoutAmt,0)-isnull(@TempLotterySaleAmt,0) from InvoiceMaster where AutoId=@InvoiceAutoId)>=(select Top 1 MinOrderAmt from AmountWiseRoyaltyPointMaster where StoreId=@StoreId))
            begin
                 set @TempOrderAmt=(select (Total)+isnull(@TempLotteryPayoutAmt,0)-isnull(@TempLotterySaleAmt,0) from InvoiceMaster where AutoId=@InvoiceAutoId)
                 set @TempMinAmt=(select  Top 1 Amount from AmountWiseRoyaltyPointMaster where StoreId=@StoreId)
                 set @TempRoyalPoints=(select top 1 RoyaltyPoint from AmountWiseRoyaltyPointMaster  where StoreId=@StoreId)
                 set @RoyaltyPoint=(select convert(int,((@TempOrderAmt/@TempMinAmt)*@TempRoyalPoints)))
                 if exists(select * from CustomerRoyaltyPoints where CustomerId=@CustomerId)
                 begin
                      update CustomerRoyaltyPoints 
                      set AssignedRoyaltyPoints=((isnull(AssignedRoyaltyPoints,0)+@RoyaltyPoint)), 
                      UpdatedDate=getdate(),UpdatedBy=@Who where CustomerId=@CustomerId

					  insert into CustomerRoyaltyPoints_Log(CustomerId,AssignedRoyaltyPoints,CreatedBy,CreatedDate, InvoiceAutoId)
                      values(@CustomerId,@RoyaltyPoint,@Who,GETDATE(), @InvoiceAutoId)					  
                 end
                 else
                 begin
                     insert into CustomerRoyaltyPoints(CustomerId,AssignedRoyaltyPoints,CreatedBy,CreatedDate)
                     values(@CustomerId,@RoyaltyPoint,@Who,GETDATE())

					 insert into CustomerRoyaltyPoints_Log(CustomerId,AssignedRoyaltyPoints,CreatedBy,CreatedDate, InvoiceAutoId)
                     values(@CustomerId,@RoyaltyPoint,@Who,GETDATE(), @InvoiceAutoId)
                 end
                 update InvoiceMaster set EarnedRoyalty=@RoyaltyPoint where AutoId=@InvoiceAutoId
            end
          end
		 if((select (Total+isnull(@TempLotteryPayoutAmt,0)-isnull(@TempLotterySaleAmt,0)) from InvoiceMaster where AutoId=@InvoiceAutoId)>=(select Top 1 MinOrderAmt from RoyaltyMaster where StoreId=@StoreId))
		 begin
		 	update CustomerRoyaltyPoints 
		 	set AssignedRoyaltyPoints=(isnull(AssignedRoyaltyPoints,0)-@UsedRoyaltyPoints), 
		 	UpdatedDate=getdate(),UpdatedBy=@Who where CustomerId=@CustomerId
		 
		 	insert into CustomerRoyaltyPoints_Log(CustomerId,AssignedRoyaltyPoints,CreatedBy,CreatedDate, InvoiceAutoId)
		 	values(@CustomerId,(-1)*@UsedRoyaltyPoints,@Who,GETDATE(), @InvoiceAutoId)
		 End
		 end
		 Update CustomerMaster set TotalPurchase=isnull(TotalPurchase,0) + (select Total from InvoiceMaster where AutoId=@InvoiceAutoId) where AutoId=@CustomerId

		 --Delete from DraftMaster where [AutoId]=@DraftAutoId and StoreId=@StoreId
   --  	 Delete from DraftSKUMaster where DraftAutoId=@DraftAutoId
     	 --Delete from DraftItemMaster where DraftAutoId=@DraftAutoId
     
     	 UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='InvoiceNo'  
		 
		 Select @InvoiceAutoId as InvoiceAutoId
     	  
     	COMMIT TRANSACTION    
      END TRY                                                                                                                                   
      BEGIN CATCH                                                                                                                               
     	ROLLBACK TRAN                                                                                                                         
     	Set @isException=1                                                                                                   
     	Set @exceptionMessage=ERROR_MESSAGE()                                                                     
      End Catch      
  end
  else 
		If @Opcode=12
		BEGIN
		if not exists(select * from CartMaster where DraftName=@DraftName and Status=1 and StoreId=@StoreId and TerminalId=@TerminalId and OrderNo!=@OrderNo and convert(date,DraftDateTime)=convert(date,GETDATE()))
		BEgin
           update CartMaster Set DraftName=@DraftName, DraftDateTime=getdate(),ShowAsDraft=1,IsDeleted=1,StoreId=@StoreId,ShiftAutoId=@ShiftId where StoreId=@StoreId and OrderNo=@OrderNo and TerminalId=@TerminalId

		   select AutoId,isnull(DraftName,'')DraftName from CartMaster where OrderNo=@OrderNo
		END
		ELSE
		BEGIN
		Set @isException=1                                                                                                   
		Set @exceptionMessage='Draft Name already exists!' 
		END
		end
  else 
  If @Opcode=122
		BEGIN
		
		   select AutoId,isnull(DraftName,'')DraftName from CartMaster where OrderNo=@OrderNo
		
		end
        else  If @Opcode=46
         BEGIN
		 delete from DraftMaster where AutoId=@DraftAutoId and Status=1 and StoreId=@StoreId 
		 if not exists(select * from DraftMaster where DraftName=@DraftName and Status=1 and StoreId=@StoreId and convert(date,DraftDate)=convert(date,GETDATE()))
		 BEgin
          BEGIN TRY
         	BEGIN TRAN
         	SET @InvoiceNo = (SELECT DBO.SequenceCodeGenerator('Draft'))  	
         	
         	insert into DraftMaster(DraftNo, DraftDate, CustomerId, TerminalId, DraftName, Discount,Amount, Type,Status,StoreId)
         	values (@InvoiceNo, GETDATE(),  @CustomerId, @TerminalId, @DraftName, @Discount,@OpeningBalance, @DraftType,1,@StoreId)
         	
         	set @DraftAutoId=(SELECT SCOPE_IDENTITY())
         	
         	declare @i123 int=1, @row123 int=0;
         	Select ROW_NUMBER() over (order by SKUId desc) as RowNumber, * into #temp123 from @DT_SKUDraft
         	Set @row123=(Select COUNT(1) from #temp123)
         
         	While(@row123>=@i123)
         	begin
         	    insert into DraftSKUMaster(DraftAutoId, SKUId, SchemeId, Quantity)
         	    Select @DraftAutoId, SKUId, SchemeId , Quantity from #temp123 where RowNumber=@i123
         	    set @i123=@i123+1
         	end
         
         	 UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='Draft'  
         	 Set @isException=0   
         	COMMIT TRANSACTION    
          END TRY                                                                                                                                   
          BEGIN CATCH                                                                                                                               
         	ROLLBACK TRAN                                                                                                                         
         	Set @isException=1                                                                                                   
         	Set @exceptionMessage=ERROR_MESSAGE()                                                                     
          End Catch 
		  END
		  ELSE
		  BEGIN
		  Set @isException=1                                                                                                   
         	Set @exceptionMessage='Draft Name already exists!' 
		  END
         end
else If @Opcode=13
BEGIN
if(exists(select top 1 Mode from BalanceMaster where UserId=@Who order by AutoId desc)and (select top 1 Mode from BalanceMaster where UserId=@Who order by AutoId desc)!='Logout')
    begin
	   Set @isException=1                                                                                                   
       Set @exceptionMessage='Your previous closing balance is pending!'
	end
	else
	--if((select top 1 Mode from BalanceMaster where UserId=@Who order by AutoId desc)='Logout')
	begin
		DECLARE @BMId int
		insert into BalanceMaster(UserId, TerminalAutoId, OpeningBalance, Mode, CreatedDate,StoreId,CreatedBy,CurrentBalanceStatus,CurrentBalanceDiff) 
		values(@Who,@TerminalId,@OpeningBalance,'Break',getdate(),@StoreId,@Who,@CurrentBalStatus,@CurrentBalance)

		SET @BMId = SCOPE_IDENTITY()		

	    select ROW_NUMBER() over(order by CAutoId asc)RowNo, CAutoId,QTY,@Who as UserId,@StoreId as StoreId,[Type]='Opening',[BMAutoId]=(@BMId)  into #TempCurrency from @CurrencyTable 
		insert into UserCurrencyRecord (CurrencyAutoId,QTY,UserId,StoreId,BMAutoId,Type) select CAutoId,QTY,UserId,StoreId,BMAutoId,Type from #TempCurrency
	
		select top 1 @BMId as ShiftId from BalanceMaster
	    
	end
end
else If @Opcode=14
BEGIN

if(exists(select top 1 Mode from BalanceMaster where UserId=@Who and StoreId=@StoreId order by AutoId desc)and (select top 1 Mode from BalanceMaster where UserId=@Who and StoreId=@StoreId order by AutoId desc)='Break')
    begin
	    select ROW_NUMBER() over(order by CAutoId asc)RowNo, CAutoId,QTY,@Who as UserId,@StoreId as StoreId,[Type]='Closing',[BMAutoId]=(select top 1 AutoId from BalanceMaster where UserId=@Who and StoreId=@StoreId order by AutoId desc)  into #TempCurrency2 from @CurrencyTable 
		insert into UserCurrencyRecord (CurrencyAutoId,QTY,UserId,StoreId,BMAutoId,Type) select CAutoId,QTY,UserId,StoreId,BMAutoId,Type from #TempCurrency2
		
		update BalanceMaster set ClosingBalance=@ClosingBalance, UpdatedDate=GETDATE(),UpdatedBy=@Who,Mode='Logout',CurrentBalanceStatus=@CurrentBalStatus,CurrentBalanceDiff=@CurrentBalance
		where AutoId=(select top 1 AutoId from BalanceMaster where UserId=@Who and StoreId=@StoreId order by AutoId desc)

		if(exists (select * from TerminalMaster where CurrentUser=@Who and  CompanyId=@StoreId and AutoId=@TerminalId and OccupyStatus=1))
		begin
		   Update TerminalMaster set OccupyStatus=0, CurrentUser=0,LoginTime='',LogoutTime=GETDATE() where CurrentUser=@Who and AutoId=@TerminalId and OccupyStatus=1 and CompanyId=@StoreId
		end
	end
	else
	--if((select top 1 Mode from BalanceMaster where UserId=@Who order by AutoId desc)='Logout')
	begin
	   Set @isException=1                                                                                                   
       Set @exceptionMessage='Back from break!'
	end
end
else If @Opcode=25
BEGIN
   if exists(select Name from ScreenMaster where Name=@ScreenName and StoreId=@StoreId)
	  begin		   
		   SET @exceptionMessage='Screen Name Already Exists.'
           SET @isException=1
	  end
	  else
		begin
			Insert into ScreenMaster(Name,Status,StoreId) values(@ScreenName,@Status,@StoreId)
			SET @exceptionMessage='Success'
			SET @isException=0
		end
end
else If @Opcode=26
	BEGIN
		select ROW_NUMBER() over(order by SM.Name asc) as RowNumber,SM.AutoId,SM.Name,SM.Status into #tempT2 from ScreenMaster SM
		where (@ScreenName is null or @ScreenName=''  or Name like'%'+ @ScreenName +'%') and (@Status is null or @Status=2 or Status=@Status)
		and (@StoreID is null or @StoreID=0 or StoreId=@StoreID) 
		and ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=1 or ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=0 and Name not like 'Lottery%'))
		ORDER BY Name asc
		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Screen Name asc' as SortByString FROM #tempT2

		Select  * from 
		#tempT2 t
		WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
		order by  Name asc
	end
else If @Opcode=27
BEGIN
   delete from ScreenMaster where AutoId=@ScreenId and StoreId=@StoreId
   --select * from ProductScreenMaster where ScreenId=119 and StoreId=57
   delete from ProductScreenMaster  where ScreenId=@ScreenId and StoreId=@StoreId
   delete from SKUScreenMaster  where ScreenId=@ScreenId and StoreId=@StoreId
   delete from SchemeScreenMaster  where ScreenId=@ScreenId and StoreId=@StoreId

end
else If @Opcode=28
BEGIN
   Select * from ScreenMaster where Status=1 and StoreId=@StoreId
   and ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=1 or ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=0 and Name not like 'Lottery%'))
end
else If @Opcode=32
BEGIN
   Select * from PayoutTypeMaster 
end
else If @Opcode=33
BEGIN
  select AutoId,VendorName from VendorMaster where  Status=1 order by VendorName
end
else If @Opcode=34
BEGIN
   Select * from ExpenseMaster where Status=1 and StoreId=@StoreId order by ExpenseName 
end
else If @Opcode=35
BEGIN
   Select * from ScreenMaster where AutoId=@ScreenId
end
else If @Opcode=36
BEGIN
if exists(select Name from ScreenMaster where Name=@ScreenName and AutoId!=@ScreenId and StoreId=@StoreId)
	  begin		   
		   SET @exceptionMessage='Screen Name Already Exists.'
           SET @isException=1
	  end
	  else
		begin
			 update ScreenMaster set Name=@ScreenName,Status=@Status where AutoId=@ScreenId and StoreId=@StoreId
		end
end
else If @Opcode=37
BEGIN
     if ((Select SecurityPin from tbl_SecurityPinMaster where Type='Discount' and UserId=@Who and Status=1)=@SecuirtyCode)
	  begin		   
		   SET @exceptionMessage='Success'
           SET @isException=0
	  end
	  else
	  begin
		 SET @exceptionMessage='failed'
         SET @isException=1
	  end
end
else If @Opcode=45
BEGIN
     if ((Select SecurityPin from tbl_SecurityPinMaster where Type='Withdraw' and UserId=@Who and Status=1)=@SecuirtyCode)
	  begin		   
		   SET @exceptionMessage='Success'
           SET @isException=0
	  end
	  else
	  begin
		 SET @exceptionMessage='failed'
         SET @isException=1
	  end
end
else If @Opcode=38
BEGIN
	 select AutoId,Amount from CurrencyMaster where Status=1 order by Amount asc

	 --select OpeningBalance from BalanceMaster 
	 ----where AutoId=(select top 1 AutoId from BalanceMaster 
	 --where 
	 ----UserId=@Who and StoreId=@StoreId and 
	 --AutoId=@ShiftId 
	 ----and TerminalAutoId=@TerminalId 
	 --and (ClosingBalance is null) order by AutoId desc--)

	 select top 1 OpeningBalance from BalanceMaster 
	 where StoreId=@StoreId and  TerminalAutoId=@TerminalId and (ClosingBalance is null) 
	 order by AutoId desc

	 select OpeningBalance,ClosingBalance,Mode
            into #TempOpeningBalanceDetail
            from BalanceMaster BM
            inner join UserDetailMaster UDM on UDM.UserAutoId=BM.UserId
            where StoreId=@StoreId
            and  BM.TerminalAutoId=@TerminalId 
            --and  convert(date,BM.CreatedDate)=convert(date,GETDATE())
            and  BM.AutoId=@ShiftId

            select sum(isnull(Amount,0)) TotalCashTrns
            into #TempTotalCashTrns
            from InvoiceTransactionDetail ITD
            inner join InvoiceMaster IM on IM.AutoId=ITD.InvoiceAutoId
            where PaymentMode='Cash' and StoreId=@StoreId and isnull(ITD.Amount,0)>0
            and IM.TerminalId=@TerminalId 
            --and convert(date,IM.InvoiceDate)=convert(date,GETDATE())
            and  IM.ShiftAutoId=@ShiftId

            select * into #TempPayoutList from(
            select  'Lottery Payout' Payout,'Cash' PayoutMode,isnull(sum(isnull(ISM.Total,0)),0)*-1 TotalPayout
            from InvoiceSKUMaster ISM
            inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
            where ISM.SKUName like '%Lottery Payout%'
            and Im.StoreId=@StoreId 
            and  IM.TerminalId=@TerminalId
            --and convert(date,IM.InvoiceDate)=convert(date,GETDATE())
            and IM.ShiftAutoId=@ShiftId
            group by ISM.SKUName

            union
            
            select PTM.PayoutType+' Payout' Payout,PM.PayoutMode, isnull(sum(isnull(PM.Amount,0)),0)TotalPayout
            from PayoutMaster PM
            inner join PayoutTypeMaster PTM on PTM.AutoId=PM.PayoutType
            where PM.PayoutMode='Cash'
            and PM.CompanyId=@StoreId 
            and isnull(PM.Terminal,0)=@TerminalId 
            --and convert(date,isnull(PM.PayoutDate,GETDATE()))=convert(date,GETDATE())
            and PM.ShiftId=@ShiftId
            group by PTM.PayoutType,PM.PayoutMode
            )t

            select isnull(Sum(isnull(Amount,0)),0)as safeCashAmt
            into #TempSafeCash
            from SafeCash SC
            where isnull(SC.Terminal,0)=@TerminalId 
            --and convert(date,isnull(SC.CreatedDate,GETDATE()))=convert(date,GETDATE())
            and SC.ShiftId=@ShiftId
            and Mode=1 and Store=@StoreId
            --------------------------------------------------------------
            select ISNULL(Sum(isnull(TotalCashTrns,0)),0)as TotalCashTrns from #TempTotalCashTrns

            select ISNULL(Sum(isnull(TotalPayout,0)),0)as TotalPayOut from #TempPayoutList

            select ISNULL(Sum(isnull(OpeningBalance,0)),0)OpeningBalance from #TempOpeningBalanceDetail 

            select ISNULL(Sum(isnull(safeCashAmt,0)),0)safeCashAmt from #TempSafeCash

            select isnull((select ISNULL(Sum(isnull(TotalCashTrns,0)),0)as TotalPayOut from #TempTotalCashTrns)
            +(select ISNULL(Sum(isnull(OpeningBalance,0)),0)OpeningBalance from #TempOpeningBalanceDetail)
            -(select ISNULL(Sum(isnull(TotalPayout,0)),0)as TotalPayOut from #TempPayoutList)
            -(select ISNULL(Sum(isnull(safeCashAmt,0)),0)safeCashAmt from #TempSafeCash),0) CurrentCashAmt

end
else If @Opcode=58
BEGIN
	 select OpeningBalance,ClosingBalance,Mode
            into #TempOpeningBalanceDetails
            from BalanceMaster BM
            inner join UserDetailMaster UDM on UDM.UserAutoId=BM.UserId
            where StoreId=@StoreId
            and  BM.TerminalAutoId=@TerminalId 
            --and  convert(date,BM.CreatedDate)=convert(date,GETDATE())
            and  BM.AutoId=@ShiftId

            select sum(isnull(Amount,0)) TotalCashTrns
            into #TempTotalCashTrnss
            from InvoiceTransactionDetail ITD
            inner join InvoiceMaster IM on IM.AutoId=ITD.InvoiceAutoId
            where PaymentMode='Cash' and StoreId=@StoreId and isnull(ITD.Amount,0)>0
            and IM.TerminalId=@TerminalId 
            --and convert(date,IM.InvoiceDate)=convert(date,GETDATE())
            and  IM.ShiftAutoId=@ShiftId

            select * into #TempPayoutLists from(
            select  'Lottery Payout' Payout,'Cash' PayoutMode,isnull(sum(isnull(ISM.Total,0)),0)*-1 TotalPayout
            from InvoiceSKUMaster ISM
            inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
            where ISM.SKUName like '%Lottery Payout%'
            and Im.StoreId=@StoreId 
            and  IM.TerminalId=@TerminalId
            --and convert(date,IM.InvoiceDate)=convert(date,GETDATE())
            and IM.ShiftAutoId=@ShiftId
            group by ISM.SKUName

            union
            
            select PTM.PayoutType+' Payout' Payout,PM.PayoutMode, isnull(sum(isnull(PM.Amount,0)),0)TotalPayout
            from PayoutMaster PM
            inner join PayoutTypeMaster PTM on PTM.AutoId=PM.PayoutType
            where PM.PayoutMode='Cash'
            and PM.CompanyId=@StoreId 
            and isnull(PM.Terminal,0)=@TerminalId 
            --and convert(date,isnull(PM.PayoutDate,GETDATE()))=convert(date,GETDATE())
            and PM.ShiftId=@ShiftId
            group by PTM.PayoutType,PM.PayoutMode
            )t

            select isnull(Sum(isnull(Amount,0)),0)as safeCashAmt
            into #TempSafeCashs
            from SafeCash SC
            where isnull(SC.Terminal,0)=@TerminalId 
            --and convert(date,isnull(SC.CreatedDate,GETDATE()))=convert(date,GETDATE())
            and SC.ShiftId=@ShiftId
            and Mode=1 and Store=@StoreId
            --------------------------------------------------------------
            --select ISNULL(Sum(isnull(TotalCashTrns,0)),0)as TotalCashTrns from #TempTotalCashTrnss

            --select ISNULL(Sum(isnull(TotalPayout,0)),0)as TotalPayOut from #TempPayoutLists

            --select ISNULL(Sum(isnull(OpeningBalance,0)),0)OpeningBalance from #TempOpeningBalanceDetails 

            --select ISNULL(Sum(isnull(safeCashAmt,0)),0)safeCashAmt from #TempSafeCashs

            select isnull((select ISNULL(Sum(isnull(TotalCashTrns,0)),0)as TotalPayOut from #TempTotalCashTrnss)
            +(select ISNULL(Sum(isnull(OpeningBalance,0)),0)OpeningBalance from #TempOpeningBalanceDetails)
            -(select ISNULL(Sum(isnull(TotalPayout,0)),0)as TotalPayOut from #TempPayoutLists)
            -(select ISNULL(Sum(isnull(safeCashAmt,0)),0)safeCashAmt from #TempSafeCashs),0) CurrentCashAmt

end
else If @Opcode=39
BEGIN
if not exists(select * from CouponMaster where convert(date,StartDate,109)<=convert(date,getdate(),109) and convert(date,EndDate,109)>=convert(date,getdate(),109) and isnull(Applied,0)=0 and Status=1 and StoreId=@StoreId  and CAST(CouponCode AS VARBINARY(100)) = CAST(@CouponCode AS VARBINARY(100)))
	begin
		 SET @exceptionMessage='Invalid Coupon Code!'
         SET @isException=1
	end
else if not exists(select * from CouponMaster where convert(date,StartDate,109)<=convert(date,getdate(),109) and convert(date,EndDate,109)>=convert(date,getdate(),109) and isnull(Applied,0)=0 and Status=1 and StoreId=@StoreId  and CAST(CouponCode AS VARBINARY(100)) = CAST(@CouponCode AS VARBINARY(100)) and CouponAmount<=@TotalAmt)
	begin
		 SET @exceptionMessage='Minimum'
         SET @isException=1
	end
Else
	BEGIN
		   select AutoId,CouponName,CouponCode,TermsAndDescription,CouponType,Discount,CouponAmount,StartDate,EndDate,Status,StoreId from CouponMaster
			where convert(date,StartDate,109)<=convert(date,getdate(),109) and convert(date,EndDate,109)>=convert(date,getdate(),109) and isnull(Applied,0)=0 and Status=1 and StoreId=@StoreId and  CAST(CouponCode AS VARBINARY(100)) = CAST(@CouponCode AS VARBINARY(100)) and CouponAmount<=@TotalAmt
	end
END

else If @Opcode=47
  Begin
  Declare @CAutoId int=null
	set @CAutoId=(select max(AutoId) from BalanceMaster where  StoreId=@StoreId and TerminalAutoId=@TerminalId and ClosingBalance is not null)

	select ClosingBalance,FORMAT(UpdatedDate,'MM/dd/yyyy') as UpdatedDate from BalanceMaster where AutoId=@CAutoId and StoreId=@StoreId and TerminalAutoId=@TerminalId
	select CM.AutoId,QTY,CurrencyAutoId,Amount 
	from UserCurrencyRecord UCR 
	Inner join CurrencyMaster CM on UCR.CurrencyAutoId=CM.AutoId 
	where BMAutoId=@CAutoId and Type='Closing' order by Amount asc
  END

  else If @Opcode=48
  Begin
	
    if exists (select GiftCardCode from GiftCardSale where SoldStatus in (1,2) and CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and StoreId=@StoreId)
	begin
	  SET @exceptionMessage='Gift Card Code already exists.'
      SET @isException=1
	end
	else if ((select count(1) from CustomerMaster where MobileNo=@MobileNo and StoreId=@StoreId)>0 and (select FirstName from CustomerMaster where  AutoId=@CustomerId)='Walk In')
    begin
      SET @isException=1
      SET @exceptionMessage='Mobile no already exists.'
    end
	else
	begin
	begin try
	begin tran
	 ---Customer Creation or existing customer
	 	  if((select trim(FirstName) from CustomerMaster where  AutoId=@CustomerId) not like '%Walk In%')
	  begin
	      update CustomerMaster set FirstName=@FirstName,LastName=@LastName, DOB=@DOB, EmailId=@EmailId, Address=@Address,
	      State=@State, City=@City, ZipCode=@ZipCode where AutoId=@CustomerId and StoreId=@StoreId and Status=1 
	  end
	  else if exists(select * from CustomerMaster where MobileNo=@MobileNo and StoreId=@StoreId)
	  begin	      
	      update CustomerMaster set FirstName=@FirstName,LastName=@LastName, DOB=@DOB, EmailId=@EmailId, Address=@Address,
	      State=@State, City=@City, ZipCode=@ZipCode,Status=1  where MobileNo=@MobileNo and StoreId=@StoreId --and Status=1
		  
		  set @CustomerId=(select top 1 AutoId from CustomerMaster where MobileNo=@MobileNo and StoreId=@StoreId)
	  end
	  else
	  begin
			SET @CustomerIdG = (SELECT DBO.SequenceCodeGenerator('CustomerNo'))  

			insert into CustomerMaster(CustomerId, FirstName, LastName, DOB, MobileNo, PhoneNo, EmailId, Address, State, City, Country, ZipCode, Status,StoreId)
			values (@CustomerIdG, @FirstName, @LastName, @DOB, @MobileNo, '', @EmailId, @Address, @State, @City, '', @ZipCode, 1,@StoreId)
			
			set @CustomerId=SCOPE_IDENTITY();

			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CustomerNo'
	  end
	  -- Gift card Creation or existing
	  if exists (select GiftCardCode from GiftCardSale where SoldStatus in (0) and CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and StoreId=@StoreId)
	  BEGIN
	     update GiftCardSale set StoreId=@StoreId,TerminalId=@TerminalId,CustomerAutoId=@CustomerId,SoldBy=@Who,SoldDate=GETDATE(),TotalAmt=@GiftCardAmt,LeftAmt=@GiftCardAmt
	     where SoldStatus in (0) and CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and StoreId=@StoreId
	  END
	  ELSE
	  BEGIN
	     Insert into GiftCardSale(GiftCardCode,TotalAmt,SoldDate,SoldBy,SoldStatus,StoreId,TerminalId,CustomerAutoId,LeftAmt)
	  	 values(@GiftCardNo,@GiftCardAmt,GETDATE(),@Who,0,@StoreId,@TerminalId,@CustomerId,@GiftCardAmt)
	  END
	  ----------------------------- Gift Card Add in Cart -------------------------------
	  Update CartMaster set LiveCartforDraft=0 where StoreId=@StoreId and TerminalId=@TerminalId and LiveCartforDraft=1
	  if(@OrderNo!='')
	  begin	
			set @OrderId=(select AutoId from CartMaster where OrderNo=@OrderNo)
			update CartMaster set CustomerId=@CustomerId, UpdatedDate=GETDATE(), TerminalId=@TerminalId, ShiftAutoId=@ShiftId where AutoId=@OrderId 
	  end
	  else
	  begin
	      SET @OrderNo = (SELECT DBO.SequenceCodeGenerator('OrderNo'))			 
		
		  insert into CartMaster(OrderNo, CustomerId, CreatedDate, UpdatedDate,UpdatedBy, Status,CreatedBy,StoreId,TerminalId,DraftName,DraftDateTime,ShowAsDraft,DiscType,Discount,ShiftAutoId,IsDeleted)
		  values(@OrderNo,@CustomerId,GETDATE(),GETDATE(),@Who,1,@Who,@StoreId,@TerminalId,ISNULL(@DraftName,''),'',0,ISNULL(@DiscType,''),isnull(@Discount,0),@ShiftId,0)
		  Set @OrderId=scope_Identity()
		  UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='OrderNo'
	    end
		if(isnull(@CartItemId,0)=0)
		begin 
			insert into CartSKUMaster([OrderAutoId], [SKUId], [SchemeId], [Quantity], [SKUName],MinAge)
			values(@OrderId, @SKUAutoId, @SchemeId, @Quantity, @SKUNames,0)
			Set @CartItemId=scope_Identity()
		end
		else
		begin
			if(@Quantity>0)
			begin
				update CartSKUMaster set SchemeId=@SchemeId, Quantity=@Quantity, SKUName=@SKUNames where AutoId=@CartItemId
			end
			else
			begin
				delete from CartSKUMaster where AutoId=@CartItemId
			end
		end

		if(@Quantity>0)
		begin
		   if(@SKUAutoId=0)
		   begin
		   	   insert into CartItemMaster(CartItemId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice, CartAutoId,ProductTotalSoldQty)
		   	   Select @CartItemId, 0,0 , @Quantity,@GiftCardAmt,0, isnull(@GiftCardAmt,0)*isnull(@Quantity,1),0,0,@OrderId,@Quantity
		   end
		end

		select @Discount=Discount, @Type=DiscType from CartMaster where OrderNo=@OrderNo
		
		if(@Type='Per')
		Begin
		set @Disc=isnull((select cast(sum(Total) as decimal(18,2))from CartSKUMaster where OrderAutoId=@OrderId and  SKUName not like '%Lottery%'),0) / 100 * @Discount
		End
		Else
		Begin
		set @Disc=isnull(@Discount,0)
		End 

		set @DiscType=(case when (ISNULL(@Type,'')='Per' and @Disc>0) then 'Percentage' when (ISNULL(@Type,'')='Fixed' and @Disc>0) then 'Fixed' else '' end)

			select isnull((select CM.AutoId, FirstName +isnull(' '+LastName,'') as [Name],case when trim(FirstName)='Walk In' then 0 else isnull(CR.AssignedRoyaltyPoints,0) end as AssignedRoyaltyPoints from CustomerMaster CM Left Join CustomerRoyaltyPoints CR on CR.CustomerId=CM.AutoId
			where CM.AutoId=(select CustomerId from CartMaster where AutoId=@OrderId) for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
			isnull((
		Select csm.AutoId,csm.SKUId ,csm.SKUName, csm.SchemeId, csm.Quantity, isnull(MinAge,0) MinAge, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice,
		(case when (sm.ProductId!=0 and isnull(csm.SchemeId,0)=0)then 1 else 0 end)IsProduct,
		'/Images/ProductImages/'+(case when (SM.SKUImagePath!='' or SM.SKUImagePath!=null) then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
		then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
		from CartSKUMaster csm
		left join SKUMaster sm on sm.AutoId=csm.SKUId
		where OrderAutoId=@OrderId order by csm.AutoId Desc 
		for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
		isnull((
		select @OrderId OrderId, @OrderNo OrderNo, isnull(@Disc,0) Discount,@DiscType DiscType,@Discount DiscountPer,-- cm.DiscType from CartMaster cm where cm.AutoId=@OrderId for json path, INCLUDE_NULL_VALUES),'[]') as OrderDetail,
		isnull((select Count(*) from CartSKUMaster where OrderAutoId=@OrderId),0)ItemCount,
		isnull((select sum(Quantity) from CartSKUMaster where OrderAutoId=@OrderId),0)TotalQuantity,
		isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
		isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
		isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
		isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
		isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]
		for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
		for json path, INCLUDE_NULL_VALUES
		
   commit tran
   end try
   begin catch
     rollback tran
	 set @isException=1
	 set @exceptionMessage=ERROR_MESSAGE()
  end catch
  end
  end
  else If @Opcode=49
  Begin
  select AutoId,CustomerId,FirstName,LastName,
  (case when isnull(DOB,'')='' then '' when isnull(DOB,'')!='' then FORMAT(CONVERT(datetime,DOB),'MM/dd/yyyy')else '' end) DOB,
  MobileNo,PhoneNo,EmailId,Address,State,City,Country,ZipCode from CustomerMaster where AutoId=@CustomerId and StoreId=@StoreId and Status=1
  End

else If @Opcode=40
BEGIN
	DECLARE @AutoIDC int=null
	Declare @HourlyRate decimal(18,2)=isnull((select HourlyRate from UserDetailMaster where UserAutoId=@Who),0)	
	if not exists(select * from ClockINOUT where EmpId=@Who and ClockOUT is null and StoreId=@StoreId)
	BEGIN
		Insert into ClockINOUT( EmpId,Remark,ClockIN,ClockOUT,CreatedDate,StoreId,HourlyRate)
		values(@Who,@Remark,@DateTime,null,GETDATE(),@StoreId,@HourlyRate)

		set @AutoIDC = SCOPE_IDENTITY()

		Insert into ClockInOutLog(ClockINOUTAutoId,PreviousDate,NewDate,Remark,CreatedBy,CreatedDate,StoreId,HourlyRate)
		values(@AutoIDC,@DateTime,null,@Remark,@Who,GETDATE(),@StoreId,@HourlyRate)
	END
	Else
    begin
		 SET @exceptionMessage='Already Clocked In!'
         SET @isException=1
	  end
end
else If @Opcode=41
BEGIN
	select ClockOUT,format(ClockIn,'MM/dd/yyyy hh:mm:ss tt') as ClockIn from ClockINOUT where EmpId=@Who and ClockOUT is null and StoreId=@StoreId
end
else If @Opcode=42
BEGIN
	if exists(select * from ClockINOUT where EmpId=@Who and ClockOUT is null and StoreId=@StoreId)
	BEGIN		
		set @AutoIDC=(select AutoId from ClockINOUT where EmpId=@Who and ClockOUT is null and StoreId=@StoreId)

		update ClockINOUT set CloseRemark=@Remark,ClockOUT=@DateTime,UpdatedDate=getdate()  where EmpId=@Who and ClockOUT is null and StoreId=@StoreId
		
		update ClockInOutLog set CloseRemark=@Remark,NewDate=@DateTime where ClockINOUTAutoId=@AutoIDC and StoreId=@StoreId

	END
	Else
 begin
		 SET @exceptionMessage='Already Clocked Out!'
         SET @isException=1
	  end
end
else If @Opcode=43
BEGIN   
declare @SafeAutoId int=null
    insert into Safecash(Mode,Amount,Remark,Store,CreatedDate,CreatedBy,Terminal,Status,ShiftId)
        values (1,@PaidAmount,@Remark,@StoreId,GETDATE(),@Who,@TerminalId,0,@ShiftId)

        set @SafeAutoId = SCOPE_IDENTITY()

        select top 1 @SafeAutoId as AutoId from Safecash
end
else If @Opcode=54
BEGIN
    select SC.AutoId,SC.Mode,SC.Amount,SC.Remark,SC.Store,format(SC.CreatedDate,'MM/dd/yyyy hh:mm:ss tt') as CreatedDate,(UM.FirstName + ' ' + UM.LastName) as UserName,TM.TerminalName,SC.Status,SC.ShiftId,
    CP.BillingAddress,CP.CompanyName,CP.City+', '+CP.State+' - '+ Convert(varchar(6),CP.ZipCode) Address2,format(GETDATE(),'MM/dd/yyyy') as CurrentDate from SafeCash SC 
    Inner join UserDetailMaster UM on UM.UserAutoId=SC.CreatedBy
    left join TerminalMaster TM on TM.AutoId=SC.Terminal
    Inner Join CompanyProfile CP on CP.AutoId=SC.Store
    where SC.AutoId=@BalanceAutoId
end
else If @Opcode=55
BEGIN    
    insert into BreakLog(UserId,StoreId,TerminalId,ShiftId,BreakDateTime) 
	values (@Who,@StoreId,@TerminalId,@ShiftId,GETDATE())
	SET @exceptionMessage='Success'
	SET @isException=0
end
else If @Opcode=44
BEGIN
Declare @Total decimal(18,2)=null
	set @Total=(select top 1 isnull((isnull((select Sum(Amount) from Safecash where Mode=1 and Store=@StoreId),0)-isnull((select Sum(Amount) from Safecash where Mode=2 and Store=@StoreId),0)),0) as Total FROM Safecash where Store=@StoreId )
	if(isnull(@Total,0)<@PaidAmount)
	Begin
		Set @isException=1                                                                                                   
		Set @exceptionMessage='Insufficient Safe Cash Amount!'
	End
	Else
	Begin
	insert into Safecash(Mode,Amount,Remark,Store,CreatedDate,CreatedBy,Terminal,Status,ShiftId)
		values (2,@PaidAmount,@Remark,@StoreId,GETDATE(),@Who,@TerminalId,0,@ShiftId)

		set @SafeAutoId = SCOPE_IDENTITY()

        select top 1 @SafeAutoId as AutoId from Safecash
	End
end
else If @Opcode=15
BEGIN
    Insert into NoSale( TerminalId, OpenDate, OpenBy,StoreId,Remark)
	values(@TerminalId,GETDATE(),@Who,@StoreId,@Remark)
end
 else If @Opcode=22
BEGIN
 if((Select isnull(SPL.IsFavourite,0) from ProductMaster PM inner join  StoreWiseProductList SPL on SPL.ProductId=PM.AutoId where PM.AutoId=@ProductAutoId and SPL.StoreId=@StoreId)=0)
 begin
     Update StoreWiseProductList set IsFavourite=1 where ProductId=@ProductAutoId  and StoreId=@StoreId
     select 'Product added home page successfully!' as SuccessText,'1'as SuccessCode
 end
 else
 begin
     Update StoreWiseProductList set IsFavourite=0 where ProductId=@ProductAutoId  and StoreId=@StoreId
     select 'Product removed from home page!' as SuccessText,'0'as SuccessCode
 end
end
 else If @Opcode=29
BEGIN
if(trim(@Type)='Product')
begin
     if exists(Select * from ProductScreenMaster  where ProductId=@ProductAutoId and StoreId=@StoreId and ScreenId=@ScreenId)
     begin
         delete from ProductScreenMaster where ProductId=@ProductAutoId and ScreenId=@ScreenId and StoreId=@StoreId
         select 'Product removed from Screen successfully!' as SuccessText,'0'as SuccessCode
     end
     else
     begin
         insert into ProductScreenMaster (ProductId,ScreenId,StoreId,CreatedDate) values(@ProductAutoId,@ScreenId,@StoreId,GETDATE())
         select 'Product added in Screen!'  as SuccessText,'1'as SuccessCode
     end
 end
 else if(trim(@Type)='SKU')
 begin
     if exists(Select * from SKUScreenMaster  where SKUId=@ProductAutoId and StoreId=@StoreId and ScreenId=@ScreenId)
     begin
         delete from SKUScreenMaster where SKUId=@ProductAutoId and ScreenId=@ScreenId and StoreId=@StoreId
         select 'Product removed from Screen successfully!' as SuccessText,'0'as SuccessCode
     end
     else
     begin
         insert into SKUScreenMaster (SKUId,ScreenId,StoreId,CreatedDate) values(@ProductAutoId,@ScreenId,@StoreId,GETDATE())
         select 'Product added in Screen!'  as SuccessText,'1'as SuccessCode
     end
 end
 else if(trim(@Type)='Scheme')
 begin
     if exists(Select * from SchemeScreenMaster  where SchemeId=@ProductAutoId and StoreId=@StoreId and ScreenId=@ScreenId)
     begin
         delete from SchemeScreenMaster where SchemeId=@ProductAutoId and ScreenId=@ScreenId and StoreId=@StoreId
         select 'Product removed from Screen successfully!' as SuccessText,'0'as SuccessCode
     end
     else
     begin
         insert into SchemeScreenMaster (SchemeId,ScreenId,StoreId,CreatedDate) values(@ProductAutoId,@ScreenId,@StoreId,GETDATE())
         select 'Product added in Screen!'  as SuccessText,'1'as SuccessCode
     end
 end
end

if @Opcode=411
begin
    select ROW_NUMBER() over(order by NS.AutoId desc)RowNumber,NS.AutoId, UD.FirstName+' '+ISNULL(UD.LastName,'') as EmpName,UTM.UserType,
    isnull(TM.TerminalName,'')TerminalName,format(NS.OpenDate,'MM/dd/yyyy hh:mm tt')OpenDate,NS.Remark
    Into #TempNoSale
    from NoSale NS
    inner join UserDetailMaster UD on UD.UserAutoId=NS.OpenBy
    left join TerminalMaster TM on Tm.AutoId=NS.TerminalId
    inner join UserTypeMaster UTM on UTM.AutoId=UD.UserType
    where NS.StoreId=@StoreId and (@Who is null or @Who=0 or NS.OpenBy=@Who)
    and (@FromDate is null or @ToDate is null or (convert(date,NS.OpenDate) between convert(date,@FromDate) and convert(date,@ToDate)))
    and(@UserTypeId is null or @UserTypeId=0 or UD.UserType=@UserTypeId)
    SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By:Created date Desc' as SortByString
    FROM #TempNoSale     
	  
    Select  * from #TempNoSale t
    WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
    order by AutoId desc
end 

if @Opcode=412
begin
    select UserAutoId, FirstName +' '+ISNULL(LastName,'')+' ('+(UTM.UserType)+')' EmpName
	from UserDetailMaster UDM
	inner join UserTypeMaster UTM on UTM.AutoId=UDM.UserType
	inner join EmployeeStoreList EL on EL.EmployeeId=UDM.UserAutoId AND EL.Status=1
	where UDM.Status=1 and UDM.UserType=4 and EL.CompanyId=@StoreId 

	select * from UserTypeMaster where Status=1
end 

if @Opcode=413
begin
    select * from CardTypeMaster where status=1 order by seq asc

	
end 

if @Opcode=414
begin
    if exists(select * from GiftCardSale where CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and isnull(SoldStatus,0)=0 and StoreId=@StoreId)
	begin
	    set @isException=1
		Set @exceptionMessage='Gift Card is not sold yet!'
	end
	else if exists(select * from GiftCardSale where CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and isnull(SoldStatus,0) in (1,2) and isnull(leftAmt,0)=0 and StoreId=@StoreId)
	begin
	    set @isException=1
		Set @exceptionMessage='Gift Card has been already used!'
	end
	else
	begin
         select AutoId, GiftCardName, GiftCardCode, TotalAmt, LeftAmt from GiftCardSale where CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and StoreId=@StoreId
	end	
end

if @Opcode=415
begin
    if exists(select * from RoyaltyMaster where StoreId=@StoreId and Status=1)
	begin
	    select AutoId,AmtPerRoyaltyPoint,MinOrderAmt
		from RoyaltyMaster where StoreId=@StoreId
	end
	else
	begin
         set @isException=1
		 set @exceptionMessage='Not Applicable!'
	end	
end

if @Opcode=30
	BEGIN
	    update CartMaster set DraftName='',DraftDateTime='',ShowAsDraft=0,Isdeleted=1 where OrderNo=@OrderNo and StoreId=@StoreId-- AutoId=@OrderId
		--update CartMaster Set DraftName=@DraftName, DraftDateTime=getdate(),ShowAsDraft=0 where StoreId=@StoreId and OrderNo=@OrderNo
	END

 if @Opcode=50
      begin
           DEclare @dateR varchar(30)=null
           Select @SKUAutoId=[AutoId] from SKUMaster bm  where AutoId=@Barcode and StoreId=@StoreId
           declare @AutoId int=0,@AgeRestrict int=null, @SKUProductList varchar(max)=''
             
            set @AgeRestrict=(select max(ARM.Age) as Age from ProductMaster PM
            Inner join AgeRestrictionMaster ARM on ARM.AutoId=PM.AgeRestrictionId
            where  PM.AutoId in (Select SIM.ProductId from SKUItemMaster SIM where SIM.SKUAutoId=@SKUAutoId)  and ARM.Status=1 and PM.Status=1 )

           set @AutoId=(Select top 1 AutoId from SchemeMaster 
                        where Status=1 and StoreId=@StoreId and SKUAutoId=@SKUAutoId and Quantity<=@Quantity 
                        and (case when MaxQuantity=0 then @Quantity+1 else MaxQuantity end > @Quantity)
                        and (convert(date,getdate()) between  convert(date,isnull(FromDate, getdate())) and convert(date,isnull(ToDate, getdate())))
                        and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SchemeDaysString,''),',')))
                        )
						 
		     Select --SIM.[AutoId], SIM.[ProductId], 
		     @SKUProductList=(STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'<br/>'))
		     --,(select AutoId from ProductUnitDetail where ProductId=SIM.[ProductId] and StoreId=@StoreId and NoOfPieces=PUD.NoOfPieces) as [ProductUnitAutoId], 
		     --[Quantity], SIM.[UnitPrice], [Discount] ,DiscountPercentage,
		     --SIM.Tax,SIM.TaxPer as TaxPercentagePerUnit,PUD.AutoId as TaxAutoId, SIM.SKUItemTotal
		     from [dbo].[SKUItemMaster] SIM
			 inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
		     inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
		     inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		     inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
	         where SKUAutoId=@SKUAutoId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 
			 and SM.ProductId=0

            if(isnull(@AutoId,0)!=0)
            begin
              Select SM.SKUAutoId as SKUId, SM.SchemeName+(case when isnull(@SKUProductList,'')='' then isnull('<br/>'+SKUM.SKUPackingName,'') else isnull('<br/>'+@SKUProductList,'') end) SKUName,
			  SM.AutoId as SchemeId, @Quantity as Quantity, @Barcode as Barcode, 
              (case when SKUM.ProductId!=0 then (select PM.ImagePath from ProductMaster PM where AutoId=SKUM.ProductId) else SKUM.SKUImagePath end)SKUImagePath,
              convert(decimal(10,2),SM.UnitPrice) as UnitPrice, 
              SKUM.SKUDiscountTotal as SKUDiscountTotal,
              convert(decimal(10,2),SM.UnitPrice) as SKUSubTotal, 
              SM.Tax as Tax, 
              convert(decimal(10,2),@Quantity*(SM.UnitPrice+SM.Tax)) as Amount,@AgeRestrict as Age
              from SchemeMaster SM
              inner join SKUMaster SKUM on SM.SKUAutoId=SKUM.AutoId and SKUM.StoreId=@StoreId
              where SM.AutoId=@AutoId and SM.StoreId=@StoreId
              
              Select @SKUAutoId as SKUId, SIM.ProductAutoId as ProductId, SIM.PackingAutoId as PackingId, SIM.Quantity,
              convert(decimal(10,2),SIM.UnitPrice) as UnitPrice, 
              convert(decimal(10,2),SIM.Tax) as Tax,
              convert(decimal(10,2),SIM.Total) as Total,ARM.Age
              from SchemeItemMaster SIM 
               Inner Join ProductMaster PM on PM.AutoId=SIM.ProductAutoId
              Inner join AgeRestrictionMaster ARM on ARM.AutoId=PM.AgeRestrictionId
              where SIM.SchemeAutoId=@AutoId
            end
            else
            begin
              Select SM.AutoId as SKUId, SM.SKUPackingName+isnull('<br/>'+@SKUProductList,'') SKUName,
			  0 as SchemeId, @Quantity as Quantity, @Barcode as Barcode, 
              (case when SM.ProductId!=0 then (select PM.ImagePath from ProductMaster PM where AutoId=SM.ProductId) else SM.SKUImagePath end)SKUImagePath,
              SM.SKUUnitTotal as UnitPrice,
              SKUDiscountTotal as SKUDiscountTotal,
              SKUSubTotal as SKUSubTotal,
              SM.SKUTotalTax as Tax, 
              convert(decimal(10,2),@Quantity * SKUTotal) as Amount,@AgeRestrict as Age
              from SKUMaster SM
              where SM.AutoId=@SKUAutoId and StoreId=@StoreId

              Select SKUAutoId as SKUId, SIM.ProductId, SIM.Quantity,
              [UnitPrice], [Discount], [SKUItemTotal], Tax,ProductUnitAutoId as PackingId,ARM.Age
              from SKUItemMaster SIM
              Inner Join ProductMaster PM on PM.AutoId=SIM.ProductId
              Inner join AgeRestrictionMaster ARM on ARM.AutoId=PM.AgeRestrictionId
              where SIM.SKUAutoId=@SKUAutoId
            end
		--END
		--ELSE
		--BEGIN
		--Select 'Please verify the customer is a minimum of  ' + Convert(varchar(10),@AgeRestrict) + ' years old - born befor ' + format(convert(date,@dateR), 'MM/dd/yyyy') as Message
		--	--SET @exceptionMessage='Please verify the customer is a minimum of  ' + Convert(varchar(10),@AgeRestrict) + ' years old - born befor ' + @dateR
		--	--SET @isException=1
		--END
	end

 if @Opcode=53
 begin
    select AutoId,Status from CompanyProfile where AutoId=@StoreId and Status=1
 end

 if @Opcode=56
 begin
	select isnull(DraftName,'') DraftName,cm.FirstName+isnull(' '+cm.LastName,'')CustName,format(DraftDateTime, 'hh:mm tt <br> MM/dd/yyyy') DraftDateTime,OrderNo,DM.AutoId as OrderId,case when isnull(DraftName,'')!='' then 'Draft By User' else 'Auto Draft' end as [Type],
	UM.FirstName + ' ' + UM.LastName as UserName from CartMaster DM
	inner join CustomerMaster cm on cm.AutoId=DM.CustomerId
	Inner Join UserDetailMaster UM on UM.UserAutoId=DM.CreatedBy
	where DM.StoreId=@StoreId and isnull(DM.DraftName,'')!='' and TerminalId=@TerminalId and DM.ShowAsDraft=1
	and format(DraftDateTime, 'MM/dd/yyyy')=format(getdate(), 'MM/dd/yyyy')
	order by DM.AutoId desc
 end

 if @Opcode=57
 begin
      Select SM.AutoId as SKUId, SM.SKUName, 0 as SchemeId, DSM.Quantity as Quantity, SKUImagePath,SM.AutoId  as Barcode,
      SM.SKUUnitTotal as UnitPrice,
	  SKUDiscountTotal as SKUDiscountTotal,0 as Age,
	  --SKUSubTotal as SKUSubTotal,
	  (case when DSM.SchemeId!=0 then SCM.UnitPrice else SKUSubTotal end) SKUSubTotal,
      SM.SKUTotalTax as Tax, 
	  convert(decimal(10,2),dsm.Quantity * SKUTotal) as Amount,
	  (select top 1 Barcode from BarcodeMaster BM where BM.SKUId=SM.AutoId and StoreId=@StoreId)
      from DraftSKUMaster DSM
	  inner join SKUMaster SM on DSM.SKUId=SM.AutoId
	  left join SchemeMaster SCM on Scm.AutoId=DSm.SchemeId and SCM.StoreId=@StoreId
	  --inner join BarcodeMaster BM on bm.SKUId=SM.AutoId and BM.StoreId=@StoreId
	  where DSM.DraftAutoId=@DraftAutoId

	  Select SKUAutoId as SKUId, SIM.ProductId, SIM.Quantity,
	  SIM.[UnitPrice], SIM.[Discount], SIM.[SKUItemTotal], SIM.Tax,SIM.ProductUnitAutoId as PackingId,
	  0 as Age
	  from DraftSKUMaster DSM
	  inner join SKUItemMaster SIM  on SIM.SKUAutoId=DSM.SKUId
	  where DSM.DraftAutoId=@DraftAutoId

	  Select *,CM.FirstName+isnull(' '+cm.LastName,'')CustomerName from DraftMaster DM
	  inner join CustomerMaster CM on CM.AutoId=DM.CustomerId and CM.StoreId=@StoreId
	  where DM.AutoId=@DraftAutoId
	  
 end
 else if @Opcode=62
 begin
 Declare @IsStore int=null;
 declare @LottoPayout decimal(18,2)=0,@LottoSale decimal(18,2)=0,@LottoTotal  decimal(18,2)=0
 if exists(select StoreId from InvoicePrintDetails where StoreId=@StoreId)
	BEGIN
	     --declare @LottoPayout decimal(18,2)=0,@LottoSale decimal(18,2)=0,@LottoTotal  decimal(18,2)=0
	     --set @LottoPayout= isnull((Select sum(total) from InvoiceSKUMaster where InvoiceAutoId=@InvoiceAutoId and SKUName='Lottery Payout' ),0)
		 --set @LottoSale=isnull((Select sum(total) from InvoiceSKUMaster where InvoiceAutoId=@InvoiceAutoId and SKUName like '%Lottery%' ),0)
		 --isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0)
	     --set @LottoTotal=@LottoPayout+@LottoSale
		 set @LottoTotal=isnull((Select sum(total) from InvoiceSKUMaster where InvoiceAutoId=@InvoiceAutoId and SKUName like '%Lottery%' ),0)
		 
		 Select im.AutoId, InvoiceNo, format(InvoiceDate, 'MM/dd/yyyy hh:mm tt') as InvoiceDate, PaymentMethod, Tax, TempInvoiceNo, TransactionId, AuthCode, 
     	 cm.FirstName+' '+cm.LastName as CustomerName, im.Status,  format(im.UpdateDate, 'MM/dd/yyyy hh:mm tt') as UpdateDate, 
		 (Total-@LottoTotal-tax+isnull(Discount,0))as SubTotal,@LottoTotal LotteryTotal,IM.LeftAmt,
     	 udm.FirstName+' '+udm.LastName as SaleBY, im.Discount, im.Total, im.TerminalId, im.CardType, im.CardNo,Coupon,CouponAmt,isnull(GiftCardNo,'')GiftCardNo,isnull(GiftCardUsedAmt,0)GiftCardUsedAmt,isnull(EarnedRoyalty,0)EarnedRoyalty,
		 (select StoreName as CompanyName from InvoicePrintDetails where StoreId=@StoreId)CompanyName,
		 (select  BillingAddress from InvoicePrintDetails where StoreId=@StoreId)BillingAddress,
		 (select City+', '+State+' - '+ Convert(varchar(6),ZipCode) from InvoicePrintDetails where StoreId=@StoreId)Address2,
	     (select  ShowHappyPoints from InvoicePrintDetails where StoreId=@StoreId)ShowHappyPoints,
		 (select  ShowLogo from InvoicePrintDetails where StoreId=@StoreId)ShowLogo,
		 (select  Footer from InvoicePrintDetails where StoreId=@StoreId)Footer,
		 (select  ShowFooter from InvoicePrintDetails where StoreId=@StoreId)ShowFooter,

     	 isnull((
		 select ISM.AutoId, InvoiceAutoId,SM.productId,
		 (case when isnull(SCM.AutoId,0)!=0 then '**' when SM.ProductId=0 then '*' else '' end) ProductIdentifier ,
		 ISM.SKUId,
		 --(case when isnull(ISM.SchemeId,0)!=0 then SCM.SchemeName when isnull(SM.SKUName,'')='' then ISM.SKUName else SM.SKUShortName end)SKUName,
		 (case when (SM.SKUPackingName!=SKUShortName and ProductId!=0) then SM.SKUShortName else ISM.SKUName end)SKUName,
		 SchemeId,isnull(SCM.SchemeName,'')SchemeName,
		 --cast((case when isnull(SM.SKUName,'')='' and (ISM.SKUName='Lottery Payout' or ISM.SKUName='Lottery Sale' or ISM.SKUName like '%Gift Card%') then ISM.Total  when isnull(ism.SchemeId,0)!=0 then SCM.UnitPrice else SM.SKUSubTotal end) as decimal(18,2))as Price,
		 ISM.Price,
		 ISM.Quantity, ISM.Tax, Total,case when ISM.SKUName like '%Gift Card%' then '1' else '0' end as IsGift
		 --,(
		 --Select 
		 --    isnull((STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'<br/>')),'')
		 --    from [dbo].[SKUItemMaster] SIM
			-- inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
		 --    inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
		 --    inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		 --    inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
	  --       where SKUAutoId=ISM.SKUId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 and
			--(isnull(ISM.SchemeId,0)!=0 or (isnull(ISM.SchemeId,0)=0 and SM.ProductId=0))
		 --)as SKUProductList
		 from InvoiceSKUMaster ISM 
		 left join SKUMaster SM on sm.AutoId=ism.SKUId and SM.StoreId=@StoreId
		 left join SchemeMaster SCM on SCM.AutoId=ISM.SchemeId and SCM.StoreId=@StoreId
		 where ISM.InvoiceAutoId=IM.AutoId
		 order by isnull(ISM.ProductAddedSeq,0) desc
		 for json path,INCLUDE_NULL_VALUES),'[]')as InvoiceSKUList,

		 --isnull((
		 --Select iim.AutoId, SKUAutoId, 
		 --(case when isnull(pm.ProductName,'')!='' then pm.ProductName else (select SKUName from InvoiceSKUMaster where AutoId=iim.SKUAutoId) end) as ProductName, 
   --  	 isnull(ptm.PackingName,'')PackingName, iim.Quantity, iim.UnitPrice, iim.Tax, iim.Total, iim.TaxPer
   --  	 from InvoiceItemMaster iim 
   --  	 left join ProductMaster pm on pm.AutoId=iim.ProductId
		 --left join StoreWiseProductList SPL on SPL.ProductId=PM.AgeRestrictionId and SPL.StoreId=@StoreId
   --  	 left join ProductUnitDetail ptm on ptm.AutoId=iim.PackingId and ptm.StoreId=@StoreId
   --  	 where iim.SKUAutoId in (Select AutoId from InvoiceSKUMaster where InvoiceAutoId=im.AutoId)for json path,INCLUDE_NULL_VALUES),'[]')as InvoiceSKUItemList,
		 
		 isnull((
		 select 
		 (case when ITD.PaymentMode='Credit Card' then (ITD.PaymentMode+'('+isnull(CTM.CardNameAbbr,'')+'-'+isnull(ITD.CardNo,'')+')') else ITD.PaymentMode end)PaymentMode, 
		 Amount, CardType, CardNo 
		 from InvoiceTransactionDetail ITD
		 Left join CardTypeMaster CTM on CTM.AutoId=(case when ITD.PaymentMode='Credit Card' then cast(ITD.CardType as int) else 0 end)
		 left Join PaymentModeSeq PS on PS.PaymentMode=ITD.PaymentMode
		 where InvoiceAutoId=IM.AutoId
		 order by isnull(PS.SeqNo,0) Asc
		 for json path,INCLUDE_NULL_VALUES),'[]')as InvoiceTransactionList
		 from InvoiceMaster IM
     	 left join CustomerMaster cm on cm.AutoId=IM.CustomerId
     	 left join UserDetailMaster udm on udm.UserId=IM.UserId
     	 where im.AutoId=@InvoiceAutoId and IM.StoreId=@StoreId
		 for json Path,INCLUDE_NULL_VALUES

	END
	ELSE
	BEGIN
	    
	     --set @LottoPayout= isnull((Select sum(total) from InvoiceSKUMaster where InvoiceAutoId=@InvoiceAutoId and SKUName='Lottery Payout' ),0)
		 --set @LottoSale=isnull((Select sum(total) from InvoiceSKUMaster where InvoiceAutoId=@InvoiceAutoId and SKUName like '%Lottery%' ),0)
		 --isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0)
	     --set @LottoTotal=@LottoPayout+@LottoSale
		 set @LottoTotal=isnull((Select sum(total) from InvoiceSKUMaster where InvoiceAutoId=@InvoiceAutoId and SKUName like '%Lottery%' ),0)
		 
         Select im.AutoId, InvoiceNo, format(InvoiceDate, 'MM/dd/yyyy hh:mm tt') as InvoiceDate, PaymentMethod, Tax, TempInvoiceNo, TransactionId, AuthCode, 
     	 cm.FirstName+' '+cm.LastName as CustomerName, im.Status,  format(im.UpdateDate, 'MM/dd/yyyy hh:mm tt') as UpdateDate, 
		 (Total-tax+isnull(Discount,0))as SubTotal,@LottoTotal LotteryTotal,IM.LeftAmt,
     	 udm.FirstName+' '+udm.LastName as SaleBY, im.Discount, im.Total, im.TerminalId, im.CardType, im.CardNo,Coupon,CouponAmt,isnull(GiftCardNo,'')GiftCardNo,isnull(GiftCardUsedAmt,0)GiftCardUsedAmt,isnull(EarnedRoyalty,0)EarnedRoyalty,
		 (select CompanyName from CompanyProfile where AutoId=@StoreId)CompanyName,
		 (select  BillingAddress from CompanyProfile where AutoId=@StoreId)BillingAddress,
		 (select City+', '+State+' - '+ ZipCode from CompanyProfile where AutoId=@StoreId)Address2,0 as ShowHappyPoints,0 as ShowFooter,'' as Footer,0 as ShowLogo,
	
     	 isnull((
		 select ISM.AutoId,SM.productId,
		 (case when isnull(SCM.AutoId,0)!=0 then '**' when SM.ProductId=0 then '*' else '' end) ProductIdentifier , 
		 InvoiceAutoId, ISM.SKUId,
		 --(case when isnull(ISM.SchemeId,0)!=0 then SCM.SchemeName when isnull(SM.SKUName,'')='' then ISM.SKUName else SM.SKUShortName end)SKUName,
		  (case when (SM.SKUPackingName!=SKUShortName and ProductId!=0) then SM.SKUShortName else ISM.SKUName end)SKUName,
		 SchemeId,isnull(SCM.SchemeName,'')SchemeName,
		 --cast((case when isnull(SM.SKUName,'')='' and (ISM.SKUName='Lottery Payout' or ISM.SKUName='Lottery Sale' or ISM.SKUName like '%Gift Card%') then ISM.Total  when isnull(ism.SchemeId,0)!=0 then SCM.UnitPrice else SM.SKUSubTotal end) as decimal(18,2))as Price,
		 ISM.Price,
		 ISM.Quantity, ISM.Tax, Total,case when ISM.SKUName like '%Gift Card%' then '1' else '0' end as IsGift
		 --,(
		 --Select 
		 --    isnull((STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'<br/>')),'')
		 --    from [dbo].[SKUItemMaster] SIM
			-- inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
		 --    inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
		 --    inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		 --    inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
	  --       where SKUAutoId=ism.SKUId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 and 
			-- (isnull(ISM.SchemeId,0)!=0 or (isnull(ISM.SchemeId,0)=0 and SM.ProductId=0))
		 --)as SKUProductList
		 from InvoiceSKUMaster ISM 
		 left join SKUMaster SM on sm.AutoId=ism.SKUId and SM.StoreId=@StoreId
		 left join SchemeMaster SCM on SCM.AutoId=ISM.SchemeId and SCM.StoreId=@StoreId
		 where ISM.InvoiceAutoId=IM.AutoId
		 order by isnull(ISM.ProductAddedSeq,0) desc
		 for json path,INCLUDE_NULL_VALUES),'[]')as InvoiceSKUList,

		 --isnull((
		 --Select iim.AutoId, SKUAutoId, 
		 --(case when isnull(pm.ProductName,'')!='' then pm.ProductName else (select SKUName from InvoiceSKUMaster where AutoId=iim.SKUAutoId) end) as ProductName, 
   --  	 isnull(ptm.PackingName,'')PackingName, iim.Quantity, iim.UnitPrice, iim.Tax, iim.Total, iim.TaxPer
   --  	 from InvoiceItemMaster iim 
   --  	 left join ProductMaster pm on pm.AutoId=iim.ProductId
		 --left join StoreWiseProductList SPL on SPL.ProductId=PM.AgeRestrictionId and SPL.StoreId=@StoreId
   --  	 left join ProductUnitDetail ptm on ptm.AutoId=iim.PackingId and ptm.StoreId=@StoreId
   --  	 where iim.SKUAutoId in (Select AutoId from InvoiceSKUMaster where InvoiceAutoId=im.AutoId)for json path,INCLUDE_NULL_VALUES),'[]')as InvoiceSKUItemList,
		 
		 isnull((
		 select 
		 (case when ITD.PaymentMode='Credit Card' then (PaymentMode+'('+isnull(CTM.CardNameAbbr,'')+'-'+isnull(ITD.CardNo,'')+')') else PaymentMode end)PaymentMode, 
		 Amount, CardType, CardNo 
		 from InvoiceTransactionDetail ITD
		 Left join CardTypeMaster CTM on CTM.AutoId=(case when ITD.PaymentMode='Credit Card' then cast(ITD.CardType as int) else 0 end)
		 where InvoiceAutoId=IM.AutoId
		 order by PaymentMode desc
		 for json path,INCLUDE_NULL_VALUES),'[]')as InvoiceTransactionList
		 from InvoiceMaster IM
     	 left join CustomerMaster cm on cm.AutoId=IM.CustomerId
     	 left join UserDetailMaster udm on udm.UserId=IM.UserId
     	 where im.AutoId=@InvoiceAutoId and IM.StoreId=@StoreId
		 for json Path,INCLUDE_NULL_VALUES
	END
 end
 else if @Opcode=63
 begin
      select ROW_NUMBER() over(order by IM.AutoId desc)RowNumber,IM.AutoId, InvoiceNo, format(InvoiceDate,'MM/dd/yyyy hh:mm tt')InvoiceDate, PaymentMethod
	  , cast(Tax as decimal(18,2))Tax, IM.CustomerId,CM.FirstName+isnull(' '+CM.LastName,'')CustomerName, IM.Status,IM.UserId,
	  isnull(UM.FirstName,'')+isnull(' '+UM.LastName,'')+'<br/>'+format(UpdateDate,'MM/dd/yyyy hh:mm tt')UpdationDetails, 
	  cast(Discount as decimal(18,2))Discount, cast(Total as decimal(18,2))Total, IM.TerminalId, Coupon,TM.TerminalName,
	  cast(CouponAmt as decimal(18,2))CouponAmt,CreatedFrom
	  into #Temp
	  from InvoiceMaster IM
	  left join CustomerMaster CM on CM.AutoId=IM.CustomerId
	  left join TerminalMaster TM on TM.AutoId=IM.TerminalId
	  left join UserDetailMaster UM on Um.UserAutoId=IM.UpdateBy
	  where IM.StoreId=@StoreId and (@CustomerName is null or @CustomerName='' or CM.FirstName+isnull(' '+CM.LastName,'') like '%'+@CustomerName+'%')
	  and (@InvoiceNo is null or @InvoiceNo='' or InvoiceNo like '%'+@InvoiceNo+'%')
	  and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or ( convert(date,InvoiceDate) between convert(date,@FromDate) and convert(date,@ToDate)))
	  and (@CreatedFrom is null or @CreatedFrom='0' or CreatedFrom=@CreatedFrom)
	   and (@TerminalId is null or @TerminalId='0' or IM.TerminalId=@TerminalId)

	  SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Date & Time Desc' as SortByString
	  FROM #Temp      
	  
      Select  * from #Temp t
      WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
      order by AutoId desc

 end
 else if @Opcode=64
 begin   
   --      --when isnull(ISM.SchemeId,0)!=0 then SCM.SchemeName
   --      select ISM.AutoId, InvoiceAutoId, ISM.SKUId,(case  when isnull(SM.SKUPackingName,'')='' then ISM.SKUName else SM.SKUPackingName end) SKUName, SchemeId,isnull(SCM.SchemeName,'')SchemeName,
		 ----cast((case when isnull(SM.SKUName,'')='' and (ISM.SKUName='Lottery Payout' or ISM.SKUName='Lottery Sale' or ISM.SKUName like '%Gift Card%') then ISM.Total  when isnull(ism.SchemeId,0)!=0 then SCM.UnitPrice else SM.SKUSubTotal end) as decimal(18,2))as Price,
		 --ISM.Price,
		 --ISM.Quantity, cast(ISM.Tax as decimal(18,2))Tax, (cast(Total as decimal(18,2))-cast(ISM.Tax as decimal(18,2)))Total,case when ISM.SKUName like '%Gift Card%' then '1' else '0' end as IsGift
		 --from InvoiceSKUMaster ISM 
		 --left join SKUMaster SM on sm.AutoId=ism.SKUId
		 --left join SchemeMaster SCM on SCM.AutoId=ISM.SchemeId
		 --where ISM.InvoiceAutoId=@InvoiceAutoId
		 --order by ISM.AutoId desc
		 select ISM.AutoId,SM.productId,
		 (case when isnull(SCM.AutoId,0)!=0 then '**' when SM.ProductId=0 then '*' else '' end) ProductIdentifier , 
		 InvoiceAutoId, ISM.SKUId,
		 --(case when isnull(ISM.SchemeId,0)!=0 then SCM.SchemeName when isnull(SM.SKUName,'')='' then ISM.SKUName else SM.SKUShortName end)SKUName,
		  (case when (SM.SKUPackingName!=SKUShortName and ProductId!=0) then SM.SKUShortName else ISM.SKUName end)SKUName,
		 SchemeId,isnull(SCM.SchemeName,'')SchemeName,
		 --cast((case when isnull(SM.SKUName,'')='' and (ISM.SKUName='Lottery Payout' or ISM.SKUName='Lottery Sale' or ISM.SKUName like '%Gift Card%') then ISM.Total  when isnull(ism.SchemeId,0)!=0 then SCM.UnitPrice else SM.SKUSubTotal end) as decimal(18,2))as Price,
		 ISM.Price,
		 ISM.Quantity, ISM.Tax, cast((ISM.Quantity * ISM.Price) as decimal(18,2))Total,case when ISM.SKUName like '%Gift Card%' then '1' else '0' end as IsGift
		 --,(
		 --Select 
		 --    isnull((STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'<br/>')),'')
		 --    from [dbo].[SKUItemMaster] SIM
			-- inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
		 --    inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
		 --    inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		 --    inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
	  --       where SKUAutoId=ism.SKUId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 and 
			-- (isnull(ISM.SchemeId,0)!=0 or (isnull(ISM.SchemeId,0)=0 and SM.ProductId=0))
		 --)as SKUProductList
		 from InvoiceSKUMaster ISM 
		 left join SKUMaster SM on sm.AutoId=ism.SKUId and SM.StoreId=@StoreId
		 left join SchemeMaster SCM on SCM.AutoId=ISM.SchemeId and SCM.StoreId=@StoreId
		 where ISM.InvoiceAutoId=@InvoiceAutoId
		 order by isnull(ISM.ProductAddedSeq,0) desc

		 set @LottoTotal=isnull((Select sum(total) from InvoiceSKUMaster where InvoiceAutoId=@InvoiceAutoId and SKUName like '%Lottery%' ),0)
		 

		 Select im.AutoId, InvoiceNo, format(InvoiceDate, 'MM/dd/yyyy hh:mm tt') as InvoiceDate, PaymentMethod, Tax, 
     	 cm.FirstName+' '+cm.LastName as CustomerName, im.Status,  format(im.UpdateDate, 'MM/dd/yyyy hh:mm tt') as UpdateDate, (Total-@LottoTotal-tax+isnull(Discount,0))as SubTotal,
		 udm.FirstName+' '+udm.LastName as SaleBY, im.Discount, im.Total,@LottoTotal LotteryTotal , im.TerminalId, im.CardType, im.CardNo,Coupon,isnull(CouponAmt,0)CouponAmt,
		 isnull(GiftCardNo,'')GiftCardNo,isnull(GiftCardUsedAmt,0)GiftCardUsedAmt,isnull(EarnedRoyalty,0)EarnedRoyalty,IM.LeftAmt,
		 (select Count(1) from InvoiceSKUMaster ISM where ISM.InvoiceAutoId=IM.AutoId) as ItemCount,IM.EarnedRoyalty as HappyPoints,IM.CustomerId,cp.AssignedRoyaltyPoints
		 from InvoiceMaster IM
     	 left join CustomerMaster cm on cm.AutoId=IM.CustomerId
		 left join CustomerRoyaltyPoints cp on cp.CustomerId=IM.CustomerId
     	 left join UserDetailMaster udm on udm.UserId=IM.UserId
     	 where im.AutoId=@InvoiceAutoId

		 select 
		 (case when ITD.PaymentMode='Credit Card' then (ITD.PaymentMode+'('+isnull(CTM.CardNameAbbr,'')+'-'+isnull(ITD.CardNo,'')+')') else ITD.PaymentMode end)PaymentMode, 
		 Amount, CardType, CardNo 
		 from InvoiceTransactionDetail ITD
		 Left join CardTypeMaster CTM on CTM.AutoId=(case when ITD.PaymentMode='Credit Card' then cast(ITD.CardType as int) else 0 end)
		 left Join PaymentModeSeq PS on PS.PaymentMode=ITD.PaymentMode
		 --where InvoiceAutoId=IM.AutoId
		 
		 where InvoiceAutoId=@InvoiceAutoId
		 --order by PaymentMode desc
		 order by isnull(PS.SeqNo,0) Asc
 end
 else if @Opcode=65
 begin
       if ((select SecurityPin from tbl_SecurityPinMaster where UserId=@Who and Status=1 and Type='Admin')=@SecuirtyCode)
	  begin
		   select UserType EmpTypeNo,(select UserType from UserTypeMaster Um where Um.AutoId=UDM.UserType) AS [EmpType]
		   from UserDetailMaster UDM where UserAutoId=@Who
		   SET @exceptionMessage='Success'
           SET @isException=0
	  end
	  else
	  begin
		 SET @exceptionMessage='failed'
         SET @isException=1
	  end
 end
 else if @Opcode=100
 begin
    select * into #TempSearchList from (
	Select PM.AutoId, 
    (case when SKUCount=1 then (select SKUPackingName from SKUMaster where ProductId=PM.AutoId and StoreId=@StoreId and Status=1)else  ProductSizeName end) ProductName, 
	ViewImage, ImagePath, SKUCount,ARM.Age,
	case when SKUCount=1 then (select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1 and StoreId=@StoreId and Status=1) else '' end as Barcode,
	case when SKUCount=1 then (Select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1 and StoreId=@StoreId and Status=1) else 0 end as SKUAutoId,
	case when isnull(SKUCount,0)=1 then (Select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithSignleUnit')
	when isnull(SKUCount,0)>1 then (Select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithMultipleUnit')
	else (Select ColorCode from tbl_ColorCodeMaster where ElementName='BG_Error') end as BG_ColorCode,
	case when isnull(SKUCount,0)=1 then (Select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithSignleUnit')
	when isnull(SKUCount,0)>1 then (Select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithMultipleUnit')
	else (Select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_Error') end as TEXT_ColorCode,1 Quantity
	from ProductMaster pm
	Left join AgeRestrictionMaster ARM on ARM.AutoId=PM.AgeRestrictionId 
	inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=@StoreId
	where SPL.Status=1 and pm.Status=1 and SKUCount>0
	and (@ProductName is null or @ProductName='' or pm.AutoId in (select ProductId from SKUMaster t where replace(t.SKUPackingName,' ','') like '%'+replace(trim(@ProductName),' ','')+'%'))
	and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
	and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
	and (@Fav is null  or @Fav=0 or SPL.IsFavourite=@Fav)
	--order by pm.ProductName

	union 

	Select SM.AutoId, SKUPackingName ProductName, 1 ViewImage, SKUImagePath, 1 SKUCount,'0' Age,
	SM.AutoId as Barcode,SM.AutoId as SKUAutoId,
	case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithSignleUnit')
	else (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_SKU') end BG_ColorCode,
	case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithSignleUnit')
	else (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_SKU') end TEXT_ColorCode, 1 Quantity
	from SKUMaster SM
	--left join SKUScreenMaster SSM on SSM.SKUId=SM.AutoId and SSM.StoreId=@StoreId and SSM.ScreenId=@ScreenId
	where SM.Status=1 and SM.AutoId in(
	       select distinct SKUAutoId from SKUItemMaster SIM
	       inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId and SM.ProductId=0
	       inner join ProductMaster PM on PM.AutoId=SIm.ProductId
	       where SM.Status=1 and SM.ProductId=0
	       --and (@ProductName is null or @ProductName='' or SM.SKUPackingName like '%'+trim(@ProductName)+'%')
	       and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
	       and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
	)
	and StoreId=@StoreId
	and (@ProductName is null or @ProductName='' or replace(SM.SKUPackingName,' ','') like '%'+replace(trim(@ProductName),' ','')+'%')
	--and (@ScreenId is null  or @ScreenId=0 or SSM.ScreenId=@ScreenId)

	union 

	Select SM.AutoId, SM.SchemeName ProductName, 1 ViewImage, SKUImagePath, 1 SKUCount,'0' Age,
	SM.SKUAutoId as Barcode,SM.SKUAutoId as SKUAutoId,
	(select ColorCode from tbl_ColorCodeMaster where ElementName='BG_Scheme') BG_ColorCode,
	 (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_Scheme') TEXT_ColorCode, SM.Quantity Quantity
	from SchemeMaster SM
	inner join SKUMaster SMM on SMM.AutoId=SM.SKUAutoId
	--left join SchemeScreenMaster SSM on SSM.SchemeId=SM.AutoId and SSM.StoreId=@StoreId and SSM.ScreenId=@ScreenId
	where SM.Status=1 and SM.SKUAutoId in(
	       select distinct SKUAutoId from SKUItemMaster SIM
	       inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId --and SM.ProductId=0
	       inner join ProductMaster PM on PM.AutoId=SIm.ProductId
	       where SM.Status=1 --and SM.ProductId=0
	       --and (@ProductName is null or @ProductName='' or SM.SKUPackingName like '%'+trim(@ProductName)+'%')
	       and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
	       and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
	)
	and SMM.StoreId=@StoreId and SM.StoreId=@StoreId
	and (@ProductName is null or @ProductName='' or SM.SchemeName like '%'+trim(@ProductName)+'%')
	and (convert(date,getdate()) between  convert(date,isnull(SM.FromDate, getdate())) and convert(date,isnull(SM.ToDate, getdate())))
	and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SM.SchemeDaysString,''),',')))
	--and (@ScreenId is null  or @ScreenId=0 or SSM.ScreenId=@ScreenId)
	)t

	if((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=1)
    Begin
        select * from #TempSearchList
        order by ProductName
    End
    Else
    Begin
        select * from #TempSearchList
        where ProductName not like 'Lottery%'  order by ProductName
    End

 end
  else if @Opcode=31
 begin
    --to update the Status of SKUMaster of Inactive units---
	update SM set SM.Status=0
    --select *  
    from SKUItemMaster SIM
    inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
    inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
    where PUD.Status=0 and SM.Status=1 and SM.productId!=0
	--------------------------------------------------------
    if (@ScreenId=1)
	begin
	   set @ScreenId=(select AutoId from ScreenMaster where StoreId=@StoreId and trim([Name])=trim('Home Screen'))
	end
	else if(@ScreenId=2)
	begin
	   set @ScreenId=(select AutoId from ScreenMaster where StoreId=@StoreId and trim([Name])= trim('Lottery'))
	end
	set @ScreenName=(select Name from ScreenMaster where StoreId=@StoreId and AutoId=@ScreenId)

	select * into #TempList from(
	select 
    PM.AutoId, 
    (case when SKUCount=1 then (select SKUPackingName from SKUMaster where ProductId=PM.AutoId and StoreId=@StoreId and Status=1)else  ProductSizeName end)  ProductName, 
    ViewImage, ImagePath, SKUCount,ARM.Age,
    case when SKUCount=1 then (select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1 and StoreId=@StoreId and Status=1) else '' end as Barcode,
    case when SKUCount=1 then (Select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1 and StoreId=@StoreId and Status=1) else 0 end as SKUAutoId,PSM.CreatedDate as CreatedDate,
    case when isnull(SKUCount,0)=1 then (Select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithSignleUnit')
    when isnull(SKUCount,0)>1 then (Select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithMultipleUnit')
    else (Select ColorCode from tbl_ColorCodeMaster where ElementName='BG_Error') end as BG_ColorCode,
    case when isnull(SKUCount,0)=1 then (Select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithSignleUnit')
    when isnull(SKUCount,0)>1 then (Select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithMultipleUnit')
    else (Select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_Error') end as TEXT_ColorCode, 1 Quantity 
    from ProductScreenMaster PSM 
    inner join ProductMaster PM on PM.AutoId=PSM.ProductId
    inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=@StoreId
    --left join SKUMaster SM on SM.ProductId=PM.AutoId 
    Left join AgeRestrictionMaster ARM on ARM.AutoId=PM.AgeRestrictionId
    where SPL.Status=1  --and --pm.Status=1 
    and SPL.SKUCount>0 --and SM.Status=1
    and (@ProductName is null or @ProductName='' or PM.ProductSizeName like '%'+trim(@ProductName)+'%')
    and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
    and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
    and (@ScreenId is null  or @ScreenId=0 or  PSM.ScreenId=@ScreenId)

	union 

	Select SM.AutoId, SKUPackingName ProductName, 1 ViewImage, SKUImagePath, 1 SKUCount,'0' Age,
	SM.AutoId as Barcode,SM.AutoId as SKUAutoId,SSM.CreatedDate as CreatedDate,
	case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithSignleUnit')
	else (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_SKU') end BG_ColorCode,
	case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithSignleUnit')
	else (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_SKU') end TEXT_ColorCode, 1 Quantity
	from 
	SKUScreenMaster SSM
	inner join SKUMaster SM on SM.AutoId=SSM.SKUId
	--from SKUMaster SM
	--left join SKUScreenMaster SSM on SSM.SKUId=SM.AutoId and  
	where SSM.StoreId=@StoreId and SSM.ScreenId=@ScreenId and SM.Status=1 and SM.AutoId in(
	       select distinct SKUAutoId from SKUItemMaster SIM
	       inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId and SM.ProductId=0
	       inner join ProductMaster PM on PM.AutoId=SIm.ProductId
	       where SM.Status=1 and SM.ProductId=0
	       --and (@ProductName is null or @ProductName='' or SM.SKUPackingName like '%'+trim(@ProductName)+'%')
	       and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
	       and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
	)
	and (@ProductName is null or @ProductName='' or SM.SKUPackingName like '%'+trim(@ProductName)+'%')
	and (@ScreenId is null  or @ScreenId=0 or SSM.ScreenId=@ScreenId)
	and SM.StoreId=@StoreId

	union 

	Select SM.AutoId, SM.SchemeName ProductName, 1 ViewImage, SKUImagePath, 1 SKUCount,'0' Age,
	SM.SKUAutoId as Barcode,SM.SKUAutoId as SKUAutoId,SSM.CreatedDate as CreatedDate,
	(select ColorCode from tbl_ColorCodeMaster where ElementName='BG_Scheme') BG_ColorCode,
	 (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_Scheme') TEXT_ColorCode, SM.Quantity Quantity
	from SchemeScreenMaster SSM 
	inner join SchemeMaster SM on SM.AutoId=SSM.SchemeId
	--from SchemeMaster SM
	inner join SKUMaster SMM on SMM.AutoId=SM.SKUAutoId
	--left join SchemeScreenMaster SSM on SSM.SchemeId=SM.AutoId 
	where SSM.StoreId=@StoreId and SSM.ScreenId=@ScreenId and SM.Status=1 and SM.SKUAutoId in(
	       select distinct SKUAutoId from SKUItemMaster SIM
	       inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId --and SM.ProductId=0
	       inner join ProductMaster PM on PM.AutoId=SIm.ProductId
	       where SM.Status=1 and SM.StoreId=@StoreId
	       --and (@ProductName is null or @ProductName='' or SM.SKUPackingName like '%'+trim(@ProductName)+'%')
	       and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
	       and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
	)
	and (@ProductName is null or @ProductName='' or SM.SchemeName like '%'+trim(@ProductName)+'%')
	and (@ScreenId is null  or @ScreenId=0 or SSM.ScreenId=@ScreenId)
	and (convert(date,getdate()) between  isnull(convert(date,SM.FromDate), convert(date,getdate())) and isnull(convert(date,SM.ToDate), convert(date,getdate())))
	and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SM.SchemeDaysString,''),',')))
	and SMM.StoreId=@StoreId and SM.StoreId=@StoreId
	)t

	 select * from #TempList 
	 order by case when isnull(@ScreenId,0)=2 then AutoId end asc,
     case when isnull(@ScreenId,0)!=2 then  CreatedDate end desc

	select top 1 @ScreenId as ScreenId,@ScreenName as ScreenName from StateMaster
 end
 else if @Opcode=101
 begin
      select AutoId,State as State1 from StateMaster

	  select AutoId,(FirstName+' '+isnull(LastName,''))as Name from CustomerMaster where FirstName='Walk In' and StoreId=@StoreId

	  select AutoId,AmtPerRoyaltyPoint,isnull(MinOrderAmt,0)MinOrderAmt,(case when Status=1 then 'Active' else 'Inactive' end)Status from RoyaltyMaster where StoreId=@StoreId and Status=1

		
 end
  else if @Opcode=107
 begin
	  select AutoId,DepartmentName from DepartmentMaster 
	  where Status=1 
	  and ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=1 or ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=0 and DepartmentName not like 'Lottery%'))
	  order by isnull(SeqNo,0) desc
 end
 else if @Opcode=102
 begin
 
	   If(isnull(@MobileNo,'')!='' and EXISTS(Select MobileNo from CustomerMaster where MobileNo=@MobileNo and StoreId=@StoreId))
     Begin
        Set @isException=1
        Set @exceptionMessage='Mobile no. already exists!'
     End	 
     ELSE
	 BEGIN
	 BEGIN TRY
	 BEGIN TRAN
            declare @CustomerAutoId int=0;
            SET @CustomerId = (SELECT DBO.SequenceCodeGenerator('CustomerNo'))  		 	
			insert into CustomerMaster(CustomerId, FirstName, LastName, DOB, MobileNo, PhoneNo, EmailId, Address, State, City, Country, ZipCode, Status,StoreId)
			values (@CustomerId, @FirstName, @LastName, @DOB, @MobileNo, '', @EmailId, @Address, @State, @City, '', @ZipCode, 1,@StoreId)
			set @CustomerAutoId=SCOPE_IDENTITY();
			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CustomerNo'
			--Select @CustomerId as CustomerId
			select AutoId,(FirstName+' '+isnull(LastName,''))Name from CustomerMaster where AutoId=@CustomerAutoId
	 COMMIT TRANSACTION    
	END TRY                                          
	BEGIN CATCH     
	ROLLBACK TRAN                                                               
	Set @isException=1        
	Set @exceptionMessage=ERROR_MESSAGE()   
	End Catch      
	END
	
 end
 else if @Opcode=103
 begin
            select ROW_NUMBER() over(order by isnull(seqNo,0) desc,FirstName asc) as RowNumber,AutoId, CustomerId, 
			FirstName+' '+ isnull(LastName,'') as Name, DOB, MobileNo, PhoneNo, EmailId, Address, State, City, 
			Country, ZipCode, Status
			into #temp1  
			from CustomerMaster CM
			where Status=1 and isnull(StoreId,1)=@StoreId --and AutoId!=1
			and (@FirstName is null or @FirstName='' or FirstName+' '+ISNULL(LastName,'') like '%'+@FirstName+'%')
			and (@MobileNo is null or @MobileNo='' or isnull(MobileNo,'') like '%'+@MobileNo+'%')
			and (@EmailId is null or @EmailId='' or isnull(EmailId,'') like '%'+@EmailId+'%')
			and (@CustomerIdG is null or @CustomerIdG='' or CustomerId=@CustomerIdG)
			order by isnull(seqNo,0) desc,FirstName asc

			SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,
			'#Sort By: Customer Id asc' as SortByString FROM #temp1      
      
            Select  *,CM.TotalPurchase,
			isnull(CP.AssignedRoyaltyPoints,0) as RoyaltyPoint 
			from #temp1 t Left Join CustomerMaster CM on CM.AutoID=t.AutoId   
			Left JOin CustomerRoyaltyPoints CP ON CP.CustomerId=t.AutoId
            WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
            order by RowNumber asc 
 end
 else if @Opcode=104
 begin

    declare @SymbolString nvarchar(50)='';
	set @SymbolString=(select isnull(CurrencySymbol,'') from CurrencySymbolMaster C inner join CompanyProfile D on C.AutoId=D.CurrencyID where D.AutoId=@StoreId)
	Select SM.AutoId as SKUAutoId,SM.SKUName,
	(select top 1 AUtoId from SKUMaster where AutoId=SM.AutoId and StoreId=@StoreId) as Barcode,SM.SKUTotal,
	@ProductAutoId ProductAutoID,
	isnull((select PackingName+'<br/>'+@SymbolString+convert(varchar(50),PUD.SellingPrice) from ProductUnitDetail PUD where StoreId=@StoreId and PUD.AutoId=(select ProductUnitAutoId from SKUItemMaster SIM where SIM.ProductId=SM.ProductId and SIM.SKUAutoId=SM.AutoId)),'') PackingName,
	case when SM.ProductId!=0 then 1 else 0 end as skutype,
	case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithSignleUnit')
	else (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_SKU') end BG_ColorCode,
	case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithSignleUnit')
	else (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_SKU') end TEXT_ColorCode,
	[Age]=(select ARM.Age from ProductMaster PM Inner join AgeRestrictionMaster ARM on ARM.AutoId=PM.AgeRestrictionId where PM.AutoId=@ProductAutoId)
	from SKUMaster SM
	where SM.Status=1 and StoreId=@StoreId and SM.ProductId!=0 and
	(SM.ProductId=@ProductAutoId or SM.AutoId in (select SKUAutoId from SKUItemMaster where ProductId=@ProductAutoId ))
	order by SM.SKUName

	select ProductName from ProductMaster  where AutoId=@ProductAutoId
 end
 else if @Opcode=105
 begin
 if exists(Select AutoId as SKUAutoId, @Barcode as Barcode from SKUMaster SM where SM.StoreId=@StoreId and SM.AutoId in (Select SKUId from BarcodeMaster where Barcode=@Barcode and StoreId=@StoreId) and Status=1 and isnull((select Status1 from StoreWiseProductList where AutoId=(select top 1 StoreProductId from BarcodeMaster where Barcode=@Barcode and StoreId=@StoreId)),1)=1)
 begin
	if((Select count(SKUId) from BarcodeMaster where Barcode=@Barcode and StoreId=@StoreId)>1)
	BEGIN
		Select distinct PM.AutoId, ProductSizeName ProductName, ViewImage, ImagePath, SKUCount,ARM.Age,
		case when SKUCount=1 then (select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1 and StoreId=@StoreId and Status=1) else '' end as Barcode,
		case when SKUCount=1 then (Select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1 and StoreId=@StoreId and Status=1) else 0 end as SKUAutoId	
		from ProductMaster pm
		Inner join AgeRestrictionMaster ARM on ARM.AutoId=PM.AgeRestrictionId
		inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=@StoreId
		inner join BarcodeMaster BM on BM.StoreProductId=SPL.AutoId and BM.StoreId=@StoreId
		where SPL.Status=1 and pm.Status=1 and BM.Barcode=@Barcode
	END
	Else
	BEGIN
		Select  SPL.AutoId, SPL.SKUPackingName as ProductName,SKUImagePath ViewImage,SKUImagePath ImagePath,'1' SKUCount,(select max(AR.Age) from ProductMaster PM Inner JOIN SKUItemMaster SIM on SIM.ProductId=PM.AutoId 
	    INNER JOIN AgeRestrictionMaster AR on AR.AutoId=PM.AgeRestrictionId where SKUAutoId=SPL.AutoId and SPL.StoreId=@StoreId) as Age,
	    SPL.AutoId as Barcode, SPL.AutoId as SKUAutoId	
	    from SKUMaster SPL
	    inner join BarcodeMaster BM on BM.SKUId=SPL.AutoId and BM.StoreId=@StoreId
	    where SPL.Status=1 and BM.Barcode=@Barcode and SPL.StoreId=@StoreId
	END
 end
 else
 begin
    set @isException=1
	set @exceptionMessage='No Barcode Found!'
 end
 
 end
 else if @Opcode=106
 begin
	Select ROW_NUMBER() over(order by ProductName asc) as RowNumber, PM.AutoId, ProductName, ImagePath, IsFavourite as Favorite
	into #temp106
	from ProductMaster PM
	inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPl.StoreId=ISNULL(@StoreId,0)
	Inner Join DepartmentMaster DM on PM.DeptId=DM.AutoId
	where SPL.Status=1
	and (@ProductName is null or @ProductName='' or  ProductName like @ProductName +'%')
	and (@Department is null or @Department=0 or  DM.AutoId=@Department)

	SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, '#Sort By: Product Name ASC' as SortByString FROM #temp106 

	Select  * from #temp106 t      
	WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
	order by  ProductName asc      
 end

  else if @Opcode=108
 begin
	Select ROW_NUMBER() over(order by ProductName asc) as RowNumber, * into #temp107 from ( 
	select PM.AutoId, PM.ProductSizeName ProductName, ImagePath,(case when PSM.ScreenId=@ScreenId then 0  else 1 end )as Checked	, 'Product' Type
	from ProductMaster PM
	inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=ISNULL(@StoreId,0)
	left join ProductScreenMaster PSM on PSM.ProductId=PM.AutoId and PSM.StoreId=ISNULL(@StoreId,0)
	Inner Join DepartmentMaster DM on PM.DeptId=DM.AutoId
	where SPL.Status=1
	and (@ProductName is null or @ProductName='' or  ProductSizeName like '%'+ @ProductName +'%')
	and (@Department is null or @Department=0 or  DM.AutoId=@Department)
	and PSM.ScreenId=@ScreenId

	union

	select PM.AutoId, PM.ProductSizeName ProductName, ImagePath,(case when PSM.ScreenId=@ScreenId then 0  else 1 end) as Checked	, 'Product' Type
	from ProductMaster PM
	inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPl.StoreId=ISNULL(@StoreId,0)
	left join ProductScreenMaster PSM on PSM.ProductId=PM.AutoId and PSM.StoreId=ISNULL(@StoreId,0) and PSM.ScreenId=@ScreenId
	Inner Join DepartmentMaster DM on PM.DeptId=DM.AutoId
	where SPL.Status=1
	and (@ProductName is null or @ProductName='' or  ProductSizeName like '%'+ @ProductName +'%')
	and (@Department is null or @Department=0 or  DM.AutoId=@Department)

	union 

	select SM.AutoId, SM.SKUPackingName ProductName, SM.SKUImagePath ImagePath,(case when SSM.ScreenId=@ScreenId then 0  else 1 end) as Checked	, 'SKU' Type
	from SKUMaster SM
	INNER join SKUScreenMaster SSM on SSM.SKUId=SM.AutoId and SSM.StoreId=ISNULL(@StoreId,0) --and SSM.ScreenId=@ScreenId
	where SM.Status=1 and SM.StoreId=@StoreId and SM.productId=0
	and (@ScreenId is null or @ScreenId=0 or ISNULL(SSM.ScreenId,0)=@ScreenId)
	and (@ProductName is null or @ProductName='' or  SKUPackingName like '%'+ @ProductName +'%')
	and (@Department is null or @Department=0 or  SM.AutoId in (select SKUAutoId from SKUItemMaster SIM where SIM.ProductId in (select AutoId from ProductMaster where DeptId=@Department)))

	union 

	select SM.AutoId, SM.SKUPackingName ProductName, SM.SKUImagePath ImagePath,(case when SSM.ScreenId=@ScreenId then 0  else 1 end) as Checked	, 'SKU' Type
	from SKUMaster SM
	left join SKUScreenMaster SSM on SSM.SKUId=SM.AutoId and SSM.StoreId=ISNULL(@StoreId,0) and SSM.ScreenId=@ScreenId
	where SM.Status=1 and SM.StoreId=@StoreId and SM.productId=0 
	--and (@ScreenId is null or @ScreenId=0 or SSM.ScreenId=@ScreenId)
	and (@ProductName is null or @ProductName='' or  SKUPackingName like '%'+ @ProductName +'%')
	and (@Department is null or @Department=0 or  SM.AutoId in (select SKUAutoId from SKUItemMaster SIM where SIM.ProductId in (select AutoId from ProductMaster where DeptId=@Department)))
	
	UNION 

	select SM.AutoId, SM.SchemeName ProductName, SMM.SKUImagePath ImagePath,(case when SSM.ScreenId=@ScreenId then 0  else 1 end) as Checked, 'Scheme' Type
	from SchemeMaster SM
	inner join SKUMaster SMM on SM.SKUAutoId=SMM.AutoId
	INNER join SchemeScreenMaster SSM on SSM.SchemeId=SM.AutoId and SSM.StoreId=ISNULL(@StoreId,0)
	where SM.Status=1 and SM.StoreId=@StoreId and SMM.Status=1
	and (@ScreenId is null or @ScreenId=0 or SSM.ScreenId=@ScreenId)
	and (@ProductName is null or @ProductName='' or  SchemeName like '%'+ @ProductName +'%')
	and (@Department is null or @Department=0 or  SM.SKUAutoId in (select SKUAutoId from SKUItemMaster SIM where SIM.ProductId in (select AutoId from ProductMaster where DeptId=@Department)))
	and (convert(date,getdate()) between  isnull(convert(date,SM.FromDate), convert(date,getdate())) and isnull(convert(date,SM.ToDate), convert(date,getdate())))
	and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SM.SchemeDaysString,''),',')))

	UNION 

	select SM.AutoId, SM.SchemeName ProductName, SMM.SKUImagePath ImagePath,(case when SSM.ScreenId=@ScreenId then 0  else 1 end) as Checked, 'Scheme' Type
	from SchemeMaster SM
	inner join SKUMaster SMM on SM.SKUAutoId=SMM.AutoId
	LEFT join SchemeScreenMaster SSM on SSM.SchemeId=SM.AutoId and SSM.StoreId=ISNULL(@StoreId,0)  and SSM.ScreenId=@ScreenId
	where SM.Status=1 and SM.StoreId=@StoreId and SMM.Status=1
	--and (@ScreenId is null or @ScreenId=0 or SSM.ScreenId=@ScreenId)
	and (@ProductName is null or @ProductName='' or  SchemeName like '%'+ @ProductName +'%')
	and (@Department is null or @Department=0 or  SM.SKUAutoId in (select SKUAutoId from SKUItemMaster SIM where SIM.ProductId in (select AutoId from ProductMaster where DeptId=@Department)))
	and (convert(date,getdate()) between  isnull(convert(date,SM.FromDate), convert(date,getdate())) and isnull(convert(date,SM.ToDate), convert(date,getdate())))
	and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SM.SchemeDaysString,''),',')))
	) as Tab
	where 
	 ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=1 or ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=0 and ProductName not like 'Lottery%'))

	SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, '#Sort By: Product Name ASC' as SortByString FROM #temp107 
	--where 
	-- ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=1 or ((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=0 and ProductName not like 'Lottery%'))

	Select  * from #temp107 t      
	WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
	
	order by  ProductName asc      
 end
  else if @Opcode=109
 begin
	insert into CreditCardTransactionLog(CustomerId,DraftAutoId,InvoiceNo,CardType,CardNo,TransactionId,TotalAmt,StoreId,TrnsStatus,CreatedBy,CreatedDate) 
	select @CustomerId,@DraftAutoId,@InvoiceNo,@CardType,@CardNo,@TransactionId,@TotalAmt,@StoreId,@TrnsStatus,@Who,getdate()
 end
 else if @Opcode=511
 Begin
    IF((select case when @SKUAutoId!=0 or @SKUAutoId!='' then (SELECT COUNT(*) from SKUMaster where AutoId=@SKUAutoId and StoreId=@StoreId) end as AutoId)<=0)  
	  BEGIN
		SET @isException=1  
		SET @exceptionMessage= 'No Product Found'	
	  END
	  else
	  begin
		--Update CartMaster set LiveCartforDraft=0 where StoreId=@StoreId and TerminalId=@TerminalId and LiveCartforDraft=1
		if(@OrderNo!='')
        begin    
			set @OrderId=(select AutoId from CartMaster where OrderNo=@OrderNo)
			update CartMaster set CustomerId=@CustomerId, UpdatedDate=GETDATE(), TerminalId=@TerminalId, ShiftAutoId=@ShiftId where AutoId=@OrderId 
        end
        else
        begin
			SET @OrderNo = (SELECT DBO.SequenceCodeGenerator('OrderNo'))             
			
			insert into CartMaster(OrderNo, CustomerId, CreatedDate, UpdatedDate,UpdatedBy, Status, CreatedBy, StoreId, TerminalId, ShiftAutoId,DraftName,DraftDateTime,ShowAsDraft,DiscType,Discount,Isdeleted)
			values(@OrderNo, @CustomerId, GETDATE(), GETDATE(),@Who, 1, @Who, @StoreId, @TerminalId , @ShiftId,ISNULL(@DraftName,''),'',0,isnull(@DiscType,''),isnull(@Discount,0),0)

			Set @OrderId=scope_Identity()
			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='OrderNo'
        end


		   set @SchemeAutoId=(Select top 1 AutoId from SchemeMaster 
           where Status=1 and StoreId=@StoreId and SKUAutoId=@SKUAutoId and Quantity<=@Quantity 
           and (case when MaxQuantity=0 then @Quantity+1 else MaxQuantity end > @Quantity)
           and (convert(date,getdate()) between  convert(date,isnull(FromDate, getdate())) and convert(date,isnull(ToDate, getdate())))
           and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SchemeDaysString,''),',')))
           and Status=1)

            if(isnull(@SchemeAutoId,0)!=0)
            Begin
                set @ProductName=(Select (STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'</br>'))            
                 from [dbo].[SKUItemMaster] SIM
                 inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
                 inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
                 inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
                 inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
                 where SKUAutoId=@SKUAutoId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 
                 AND (isnull(@SchemeAutoId,0)!=0 or (isnull(@SchemeAutoId,0)=0 and SM.ProductId=0))
                 )

                set @SKUNames=(Select SchemeName from SchemeMaster where  AutoId=isnull(@SchemeAutoId,0)) + (case when isnull(@ProductName,'')='' then '' else ('</br>' + isnull(@ProductName,'')) end)
            End
            else if(isnull(@SKUAutoId,0)=0)
            begin
               set @SKUNames=@SKUNames
            end
            else
            Begin
               set @ProductName=(Select (STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'</br>'))            
               from [dbo].[SKUItemMaster] SIM
               inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
               inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
               inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
               inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
               where SKUAutoId=@SKUAutoId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 and SM.ProductId=0)
               
               set @SKUNames=isnull((select SM.SKUPackingName from SKUMaster SM where SM.AutoId=@SKUAutoId),'')+isnull(case when isnull(@ProductName,'')='' then '' else ('</br>' + isnull(@ProductName,'')) end,'')
            END

			
	    if(isnull(@CartItemId,0)!=0)
		begin
			delete from CartItemMaster where CartAutoId=@OrderId and CartItemId=@CartItemId
		end

		if(isnull(@CartItemId,0)=0)
		begin 
			insert into CartSKUMaster([OrderAutoId], [SKUId], [SchemeId], [Quantity], [SKUName],MinAge)
			values(@OrderId, @SKUAutoId, isnull(@SchemeAutoId,0), @Quantity, @SKUNames,@MinAge)
			Set @CartItemId=scope_Identity()
		end
		else
		begin
			if(@Quantity>0)
			begin
				update CartSKUMaster set SchemeId=isnull(@SchemeAutoId,0), Quantity=@Quantity, SKUName=@SKUNames where AutoId=@CartItemId
			end
			else
			begin
				delete from CartSKUMaster where AutoId=@CartItemId
			end
		end

		if(@Quantity>0)
		begin
		   if(@SKUAutoId=0)
		   begin
		   	   insert into CartItemMaster(CartItemId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice, CartAutoId,ProductTotalSoldQty)
		   	   Select @CartItemId, 0,0 , @Quantity,@SKUAmt,0, isnull(@SKUAmt,0)*isnull(@Quantity,1),0,0,@OrderId,@Quantity
		   end
		   else if(@SchemeAutoId!=0)
		   begin
		       insert into CartItemMaster(CartItemId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice, CartAutoId,ProductTotalSoldQty)
     	       Select @CartItemId, dt.ProductAutoId, dt.PackingAutoId,dt.Quantity, dt.UnitPrice, dt.Tax, dt.Total,
		       isnull(tm.TaxPer,0),isnull(pm.CostPrice,0), @OrderId,@Quantity*pm.NoOfPieces*dt.Quantity
     	       from SchemeItemMaster as dt 
     	       inner join ProductUnitDetail as pm on (pm.AutoId=dt.PackingAutoId) and StoreId=@StoreId
     	       left join TaxMaster as tm on (tm.AutoId=pm.TaxAutoId)
     	       where dt.SchemeAutoId=@SchemeAutoId
		   end
		   else
		   begin
		       insert into CartItemMaster(CartItemId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer,CostPrice, CartAutoId,ProductTotalSoldQty)
     	       Select @CartItemId, dt.ProductId, dt.ProductUnitAutoId, dt.Quantity, dt.PriceAfterDis, dt.Tax, dt.SKUItemTotal, 
		       isnull(tm.TaxPer,0),ISNULL(pm.CostPrice,0), @OrderId,@Quantity*pm.NoOfPieces*dt.Quantity
     	       from SKUItemMaster as dt 
     	       inner join ProductUnitDetail as pm on (pm.AutoId=dt.ProductUnitAutoId) and StoreId=@StoreId
     	       left join TaxMaster as tm on (tm.AutoId=pm.TaxAutoId)
     	       where dt.SKUAutoId=@SKUAutoId
		   end
		end

		select @Discount=Discount, @Type=DiscType from CartMaster where OrderNo=@OrderNo
		 
		if(@Type='Per')
		Begin
		set @Disc=isnull((select cast(sum(Total) as decimal(18,2))from CartSKUMaster where OrderAutoId=@OrderId and  SKUName not like '%Lottery%'),0) / 100 * @Discount
		End
		Else
		Begin
		set @Disc=isnull(@Discount,0)
		End 
		set @DiscType=(case when (ISNULL(@Type,'')='Per' and @Disc>0) then 'Percentage' when (ISNULL(@Type,'')='Fixed' and @Disc>0) then 'Fixed' else '' end)

			select isnull((select CM.AutoId, FirstName +isnull(' '+LastName,'') as [Name],case when trim(FirstName)='Walk In' then 0 else isnull(CR.AssignedRoyaltyPoints,0) end as AssignedRoyaltyPoints from CustomerMaster CM Left Join CustomerRoyaltyPoints CR on CR.CustomerId=CM.AutoId
			where CM.AutoId=(select CustomerId from CartMaster where AutoId=@OrderId) for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
			isnull((
		Select csm.AutoId,csm.SKUId ,csm.SKUName, csm.SchemeId, csm.Quantity,isnull(MinAge,0)MinAge, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice,
		(case when (sm.ProductId!=0 and isnull(csm.SchemeId,0)=0)then 1 else 0 end)IsProduct,
		'/Images/ProductImages/'+(case when isnull(SM.SKUImagePath,'')!='' then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
		then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
		from CartSKUMaster csm
		left join SKUMaster sm on sm.AutoId=csm.SKUId
		where OrderAutoId=@OrderId order by csm.AutoId Desc 
		for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
		isnull((
		select @OrderId OrderId, @OrderNo OrderNo, isnull(@Disc,0) Discount,@DiscType DiscType,@Discount DiscountPer,-- cm.DiscType from CartMaster cm where cm.AutoId=@OrderId for json path, INCLUDE_NULL_VALUES),'[]') as OrderDetail,
		isnull((select Count(*) from CartSKUMaster where OrderAutoId=@OrderId),0)ItemCount,
		isnull((select sum(Quantity) from CartSKUMaster where OrderAutoId=@OrderId),0)TotalQuantity,
		isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
		isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
		isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
		isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
		isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]
		for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
		for json path, INCLUDE_NULL_VALUES
	end
 End

 else if @Opcode=531
 Begin
	  IF not EXISTS(SELECT * from CartMaster where OrderNo=@OrderNo and TerminalId=@TerminalId and StoreId=@StoreId )  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'Order Details Not Found.'
	  END
	  else
	  begin 
	        set @OrderId=(select AutoId from CartMaster where OrderNo=@OrderNo)
	        if(ISNULL(@CustomerId,0)=0)
			begin
			    set @CustomerId=(select top 1 isnull(CustomerId,(select AutoId from CustomerMaster where StoreId=@StoreId and trim(FirstName)='Walk In')) from CartMaster where AutoId=@OrderId)
			end
			declare @ONo int=(select top 1 AutoId from CartMaster where StoreId=@StoreId and TerminalId=@TerminalId order by AutoId desc)
			Update CartMaster set IsDeleted=1 where StoreId=@StoreId and TerminalId=@TerminalId and AutoId=@ONo

			Update CartMaster set LiveCartforDraft=0 where StoreId=@StoreId and TerminalId=@TerminalId and LiveCartforDraft=1	

	        Update CartMaster set CustomerId=@CustomerId,IsDeleted=0,TerminalId=@TerminalId,ShiftAutoId=@ShiftId,LiveCartforDraft=1 where OrderNo=@OrderNo
	        
			if exists(select FirstName from CustomerMaster where AutoId=@CustomerId and FirstName like '%Walk In%')
			  begin
			     delete from CartItemMaster where CartItemId in (select AutoId  from CartSKUMaster where trim(isnull(SKUName,'')) like 'Gift Card%' and OrderAutoId=@OrderId)
			     delete from CartSKUMaster where trim(isnull(SKUName,'')) like 'Gift Card%' and OrderAutoId=@OrderId
			  end

	        
			select @Discount=Discount, @Type=DiscType from CartMaster where OrderNo=@OrderNo and StoreId=@StoreId

		    if(@Type='Per')
		    Begin
		    set @Disc=isnull((select cast(sum(Total) as decimal(18,2))from CartSKUMaster where OrderAutoId=@OrderId and  SKUName not like '%Lottery%'),0) / 100 * @Discount
		    End
		    Else
		    Begin
		    set @Disc=isnull(@Discount,0)
		    End 
			set @DiscType=(case when (ISNULL(@Type,'')='Per' and @Disc>0) then 'Percentage' when (ISNULL(@Type,'')='Fixed' and @Disc>0) then 'Fixed' else '' end)

			select isnull((select CM.AutoId, FirstName +isnull(' '+LastName,'') as [Name],case when trim(FirstName)='Walk In' then 0 else isnull(CR.AssignedRoyaltyPoints,0) end as AssignedRoyaltyPoints from CustomerMaster CM Left Join CustomerRoyaltyPoints CR on CR.CustomerId=CM.AutoId
			where CM.AutoId=(select CustomerId from CartMaster where AutoId=@OrderId) for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
			isnull((
			Select csm.AutoId,csm.SKUId ,csm.SKUName, csm.SchemeId, csm.Quantity,isnull(MinAge,0)MinAge, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice,
			(case when (sm.ProductId!=0 and isnull(csm.SchemeId,0)=0)then 1 else 0 end)IsProduct,
			'/Images/ProductImages/'+(case when (SM.SKUImagePath!='' or SM.SKUImagePath!=null) then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
			then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
			from CartSKUMaster csm
			left join SKUMaster sm on sm.AutoId=csm.SKUId
			where OrderAutoId=@OrderId order by csm.AutoId Desc 
			for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
			isnull((
			select @OrderId OrderId, @OrderNo OrderNo, isnull(@Disc,0) Discount,@DiscType DiscType,@Discount DiscountPer,-- cm.DiscType from CartMaster cm where cm.AutoId=@OrderId for json path, INCLUDE_NULL_VALUES),'[]') as OrderDetail,
			isnull((select Count(*) from CartSKUMaster where OrderAutoId=@OrderId),0)ItemCount,
			isnull((select sum(Quantity) from CartSKUMaster where OrderAutoId=@OrderId),0)TotalQuantity,
			isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
			isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
			isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
			isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
			isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]
			for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
			for json path, INCLUDE_NULL_VALUES

	  end
 End
 else if @Opcode=541
 Begin
	  IF not EXISTS(SELECT * from CartMaster where OrderNo=@OrderNo)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'Order Details Not Found.'
	  END
	  else
	  begin 
	          Update CartMaster set Discount=@Discount,DiscType=@Type where OrderNo=@OrderNo
			  set @OrderId=(select AutoId from CartMaster where OrderNo=@OrderNo)

			  
			  select @Discount=Discount, @Type=DiscType from CartMaster where OrderNo=@OrderNo and StoreId=@StoreId

		      if(@Type='Per')
		      Begin
		      set @Disc=isnull((select cast(sum(Total) as decimal(18,2))from CartSKUMaster where OrderAutoId=@OrderId and  SKUName not like '%Lottery%'),0) / 100 * @Discount
		      End
		      Else
		      Begin
		      set @Disc=isnull(@Discount,0)
		      End 

			  set @DiscType=(case when (ISNULL(@Type,'')='Per' and @Disc>0) then 'Percentage' when (ISNULL(@Type,'')='Fixed' and @Disc>0) then 'Fixed' else '' end)
			 	select isnull((select CM.AutoId, FirstName +isnull(' '+LastName,'') as [Name],case when trim(FirstName)='Walk In' then 0 else isnull(CR.AssignedRoyaltyPoints,0) end as AssignedRoyaltyPoints from CustomerMaster CM Left Join CustomerRoyaltyPoints CR on CR.CustomerId=CM.AutoId
			where CM.AutoId=(select CustomerId from CartMaster where AutoId=@OrderId) for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
			isnull((
			  Select csm.AutoId,csm.SKUId ,csm.SKUName, csm.SchemeId, csm.Quantity, isnull(MinAge,0)MinAge, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice,
			  (case when (sm.ProductId!=0 and isnull(csm.SchemeId,0)=0)then 1 else 0 end)IsProduct,
			  '/Images/ProductImages/'+(case when (SM.SKUImagePath!='' or SM.SKUImagePath!=null) then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
			  then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
			  from CartSKUMaster csm
			  left join SKUMaster sm on sm.AutoId=csm.SKUId
			  where OrderAutoId=@OrderId order by csm.AutoId Desc 
			  for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
			  isnull((
			  select @OrderId OrderId, @OrderNo OrderNo, isnull(@Disc,0) Discount,@DiscType DiscType,@Discount DiscountPer,-- cm.DiscType from CartMaster cm where cm.AutoId=@OrderId for json path, INCLUDE_NULL_VALUES),'[]') as OrderDetail,
			  isnull((select Count(*) from CartSKUMaster where OrderAutoId=@OrderId),0)ItemCount,
			  isnull((select sum(Quantity) from CartSKUMaster where OrderAutoId=@OrderId),0)TotalQuantity,
			  isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
			  isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
			  isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
			  isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
			  isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]
			  for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
			  for json path, INCLUDE_NULL_VALUES
	  end
 End
 else if @Opcode=561
	Begin
		Update CartMaster set LiveCartforDraft=0 where StoreId=@StoreId and TerminalId=@TerminalId and LiveCartforDraft=1
	    Update CartMaster set IsDeleted=1 where OrderNo=@OrderNo
	end
 
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
END
