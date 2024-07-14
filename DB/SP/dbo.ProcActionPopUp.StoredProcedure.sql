create or alter proc [dbo].[ProcActionPopUp]
@Opcode int=Null,
@AccessToken varchar(50)=null,
@Hashkey varchar(50)=null,
@DeviceId varchar(100)=null,
@LatLong varchar(100)=null,
@AppVersion varchar(20)=null,
@RequestSource varchar(20)=null,
@LoginId varchar(100)=null,
@URL varchar(200)=null,
@Department int=null,
@SecurityPin varchar(50)=null,
@CouponCode varchar(50)=null,
@TotalAmt decimal(18,2)=null,
@ScreenId int=null,
@ShiftId int=null,
@DiscType nvarchar(20)=null,
@GiftCardNo varchar(50)=null,
@GiftCardAmt decimal(18,2)=null,
@TotalQty int=null,
@Disc decimal(18,2)=null,
@DraftName varchar(100)=null,
@CustomerIdV varchar(30)=null,
@State varchar(50)=null,
@City varchar(50)=null,
@EmailId varchar(80)=null,
@MobileNo varchar(10)=null,
@OrderNo varchar(30)=null,
@CustomerId int=null,
@Barcode varchar(50)=null,
@Status int=null,
@DOB datetime=null,
@Address varchar(100)=null,
@FirstName varchar(50)=null,
@LastName varchar(50)=null,
@ZipCode varchar(10)=null,
@OrderId int=null,
@Discount decimal(18,2)=null,
@SKUAmt decimal(18,2)=null,
@SKUName varchar(150)=null,
@GiftCardCode varchar(50)=null,
@TerminalId int=null,
@SearchString varchar(100)=null,
@BalanceStatus varchar(25)=null,
@DT_CurrencyListChild DT_CurrencyTable readonly,
@CurrentBalanceStatus varchar(30)=null,
@CurrentBalance decimal(18,2)=null,
@ClosingBalance decimal(18,2)=null,
@StoreId int=null,
@Remark varchar(300)=null,
@ScreenName varchar(80)=null,
@CartItemId int=null,
@SKUAutoId int=null,
@SKUId int=null,
@Quantity int=null,
@ProductName varchar(100)=null,
@CategoryAutoId int=null,
@BrandAutoId int=null,
@AutoId int=null,
@Action int=null,
@ProductId int=null,
@DateTime datetime=null,
@Type varchar(50)=null,
@ScreenAutoId int=null,
@Expense int=null,
@Vendor int=null,
@PayoutMode int=null,
@PayoutDate datetime=null,
@PayoutTo varchar(50)=null,
@PayoutTime varchar(50)=null,
@PayoutType int=null,
@PaymentMode varchar(50)=null,
@PaidAmt decimal(18,2)=null,
@TransactionAutoId int=null,
@CashAmount decimal(18,2)=null,
@ReturnAmt decimal(18,2)=null,
@PaymentStatus varchar(50)=null,
@RecordCount INT =null,    
@isException bit out,  
@exceptionMessage varchar(max) out,
@responseCode varchar(10) out
as
begin
	BEGIN TRY  
	SET @isException=0  
	SET @exceptionMessage='Success'
	set @responseCode='200'
	if(@Opcode=13)    --- GetActionButtonList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetActionButtonList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'User is Not Allowed'	
		SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT * from ScreenMaster where StoreId=@StoreId)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'No Screen Found'	
		SET @responseCode='301'
	  END	  
	  else
	  begin
			select isnull((select * from ActionButton where Type='Action'
			ORDER BY SeqNo asc
			for json path, INCLUDE_NULL_VALUES),'[]')as ActionButtonList
			for json path, INCLUDE_NULL_VALUES
	  end
	end

	if(@Opcode=41)    --- GetScreenList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetScreenList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'User is Not Allowed'	
		SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT * from ScreenMaster where StoreId=@StoreId)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'No Screen Found'	
		SET @responseCode='301'
	  END	  
	  else
	  begin
	  if((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=1)
		Begin
			select isnull((
			select SM.AutoId,SM.Name,SM.Status,case when SM.Name like '%Home Screen%' then 1 when SM.Name like '%Lottery%' then 2 else 3 end as SN from ScreenMaster SM
			where (@SearchString is null or @SearchString=''  or Name like'%'+ @SearchString +'%') 
			and (@Status is null or @Status=2 or Status=@Status)
			and StoreId=@StoreId
			ORDER BY SN ASC
			for json path, INCLUDE_NULL_VALUES),'[]')as ScreenList
			for json path, INCLUDE_NULL_VALUES
		END
	 Else
		Begin
			select isnull((select SM.AutoId,SM.Name,SM.Status,case when SM.Name like '%Home Screen%' then 1 when SM.Name like '%Lottery%' then 2 else 3 end as SN from ScreenMaster SM
			where (@SearchString is null or @SearchString=''  or Name like'%'+ @SearchString +'%') 
			and (@Status is null or @Status=2 or Status=@Status)
			and StoreId=@StoreId  and Name!= 'Lottery'
			ORDER BY SN ASC
			for json path, INCLUDE_NULL_VALUES),'[]')as ScreenList
			for json path, INCLUDE_NULL_VALUES
		END
	  end
	end

	if(@Opcode=31)    --- InsertUpdateDeleteScreen
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('InsertUpdateDeleteScreen', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'User is Not Allowed'	
		SET @responseCode='301'
	  END
	  if(@Action=1)
	  Begin
			if exists(select Name from ScreenMaster where Name=@ScreenName and StoreId=@StoreId)
			begin		   
			SET @exceptionMessage='Screen Name Already Exists.'
			SET @isException=1
			end
			else
			begin
			Insert into ScreenMaster(Name,Status,StoreId) values(@ScreenName,@Status,@StoreId)
			SET @exceptionMessage='Screen saved successfully.'
			SET @isException=0
			end
		end
	  if(@Action=2)
	  Begin
			if exists(select Name from ScreenMaster where Name=@ScreenName and AutoId!=@ScreenAutoId and StoreId=@StoreId)
			begin		   
			SET @exceptionMessage='Screen Name Already Exists.'
			SET @isException=1
			end
			else
			begin
			update ScreenMaster set Name=@ScreenName,Status=@Status,StoreId=@StoreId where AutoId=@ScreenAutoId
			SET @exceptionMessage='Screen updated successfully.'
			SET @isException=0
			end
		end
		if(@Action=3)
		Begin
			if not exists(select Name from ScreenMaster where AutoId=@ScreenAutoId and StoreId=@StoreId and Name!='Home Screen' and Name!='Lottery')
			begin		   
			SET @exceptionMessage='Screen is not exists.'
			SET @isException=1
			end
			else
			begin
			delete from ScreenMaster where AutoId=@ScreenAutoId and StoreId=@StoreId and Name!='Home Screen' and Name!='Lottery'
			SET @exceptionMessage='Screen deleted successfully.'
			SET @isException=0
			end
		end
	end

	if(@Opcode=11)    --- NoSale
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('NoSale', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	  if(@Action=1)
		Begin			
			Insert into NoSale( TerminalId, OpenDate, OpenBy,StoreId,Remark) values(@TerminalId,GETDATE(),@AutoId,@StoreId,@Remark)
			SET @exceptionMessage='No Sale remark saved successfully.'
			SET @isException=0		
			SET @responseCode='200'
		end	  
	end

	if(@Opcode=12)    --- GetAddToScreenProductList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetAddToScreenProductList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	  else
		Begin			
				select isnull(( select * from (
				select PM.AutoId, PM.ProductSizeName ProductName,case when isnull(ImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(ImagePath,'product.png') else '' end as ImagePath,(case when PSM.ScreenId=@ScreenId then 0  else 1 end )as Checked	, 'Product' Type
				from ProductMaster PM
				inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=ISNULL(@StoreId,0)
				left join ProductScreenMaster PSM on PSM.ProductId=PM.AutoId and PSM.StoreId=ISNULL(@StoreId,0)
				Inner Join DepartmentMaster DM on PM.DeptId=DM.AutoId
				where SPL.Status=1
				and (@SearchString is null or @SearchString='' or  ProductSizeName like '%'+ @SearchString +'%')
				and (@Department is null or @Department=0 or  DM.AutoId=@Department)
				and PSM.ScreenId=@ScreenId

				union

				select PM.AutoId, PM.ProductSizeName ProductName,case when isnull(ImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(ImagePath,'product.png') else '' end as ImagePath
				,(case when PSM.ScreenId=@ScreenId then 0  else 1 end) as Checked	, 'Product' Type
				from ProductMaster PM
				inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPl.StoreId=ISNULL(@StoreId,0)
				left join ProductScreenMaster PSM on PSM.ProductId=PM.AutoId and PSM.StoreId=ISNULL(@StoreId,0) and PSM.ScreenId=@ScreenId
				Inner Join DepartmentMaster DM on PM.DeptId=DM.AutoId
				where SPL.Status=1
				and (@SearchString is null or @SearchString='' or  ProductSizeName like '%'+ @SearchString +'%')
				and (@Department is null or @Department=0 or  DM.AutoId=@Department)

				union 

				select SM.AutoId, SM.SKUPackingName ProductName,case when isnull(SM.SKUImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(SM.SKUImagePath,'product.png') else '' end as ImagePath,(case when SSM.ScreenId=@ScreenId then 0  else 1 end) as Checked	, 'SKU' Type
				from SKUMaster SM
				INNER join SKUScreenMaster SSM on SSM.SKUId=SM.AutoId and SSM.StoreId=ISNULL(@StoreId,0) --and SSM.ScreenId=@ScreenId
				where SM.Status=1 and SM.StoreId=@StoreId and SM.productId=0
				and (@ScreenId is null or @ScreenId=0 or ISNULL(SSM.ScreenId,0)=@ScreenId)
				and (@SearchString is null or @SearchString='' or  SKUPackingName like '%'+ @SearchString +'%')
				and (@Department is null or @Department=0 or  SM.AutoId in (select SKUAutoId from SKUItemMaster SIM where SIM.ProductId in (select AutoId from ProductMaster where DeptId=@Department)))

				union 

				select SM.AutoId, SM.SKUPackingName ProductName,case when isnull(SM.SKUImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(SM.SKUImagePath,'product.png') else '' end as ImagePath,(case when SSM.ScreenId=@ScreenId then 0  else 1 end) as Checked	, 'SKU' Type
				from SKUMaster SM
				left join SKUScreenMaster SSM on SSM.SKUId=SM.AutoId and SSM.StoreId=ISNULL(@StoreId,0) and SSM.ScreenId=@ScreenId
				where SM.Status=1 and SM.StoreId=@StoreId and SM.productId=0 
				--and (@ScreenId is null or @ScreenId=0 or SSM.ScreenId=@ScreenId)
				and (@SearchString is null or @SearchString='' or  SKUPackingName like '%'+ @SearchString +'%')
				and (@Department is null or @Department=0 or  SM.AutoId in (select SKUAutoId from SKUItemMaster SIM where SIM.ProductId in (select AutoId from ProductMaster where DeptId=@Department)))
	
				UNION 

				select SM.AutoId, SM.SchemeName ProductName,case when isnull(SMM.SKUImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(SMM.SKUImagePath,'product.png') else '' end as ImagePath,(case when SSM.ScreenId=@ScreenId then 0  else 1 end) as Checked, 'Scheme' Type
				from SchemeMaster SM
				inner join SKUMaster SMM on SM.SKUAutoId=SMM.AutoId
				INNER join SchemeScreenMaster SSM on SSM.SchemeId=SM.AutoId and SSM.StoreId=ISNULL(@StoreId,0)
				where SM.Status=1 and SM.StoreId=@StoreId and SMM.Status=1
				and (@ScreenId is null or @ScreenId=0 or SSM.ScreenId=@ScreenId)
				and (@SearchString is null or @SearchString='' or  SchemeName like '%'+ @SearchString +'%')
				and (@Department is null or @Department=0 or  SM.SKUAutoId in (select SKUAutoId from SKUItemMaster SIM where SIM.ProductId in (select AutoId from ProductMaster where DeptId=@Department)))
				and (convert(date,getdate()) between  isnull(convert(date,SM.FromDate), convert(date,getdate())) and isnull(convert(date,SM.ToDate), convert(date,getdate())))
				and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SM.SchemeDaysString,''),',')))

				UNION 

				select SM.AutoId, SM.SchemeName ProductName,case when isnull(SMM.SKUImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(SMM.SKUImagePath,'product.png') else '' end as ImagePath 
				,(case when SSM.ScreenId=@ScreenId then 0  else 1 end) as Checked, 'Scheme' Type
				from SchemeMaster SM
				inner join SKUMaster SMM on SM.SKUAutoId=SMM.AutoId
				LEFT join SchemeScreenMaster SSM on SSM.SchemeId=SM.AutoId and SSM.StoreId=ISNULL(@StoreId,0)  and SSM.ScreenId=@ScreenId
				where SM.Status=1 and SM.StoreId=@StoreId and SMM.Status=1
				--and (@ScreenId is null or @ScreenId=0 or SSM.ScreenId=@ScreenId)
				and (@SearchString is null or @SearchString='' or  SchemeName like '%'+ @SearchString +'%')
				and (@Department is null or @Department=0 or  SM.SKUAutoId in (select SKUAutoId from SKUItemMaster SIM where SIM.ProductId in (select AutoId from ProductMaster where DeptId=@Department)))
				and (convert(date,getdate()) between  isnull(convert(date,SM.FromDate), convert(date,getdate())) and isnull(convert(date,SM.ToDate), convert(date,getdate())))
				--and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SM.SchemeDaysString,''),',')))
				) as Tab	for json path, INCLUDE_NULL_VALUES),'[]') as [AddToScreenProductList]	for json path, INCLUDE_NULL_VALUES
		end	  
	end

	if(@Opcode=14)    --- GetEndShiftDetails
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetEndShiftDetails', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else if(exists(select top 1 Mode from BalanceMaster where AutoId=@ShiftId )and (select top 1 Mode from BalanceMaster where AutoId=@ShiftId)='Break')		
		Begin
		Declare @CurrentCashAmt decimal(18,2)=null,@OpenBalance decimal(18,2)=null
			
					select OpeningBalance,ClosingBalance,Mode
					into #TempOpeningBalanceDetail
					from BalanceMaster BM
					inner join UserDetailMaster UDM on UDM.UserAutoId=BM.UserId
					where StoreId=@StoreId
					and  BM.TerminalAutoId=@TerminalId 
					and  BM.AutoId=@ShiftId

					select sum(isnull(Amount,0)) TotalCashTrns
					into #TempTotalCashTrns
					from InvoiceTransactionDetail ITD
					inner join InvoiceMaster IM on IM.AutoId=ITD.InvoiceAutoId
					where PaymentMode='Cash' and StoreId=@StoreId and isnull(ITD.Amount,0)>0
					and IM.TerminalId=@TerminalId 
					and  IM.ShiftAutoId=@ShiftId

					select * into #TempPayoutList from(
					select  'Lottery Payout' Payout,'Cash' PayoutMode,isnull(sum(isnull(ISM.Total,0)),0)*-1 TotalPayout
					from InvoiceSKUMaster ISM
					inner join InvoiceMaster IM on IM.AutoId=ISM.InvoiceAutoId
					where ISM.SKUName like '%Lottery Payout%'
					and Im.StoreId=@StoreId 
					and  IM.TerminalId=@TerminalId
					and IM.ShiftAutoId=@ShiftId
					group by ISM.SKUName

					union
            
					select PTM.PayoutType+' Payout' Payout,PM.PayoutMode, isnull(sum(isnull(PM.Amount,0)),0)TotalPayout
					from PayoutMaster PM
					inner join PayoutTypeMaster PTM on PTM.AutoId=PM.PayoutType
					where PM.PayoutMode='Cash'
					and PM.CompanyId=@StoreId 
					and isnull(PM.Terminal,0)=@TerminalId 
					and PM.ShiftId=@ShiftId
					group by PTM.PayoutType,PM.PayoutMode
					)t

					select isnull(Sum(isnull(Amount,0)),0)as safeCashAmt
					into #TempSafeCash
					from SafeCash SC
					where isnull(SC.Terminal,0)=@TerminalId 
					and SC.ShiftId=@ShiftId
					and Mode=1 and Store=@StoreId
					--------------------------------------------------------------            

					set @CurrentCashAmt=(select isnull((select ISNULL(Sum(isnull(TotalCashTrns,0)),0)as TotalPayOut from #TempTotalCashTrns)
					+(select ISNULL(Sum(isnull(OpeningBalance,0)),0)OpeningBalance from #TempOpeningBalanceDetail)
					-(select ISNULL(Sum(isnull(TotalPayout,0)),0)as TotalPayOut from #TempPayoutList)
					-(select ISNULL(Sum(isnull(safeCashAmt,0)),0)safeCashAmt from #TempSafeCash),0) CurrentCashAmt)

					set @OpenBalance=(select OpeningBalance from BalanceMaster where AutoId=(select top 1 AutoId from BalanceMaster where UserId=@AutoId and StoreId=@StoreId and 
					TerminalAutoId=@TerminalId and ClosingBalance is null order by AutoId desc))
					
					select  @CurrentCashAmt as CurrentCashAmt, @OpenBalance as OpenBalance,
					isnull(( select AutoId,Amount from CurrencyMaster where Status=1 order by Amount asc
					for json path, INCLUDE_NULL_VALUES),'[]') as [CurrencyDetails]				
					for json path, INCLUDE_NULL_VALUES
		end	  
		else
			--if((select top 1 Mode from BalanceMaster where UserId=@Who order by AutoId desc)='Logout')
			begin
				Set @isException=1                                                                                                   
				Set @exceptionMessage='Back from break!'
				SET @responseCode='200'
		end
	end

	if(@Opcode=15)    --- ProceedClosingDetails
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('ProceedClosingDetails', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
		if(exists(select top 1 Mode from BalanceMaster where AutoId=@ShiftId)and (select top 1 Mode from BalanceMaster where AutoId=@ShiftId)='Break')
		begin
			select ROW_NUMBER() over(order by CAutoId asc)RowNo, CAutoId,QTY,@AutoId as UserId,@StoreId as StoreId,[Type]='Closing',[BMAutoId]=(select top 1 AutoId from BalanceMaster where UserId=@AutoId and StoreId=@StoreId order by AutoId desc)  into #TempCurrency2 from @DT_CurrencyListChild 
			insert into UserCurrencyRecord (CurrencyAutoId,QTY,UserId,StoreId,BMAutoId,Type) select CAutoId,QTY,UserId,StoreId,BMAutoId,Type from #TempCurrency2
		
			update BalanceMaster set ClosingBalance=@ClosingBalance, UpdatedDate=GETDATE(),UpdatedBy=@AutoId,Mode='Logout',CurrentBalanceStatus=@CurrentBalanceStatus,CurrentBalanceDiff=@CurrentBalance
			where AutoId=(select top 1 AutoId from BalanceMaster where UserId=@AutoId and StoreId=@StoreId order by AutoId desc)

			if(exists (select * from TerminalMaster where CurrentUser=@AutoId and  CompanyId=@StoreId and AutoId=@TerminalId and OccupyStatus=1))
			begin
				Update TerminalMaster set OccupyStatus=0, CurrentUser=0,LoginTime='',LogoutTime=GETDATE() where CurrentUser=@AutoId and AutoId=@TerminalId and OccupyStatus=1 and CompanyId=@StoreId
			end
			end
			else
			--if((select top 1 Mode from BalanceMaster where UserId=@Who order by AutoId desc)='Logout')
			begin
				Set @isException=1                                                                                                   
				Set @exceptionMessage='Back from break!'
				SET @responseCode='200'
		end
	end

	if(@Opcode=16)    --- AddProductToScreens
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('AddProductToScreens', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
		if(trim(@Type)='Product')
		begin
			 if exists(Select * from ProductScreenMaster  where ProductId=@ProductId and StoreId=@StoreId and ScreenId=@ScreenId)
			 begin
				delete from ProductScreenMaster where ProductId=@ProductId and ScreenId=@ScreenId and StoreId=@StoreId
				SET @isException=0
				SET @exceptionMessage= 'Product removed from Screen successfully.'	
				SET @responseCode='200'
			 end
			 else
			 begin
				insert into ProductScreenMaster (ProductId,ScreenId,StoreId) values(@ProductId,@ScreenId,@StoreId)
				SET @isException=0
				SET @exceptionMessage= 'Product added in Screen.'	
				SET @responseCode='200'
				 
			 end
		 end
		 else if(trim(@Type)='SKU')
		 begin
			 if exists(Select * from SKUScreenMaster  where SKUId=@ProductId and StoreId=@StoreId and ScreenId=@ScreenId)
			 begin
				delete from SKUScreenMaster where SKUId=@ProductId and ScreenId=@ScreenId and StoreId=@StoreId
				SET @isException=0
				SET @exceptionMessage= 'Product removed from Screen successfully.'	
				SET @responseCode='200'				 
			 end
			 else
			 begin
				insert into SKUScreenMaster (SKUId,ScreenId,StoreId) values(@ProductId,@ScreenId,@StoreId)
				SET @isException=0
				SET @exceptionMessage= 'Product added in Screen.'	
				SET @responseCode='200'
			 end
		 end
		 else if(trim(@Type)='Scheme')
		 begin
			 if exists(Select * from SchemeScreenMaster  where SchemeId=@ProductId and StoreId=@StoreId and ScreenId=@ScreenId)
			 begin
				delete from SchemeScreenMaster where SchemeId=@ProductId and ScreenId=@ScreenId and StoreId=@StoreId
				SET @isException=0
				SET @exceptionMessage= 'Product removed from Screen successfully.'	
				SET @responseCode='200'	
			 end
			 else
			 begin
				insert into SchemeScreenMaster (SchemeId,ScreenId,StoreId) values(@ProductId,@ScreenId,@StoreId)
				SET @isException=0
				SET @exceptionMessage= 'Product added in Screen.'	
				SET @responseCode='200'
			 end
		 end
	end

	if(@Opcode=17)    --- GetScreenProductList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetScreenProductList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
		if (@ScreenId=1)
	begin
	   set @ScreenId=(select AutoId from ScreenMaster where StoreId=@StoreId and trim([Name]) = trim('Home Screen'))
	end
	else if(@ScreenId=2)
	begin
	   set @ScreenId=(select AutoId from ScreenMaster where StoreId=@StoreId and trim([Name]) = trim('Lottery'))
	end
	set @ScreenName=(select Name from ScreenMaster where StoreId=@StoreId and AutoId=@ScreenId)

	select * into #TempList from(
	select 
    PM.AutoId, 
    (case when SKUCount=1 then (select SKUPackingName from SKUMaster where ProductId=PM.AutoId and StoreId=@StoreId and Status=1)else  ProductSizeName end)  ProductName, 
    ViewImage,case when isnull(ImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(ImagePath,'product.png') else '' end as ImagePath , SKUCount,ARM.Age,
    case when SKUCount=1 then (select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1 and StoreId=@StoreId and Status=1) else '' end as Barcode,
    case when SKUCount=1 then (Select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1 and StoreId=@StoreId and Status=1) else 0 end as SKUAutoId,
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

	Select SM.AutoId, SKUPackingName ProductName, 1 ViewImage,case when isnull(SKUImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(SKUImagePath,'product.png') else '' end as SKUImagePath, 1 SKUCount,'0' Age,
	SM.AutoId as Barcode,SM.AutoId as SKUAutoId,
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

	Select SM.AutoId, SM.SchemeName ProductName, 1 ViewImage,case when isnull(SKUImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(SKUImagePath,'product.png') else '' end as SKUImagePath, 1 SKUCount,'0' Age,
	SM.SKUAutoId as Barcode,SM.SKUAutoId as SKUAutoId,
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

	if(@ScreenName='Lottery')
	Begin 
	insert into #TempList (AutoId,ProductName,ViewImage,ImagePath,SKUCount,Age,Barcode,SKUAutoId,BG_ColorCode,TEXT_ColorCode,Quantity)
	values(-1,'Lottery Payout',1,@URL+'/Images/ProductImages/LottoImg.png',1,0,'',0,'#ff0000','#ffffff',1)
	insert into #TempList (AutoId,ProductName,ViewImage,ImagePath,SKUCount,Age,Barcode,SKUAutoId,BG_ColorCode,TEXT_ColorCode,Quantity)
	values(-2,'Lottery Sale',1,@URL+'/Images/ProductImages/LottoImg.png',1,0,'',0,'#F1EB90','#ffffff',1)
	End
	set @ScreenName=isnull((select Name from ScreenMaster where AutoId=@ScreenId),'')
	if((select isnull(AllowLotterySale,0) from CompanyProfile where AutoId=@StoreId)=1)
		Begin
			select  @ScreenId as ScreenId, @ScreenName as ScreenName,
			isnull(( select * from #TempList order by case when @ScreenName like '%Lottery%' then AutoId end asc,
			case when @ScreenName not like '%Lottery%' then  ProductName end asc
			for json path, INCLUDE_NULL_VALUES),'[]') as [ProductList]				
			for json path, INCLUDE_NULL_VALUES
		End
    Else
		Begin
			select  @ScreenId as ScreenId, @ScreenName as ScreenName,
			isnull(( select * from #TempList where ProductName not like 'Lottery%' order by case when @ScreenName like '%Lottery%' then AutoId end asc,
			case when @ScreenName not like '%Lottery%' then  ProductName end asc
			for json path, INCLUDE_NULL_VALUES),'[]') as [ProductList]				
			for json path, INCLUDE_NULL_VALUES        
		End
	end

	if(@Opcode=18)    --- GetMultiPackingProduct
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetMultiPackingProduct', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
	 Begin
			declare @SymbolString nvarchar(50)='';
			set @ProductName=(select ProductName from ProductMaster  where AutoId=@SKUAutoId)
			set @SymbolString=(select isnull(CurrencySymbol,'') from CurrencySymbolMaster C inner join CompanyProfile D on C.AutoId=D.CurrencyID where D.AutoId=@StoreId)

			select  @ProductName as ProductName,
			isnull((
			Select SM.AutoId as SKUAutoId,SM.SKUName,
			(select top 1 AUtoId from SKUMaster where AutoId=SM.AutoId and StoreId=@StoreId) as Barcode,SM.SKUTotal,
			isnull((select PackingName+'\n'+@SymbolString+convert(varchar(50),PUD.SellingPrice) from ProductUnitDetail PUD 
			where StoreId=@StoreId and PUD.AutoId=(select ProductUnitAutoId from SKUItemMaster SIM where SIM.ProductId=SM.ProductId and SIM.SKUAutoId=SM.AutoId)),'') PackingName,
			case when SM.ProductId!=0 then 1 else 0 end as skutype,
			case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithSignleUnit')
			else (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_SKU') end BG_ColorCode,
			case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithSignleUnit')
			else (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_SKU') end TEXT_ColorCode,
			[Age]=isnull((select ARM.Age from ProductMaster PM Inner join AgeRestrictionMaster ARM on ARM.AutoId=PM.AgeRestrictionId where PM.AutoId=@ProductId),0)
			from SKUMaster SM
			where SM.Status=1 and StoreId=@StoreId and SM.ProductId!=0 and
			(SM.ProductId=@SKUAutoId or SM.AutoId in (select SKUAutoId from SKUItemMaster where ProductId=@SKUAutoId ))
			order by SM.SKUName
			for json path, INCLUDE_NULL_VALUES),'[]') as [ProductDetails]				
			for json path, INCLUDE_NULL_VALUES
			
        end
	end

	if(@Opcode=20)    --- GetProductFromBarcode
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetProductFromBarcode', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
	begin
	 if exists(Select AutoId as SKUAutoId, @Barcode as Barcode from SKUMaster SM where SM.StoreId=@StoreId and SM.AutoId in 
	 (Select SKUId from BarcodeMaster where Barcode=@Barcode and StoreId=@StoreId) and Status=1 and 
	 (isnull((select Status1 from StoreWiseProductList where AutoId=(select top 1 StoreProductId from BarcodeMaster where Barcode=@Barcode and StoreId=@StoreId)),1))=1)
	
	 begin
	 declare @SKUCnt int=null
	 set @SKUCnt=(Select count(SKUId) from BarcodeMaster where Barcode=@Barcode and StoreId=@StoreId)
		if(@SKUCnt>1)
		BEGIN
		
			set @ProductName=(Select distinct ProductSizeName from ProductMaster pm
							inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=@StoreId
							inner join BarcodeMaster BM on BM.StoreProductId=SPL.AutoId and BM.StoreId=@StoreId
							where SPL.Status=1 and pm.Status=1 and BM.Barcode=@Barcode)
			
			set @SKUAutoId=( Select distinct PM.AutoId from ProductMaster pm
							inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=@StoreId
							inner join BarcodeMaster BM on BM.StoreProductId=SPL.AutoId and BM.StoreId=@StoreId
							where SPL.Status=1 and pm.Status=1 and BM.Barcode=@Barcode)

			select @SKUCnt as SKUCnt,@SKUAutoId as SKUAutoId,@ProductName as ProductName,
			isnull((select top 1 AutoId, FirstName +isnull(' '+LastName,'') as [Name] from CustomerMaster where AutoId=(select CustomerId from CartMaster where AutoId=@OrderId) for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
				isnull((
				Select top 1 csm.AutoId,csm.SKUId,csm.SKUName, csm.SchemeId, csm.Quantity,isnull(MinAge,0)MinAge,
				@URL+'/Images/ProductImages/'+(case when isnull(SM.SKUImagePath,'')!='' then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
				then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
				, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice,case when csm.SKUName like '%Lottery%' then 'Lottery' else 'Product' end as ProductType
				from CartSKUMaster csm
				left join SKUMaster sm on sm.AutoId=csm.SKUId
				where OrderAutoId=@OrderId order by csm.AutoId Desc 
				for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
				isnull((select top 1 Null as P from SKUMaster for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
				for json path, INCLUDE_NULL_VALUES

		END
		Else
		BEGIN
			Select  SPL.AutoId, SPL.SKUPackingName as ProductName 
			into #Table1
			from SKUMaster SPL
			inner join BarcodeMaster BM on BM.SKUId=SPL.AutoId and BM.StoreId=@StoreId
			where SPL.Status=1 and BM.Barcode=@Barcode and SPL.StoreId=@StoreId

			set @SKUId=(select AutoId from #Table1)

			 set @ProductName=(Select (STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'\n'))		    
		     from [dbo].[SKUItemMaster] SIM
			 inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
		     inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
		     inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		     inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
	         where SKUAutoId=@SKUId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 and SM.ProductId=0)

			declare @SchemeAutoId int=0;
	 if(@OrderNo!='')
        begin    
			set @OrderId=(select AutoId from CartMaster where OrderNo=@OrderNo)
			update CartMaster set CustomerId=@CustomerId, UpdatedDate=GETDATE(), TerminalId=@TerminalId, ShiftAutoId=@ShiftId where AutoId=@OrderId 
        end
        else
        begin
			SET @OrderNo = (SELECT DBO.SequenceCodeGenerator('OrderNo')) 

			 insert into CartMaster(OrderNo, CustomerId, CreatedDate, UpdatedDate,UpdatedBy, Status,CreatedBy,StoreId,TerminalId,DraftName,DraftDateTime,ShowAsDraft,DiscType,Discount,ShiftAutoId,IsDeleted)
		  values(@OrderNo,@CustomerId,GETDATE(),GETDATE(),@AutoId,1,@AutoId,@StoreId,@TerminalId,'','',0,ISNULL(@DiscType,''),isnull(@Discount,0),@ShiftId,0)

			Set @OrderId=scope_Identity()
			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='OrderNo'
        end


		   set @SchemeAutoId=(Select top 1 AutoId from SchemeMaster 
           where Status=1 and StoreId=@StoreId and SKUAutoId=@SKUId and Quantity<=@Quantity 
           and (case when MaxQuantity=0 then @Quantity+1 else MaxQuantity end > @Quantity)
           and (convert(date,getdate()) between  convert(date,isnull(FromDate, getdate())) and convert(date,isnull(ToDate, getdate())))
           and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SchemeDaysString,''),',')))
           and Status=1)

            if(isnull(@SchemeAutoId,0)!=0)
            Begin
                set @ProductName=(Select (STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'\n'))            
                 from [dbo].[SKUItemMaster] SIM
                 inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
                 inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
                 inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
                 inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
                 where SKUAutoId=@SKUId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 
                 AND (isnull(@SchemeAutoId,0)!=0 or (isnull(@SchemeAutoId,0)=0 and SM.ProductId=0))
                 )

                set @SKUName=(Select SchemeName from SchemeMaster where  AutoId=isnull(@SchemeAutoId,0)) + (case when isnull(@ProductName,'')='' then '' else ('\n' + isnull(@ProductName,'')) end)
            End
            else if(isnull(@SKUId,0)=0)
            begin
               set @SKUName=@SKUName
            end
            else
            Begin
               set @ProductName=(Select (STRING_AGG(replace(PM.ProductSizeName,' - ','-')+'/'+ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),''),'\n'))            
               from [dbo].[SKUItemMaster] SIM
               inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
               inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
               inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
               inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
               where SKUAutoId=@SKUId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 and SM.ProductId=0)
               
               set @SKUName=isnull((select SM.SKUPackingName from SKUMaster SM where SM.AutoId=@SKUId),'')+isnull(case when isnull(@ProductName,'')='' then '' else ('\n' + isnull(@ProductName,'')) end,'')
            END
		set @CartItemId=isnull((select AutoId from CartSKUMaster where OrderAutoId=@OrderId and SKUId=@SKUId),0)
		set @Quantity= isnull((select Quantity from CartSKUMaster where OrderAutoId=@OrderId and SKUId=@SKUId),0)+1	

	    if(isnull(@CartItemId,0)!=0)
		begin
			delete from CartItemMaster where CartAutoId=@OrderId and CartItemId=@CartItemId
		end

		if(isnull(@CartItemId,0)=0)
		begin 
			insert into CartSKUMaster([OrderAutoId], [SKUId], [SchemeId], [Quantity], [SKUName])
			values(@OrderId, @SKUId, isnull(@SchemeAutoId,0), @Quantity, @SKUName)
			Set @CartItemId=scope_Identity()
		end
		else
		begin
			if(@Quantity>0)
			begin
				update CartSKUMaster set SchemeId=isnull(@SchemeAutoId,0), Quantity=@Quantity, SKUName=@SKUName where AutoId=@CartItemId
			end
			else
			begin
				delete from CartSKUMaster where AutoId=@CartItemId
			end
		end

		if(@Quantity>0)
		begin
		   if(@SKUId=0)
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
     	       where dt.SKUAutoId=@SKUId
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

		select 1 as SKUCnt,0 as SKUAutoId,'' as ProductName,
		isnull((select AutoId, FirstName +isnull(' '+LastName,'') as [Name] from CustomerMaster where AutoId=(select CustomerId from CartMaster where AutoId=@OrderId) for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
				isnull((
				Select csm.AutoId,csm.SKUId ,csm.SKUName, csm.SchemeId, csm.Quantity,isnull(MinAge,0)MinAge,
				@URL+'/Images/ProductImages/'+(case when isnull(SM.SKUImagePath,'')!='' then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
				then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
				, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice,case when csm.SKUName like '%Lottery%' then 'Lottery' else 'Product' end as ProductType
				from CartSKUMaster csm
				left join SKUMaster sm on sm.AutoId=csm.SKUId
				where OrderAutoId=@OrderId order by csm.AutoId Desc 
				for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
				isnull((
				select @OrderId OrderId, @OrderNo OrderNo, isnull(@Disc,0) Discount,@DiscType DiscType,case when @DiscType='Percentage' then @Discount else 0 end as DiscountPer,-- cm.DiscType from CartMaster cm where cm.AutoId=@OrderId for json path, INCLUDE_NULL_VALUES),'[]') as OrderDetail,
				isnull((select Count(*) from CartSKUMaster where OrderAutoId=@OrderId),0)ItemCount,
				isnull((select sum(Quantity) from CartSKUMaster where OrderAutoId=@OrderId),0)TotalQuantity,
				isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
				isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
				isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
				isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
				isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]
				for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
				for json path, INCLUDE_NULL_VALUES
	END
	 end
	 else
	 begin
		set @isException=1
		set @exceptionMessage='No Barcode Found!'
		SET @responseCode='301'
	 end
 end
 End

 	if(@Opcode=21)    --- GetProductBySearch
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetProductBySearch', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
	
			select * into #TempSearchList from (
			Select PM.AutoId, ProductSizeName ProductName, ViewImage, case when isnull(ImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(ImagePath,'product.png') else '' end as ImagePath , SKUCount,ARM.Age,
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
			and (@ProductName is null or @ProductName='' or pm.ProductName like '%'+trim(@ProductName)+'%')
			and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
			and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)

			union 

			Select SM.AutoId, SKUPackingName ProductName, 1 ViewImage,case when isnull(SKUImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(SKUImagePath,'product.png') else '' end as SKUImagePath, 1 SKUCount,'0' Age,
			SM.AutoId as Barcode,SM.AutoId as SKUAutoId,
			case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_ProductWithSignleUnit')
			else (select ColorCode from tbl_ColorCodeMaster where ElementName='BG_SKU') end BG_ColorCode,
			case when SM.ProductId!=0 then (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_ProductWithSignleUnit')
			else (select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_SKU') end TEXT_ColorCode, 1 Quantity
			from SKUMaster SM
			where SM.Status=1 and SM.AutoId in(
			select distinct SKUAutoId from SKUItemMaster SIM
			inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId and SM.ProductId=0
			inner join ProductMaster PM on PM.AutoId=SIm.ProductId
			where SM.Status=1 and SM.ProductId=0
			and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
			and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
			)
			and StoreId=@StoreId
			and (@ProductName is null or @ProductName='' or SM.SKUPackingName like '%'+trim(@ProductName)+'%')

			union 

			Select SM.AutoId, SM.SchemeName ProductName, 1 ViewImage, case when isnull(SKUImagePath,'')!='' then @URL+'/Images/ProductImages/'+isnull(SKUImagePath,'product.png') else '' end as SKUImagePath, 1 SKUCount,'0' Age,
			SM.SKUAutoId as Barcode,SM.SKUAutoId as SKUAutoId,
			(select ColorCode from tbl_ColorCodeMaster where ElementName='BG_Scheme') BG_ColorCode,
			(select ColorCode from tbl_ColorCodeMaster where ElementName='TEXT_Scheme') TEXT_ColorCode, SM.Quantity Quantity
			from SchemeMaster SM
			inner join SKUMaster SMM on SMM.AutoId=SM.SKUAutoId
			where SM.Status=1 and SM.SKUAutoId in(
			select distinct SKUAutoId from SKUItemMaster SIM
			inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId --and SM.ProductId=0
			inner join ProductMaster PM on PM.AutoId=SIm.ProductId
			where SM.Status=1 
			and (@CategoryAutoId is null  or @CategoryAutoId='' or pm.CategoryId=@CategoryAutoId)
			and (@BrandAutoId  is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
			)
			and SMM.StoreId=@StoreId and SM.StoreId=@StoreId
			and (@ProductName is null or @ProductName='' or SM.SchemeName like '%'+trim(@ProductName)+'%')
			and (convert(date,getdate()) between  convert(date,isnull(SM.FromDate, getdate())) and convert(date,isnull(SM.ToDate, getdate())))
			and (DATENAME(dw,GETDATE()) in (select splitdata from dbo.fnSplitString(isnull(SM.SchemeDaysString,''),',')))
			)t

		select 0 as ScreenId, 'Home Screen' as ScreenName,
		isnull(( select * from #TempSearchList order by ProductName
		for json path, INCLUDE_NULL_VALUES),'[]') as [ProductList]
		for json path, INCLUDE_NULL_VALUES
	end

	if(@Opcode=22)    --- AddCustomer
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('AddCustomer', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
			If(isnull(@MobileNo,'')!='' and EXISTS(Select MobileNo from CustomerMaster where MobileNo=@MobileNo and StoreId=@StoreId))
			Begin
				Set @isException=1
				Set @exceptionMessage='Mobile no. already exists!'
				SET @responseCode='301'
			End	 
			ELSE
			BEGIN
			BEGIN TRY
			BEGIN TRAN
					declare @CustomerAutoId varchar(20)=null;
					SET @CustomerAutoId = (SELECT DBO.SequenceCodeGenerator('CustomerNo'))  		 	
					insert into CustomerMaster(CustomerId, FirstName, LastName, DOB, MobileNo, PhoneNo, EmailId, Address, State, City, Country, ZipCode, Status,StoreId)
					values (@CustomerAutoId, @FirstName, @LastName, @DOB, @MobileNo, '', @EmailId, @Address, @State, @City, '', @ZipCode, 1,@StoreId)
					set @CustomerId=SCOPE_IDENTITY();
					UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CustomerNo'

					 select isnull((select AutoId,(FirstName+' '+isnull(LastName,''))Name from CustomerMaster where AutoId=@CustomerId for json path, INCLUDE_NULL_VALUES),'[]') as CustomerDetail
			COMMIT TRANSACTION    
			END TRY                                          
			BEGIN CATCH     
			ROLLBACK TRAN                                                               
			Set @isException=1        
			Set @exceptionMessage=ERROR_MESSAGE()
			SET @responseCode='301'
			End Catch      
			END
	end

	if(@Opcode=23)    --- GetCustomerList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetCustomerList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
		Begin	
			select isnull((
			select AutoId, CustomerId,FirstName+' '+ isnull(LastName,'') as Name,case when isnull(DOB,'')!='' then FORMAT(CONVERT(datetime,DOB),'MM/dd/yyyy') else isnull(DOB,'') end As DOB, MobileNo, PhoneNo, EmailId, Address, State, City, 
			Country, ZipCode, Status,TotalPurchase,
			[RoyaltyPoint]=isnull((Select AssignedRoyaltyPoints from CustomerRoyaltyPoints where CustomerId=CM.AutoId),0)
			from CustomerMaster CM
			where Status=1 and isnull(StoreId,1)=@StoreId
			and (@FirstName is null or @FirstName='' or FirstName+' '+ISNULL(LastName,'') like '%'+@FirstName+'%')
			and (@MobileNo is null or @MobileNo='' or isnull(MobileNo,'') like '%'+@MobileNo+'%')
			and (@EmailId is null or @EmailId='' or isnull(EmailId,'') like '%'+@EmailId+'%')
			and (@CustomerIdV is null or @CustomerIdV='' or CustomerId=@CustomerIdV)
			order by isnull(seqNo,0) desc,FirstName asc
			for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail]
			for json path, INCLUDE_NULL_VALUES
			
		END
	end

	if(@Opcode=24)    --- ClockInOut
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('ClockInOut', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
		 DECLARE @AutoIDC int=null	
		 If(@SearchString='IN')
		 Begin
			if exists(select * from ClockINOUT where EmpId=@AutoId and ClockOUT is null and StoreId=@StoreId)
			Begin
				Set @isException=1
				Set @exceptionMessage='Already Clocked In!'
				SET @responseCode='301'
			End	 
			ELSE
			BEGIN
			BEGIN TRY
			BEGIN TRAN
			Declare @HourlyRate decimal(18,2)=isnull((select HourlyRate from UserDetailMaster where UserAutoId=@AutoId),0)
					Insert into ClockINOUT( EmpId,Remark,ClockIN,ClockOUT,CreatedDate,StoreId,HourlyRate)
					values(@AutoId,@Remark,@DateTime,null,GETDATE(),@StoreId,@HourlyRate)

					set @AutoIDC = SCOPE_IDENTITY()

					Insert into ClockInOutLog(ClockINOUTAutoId,PreviousDate,NewDate,Remark,CreatedBy,CreatedDate,StoreId,HourlyRate)
					values(@AutoIDC,@DateTime,null,@Remark,@AutoId,GETDATE(),@StoreId,@HourlyRate)

					select isnull((select case when isnull(ClockOUT,'')='' then 'ClockedIn' else 'ClockedOut' end as CorrentStatus,format(ClockIn,'MM/dd/yyyy hh:mm:ss tt') as ClockInDate from ClockINOUT 
					where EmpId=@AutoId and ClockOUT is null and StoreId=@StoreId for json path, INCLUDE_NULL_VALUES),'[]') as [ClockInDetail]
					for json path, INCLUDE_NULL_VALUES
			COMMIT TRANSACTION    
			END TRY                                          
			BEGIN CATCH     
			ROLLBACK TRAN                                                               
			Set @isException=1        
			Set @exceptionMessage=ERROR_MESSAGE()
			SET @responseCode='301'
			End Catch      
			END
		End
		ELSE If(@SearchString='OUT')
		Begin
			if exists(select * from ClockINOUT where EmpId=@AutoId and ClockOUT is null and StoreId=@StoreId)
			BEGIN
				set @AutoIDC=(select AutoId from ClockINOUT where EmpId=@AutoId and ClockOUT is null and StoreId=@StoreId)
				update ClockINOUT set CloseRemark=@Remark,ClockOUT=@DateTime,UpdatedDate=getdate() where EmpId=@AutoId and ClockOUT is null and StoreId=@StoreId
		
				update ClockInOutLog set CloseRemark=@Remark,NewDate=@DateTime where ClockINOUTAutoId=@AutoIDC and StoreId=@StoreId

				SET @exceptionMessage='Clocked Out.'
				SET @isException=0
				SET @responseCode='200'
			END
			Else
			begin
				SET @exceptionMessage='Already Clocked Out!'
				SET @isException=1
				SET @responseCode='301'
			end
		End
		ELSE If(@SearchString='')
		BEGIN
			select isnull((
			select top 1 case when isnull(ClockOUT,'')='' then 'ClockedIn' else 'ClockedOut' end as CorrentStatus,'' ClockInDate 
			from ClockINOUT where StoreId=@StoreId and EmpId=@AutoId order by AutoId desc
			for json path, INCLUDE_NULL_VALUES),'[]') as [ClockInDetail]
			for json path, INCLUDE_NULL_VALUES
		END
	end

	if(@Opcode=25)    --- AddGiftCard
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('AddGiftCard', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else
	begin try
	begin tran
    if exists (select GiftCardCode from GiftCardSale where SoldStatus in (1,2) and CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and StoreId=@StoreId)
	begin
	  SET @exceptionMessage='Gift Card No already exists.'
	  SET @responseCode='300'
      SET @isException=1
	end
	else if ((select count(1) from CustomerMaster where MobileNo=@MobileNo and StoreId=@StoreId)>0 and (select FirstName from CustomerMaster where  AutoId=@CustomerId)='Walk In')
    begin
      SET @isException=1
      SET @exceptionMessage='Mobile no already exists.'
	  SET @responseCode='300'
    end
	else if(@OrderNo!='')
	  begin	
		Declare @Count int=0
		set @Count=(select count(*) from CartSKUMaster CS Inner Join CartMaster CM on CM.AutoId=CS.OrderAutoId where CS.SKUName=@SKUName AND CM.OrderNo=@OrderNo)
		if(@Count>1)
		begin
			SET @isException=1
			SET @exceptionMessage='Gift Card already exists.'
			SET @responseCode='300'
		end
	  end
	else
	begin
	 ---Customer Creation or existing customer
	  if((select FirstName from CustomerMaster where  AutoId=@CustomerId)!='Walk In')
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
			SET @CustomerIdV = (SELECT DBO.SequenceCodeGenerator('CustomerNo'))  

			insert into CustomerMaster(CustomerId, FirstName, LastName, DOB, MobileNo, PhoneNo, EmailId, Address, State, City, Country, ZipCode, Status,StoreId)
			values (@CustomerIdV, @FirstName, @LastName, @DOB, @MobileNo, '', @EmailId, @Address, @State, @City, '', @ZipCode, 1,@StoreId)
			
			set @CustomerId=SCOPE_IDENTITY();

			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CustomerNo'
	  end
	  -- Gift card Creation or existing
	  if exists (select GiftCardCode from GiftCardSale where SoldStatus in (0) and  CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and StoreId=@StoreId)
	  BEGIN
	     update GiftCardSale set StoreId=@StoreId,TerminalId=@TerminalId,CustomerAutoId=@CustomerId,SoldBy=@AutoId,SoldDate=GETDATE(),TotalAmt=@GiftCardAmt,LeftAmt=@GiftCardAmt
	     where SoldStatus in (0) and  CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and StoreId=@StoreId
	  END
	  ELSE
	  BEGIN
	     Insert into GiftCardSale(GiftCardCode,TotalAmt,SoldDate,SoldBy,SoldStatus,StoreId,TerminalId,CustomerAutoId,LeftAmt)
	  	 values(@GiftCardNo,@GiftCardAmt,GETDATE(),@AutoId,0,@StoreId,@TerminalId,@CustomerId,@GiftCardAmt)
	  END
	  ----------------------------- Gift Card Add in Cart -------------------------------
	  set @Quantity=1
	  if(@OrderNo!='')
	  begin	
			set @OrderId=(select AutoId from CartMaster where OrderNo=@OrderNo)
			update CartMaster set CustomerId=@CustomerId, UpdatedDate=GETDATE(), TerminalId=@TerminalId, ShiftAutoId=@ShiftId where AutoId=@OrderId 
	  end
	  else
	  begin
	      SET @OrderNo = (SELECT DBO.SequenceCodeGenerator('OrderNo'))			 
		
		  insert into CartMaster(OrderNo, CustomerId, CreatedDate, UpdatedDate,UpdatedBy, Status,CreatedBy,StoreId,TerminalId,DraftName,DraftDateTime,ShowAsDraft,DiscType,Discount,ShiftAutoId,IsDeleted)
		  values(@OrderNo,@CustomerId,GETDATE(),GETDATE(),@AutoId,1,@AutoId,@StoreId,@TerminalId,'','',0,ISNULL(@DiscType,''),isnull(@Discount,0),@ShiftId,0)
		  Set @OrderId=scope_Identity()
		  UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='OrderNo'
	    end
		if(isnull(@CartItemId,0)=0)
		begin 
			insert into CartSKUMaster([OrderAutoId], [SKUId], [SchemeId], [Quantity], [SKUName])
			values(@OrderId, @SKUAutoId, 0, @Quantity, @SKUName)
			Set @CartItemId=scope_Identity()
		end
		else
		begin
			if(@Quantity>0)
			begin
				update CartSKUMaster set SchemeId=0, Quantity=@Quantity, SKUName=@SKUName where AutoId=@CartItemId
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


		select isnull((select AutoId, FirstName +isnull(' '+LastName,'') as [Name] from CustomerMaster where AutoId=(select CustomerId from CartMaster where AutoId=@OrderId) for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
				isnull((
				Select csm.AutoId as CartItemId,csm.SKUId ,csm.SKUName, csm.SchemeId, csm.Quantity,isnull(MinAge,0)MinAge,
				@URL+'/Images/ProductImages/'+(case when isnull(SM.SKUImagePath,'')!='' then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
				then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
				, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice,case when csm.SKUName like '%Lottery%' then 'Lottery' else 'Product' end as ProductType
				from CartSKUMaster csm
				left join SKUMaster sm on sm.AutoId=csm.SKUId
				where OrderAutoId=@OrderId order by csm.AutoId Desc 
				for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
				isnull((
				select @OrderId OrderId, @OrderNo OrderNo, isnull(@Disc,0) Discount,@DiscType DiscType,case when @DiscType='Percentage' then @Discount else 0 end as DiscountPer,-- cm.DiscType from CartMaster cm where cm.AutoId=@OrderId for json path, INCLUDE_NULL_VALUES),'[]') as OrderDetail,
				isnull((select Count(*) from CartSKUMaster where OrderAutoId=@OrderId),0)ItemCount,
				isnull((select sum(Quantity) from CartSKUMaster where OrderAutoId=@OrderId),0)TotalQuantity,
				isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
				isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
				isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
				isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
				isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]
				for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
				for json path, INCLUDE_NULL_VALUES
   END
   commit tran
   end try
   begin catch
     rollback tran
	 set @isException=1
	 set @exceptionMessage=ERROR_MESSAGE()
	 SET @responseCode='300'
  end catch
	end

	if(@Opcode=26)    --- ApplyGiftCard
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('ApplyGiftCard', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else	
		 Begin
			if not exists(select * from GiftCardSale where  CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and SoldStatus!=2 and StoreId=@StoreId)
			Begin
				Set @isException=1
				Set @exceptionMessage='No Gift Card found!'
				SET @responseCode='301'
			End	
			ELSE
			BEGIN
				select isnull((select AutoId,GiftCardCode,TotalAmt,LeftAmt,GiftCardPurchaseInvoice,StoreId,TerminalId,CustomerAutoId
				from GiftCardSale where  CAST(GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCardNo) AS VARBINARY(100)) and SoldStatus!=2 and StoreId=@StoreId for json path, INCLUDE_NULL_VALUES),'[]') as [GiftCardDetail]
				for json path, INCLUDE_NULL_VALUES
			END
		End
	end

	if(@Opcode=27)    --- GetCouponDetails
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetCouponDetails', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else	
		 Begin			
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

				select * into #TableT2 from (select  isnull(@Disc,0) Discount,@DiscType DiscType,case when @DiscType='Percentage' then @Discount else 0 end as DiscountPer,				
				isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
				isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
				isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
				isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
				isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]) A

				Declare @LotterySale decimal(18,2)=(select (LotteryTotal-LotteryPayout) from #TableT2),
				@ApplicableOrderTotal decimal(18,2)=null,@CouponAmt decimal(18,2)=null,@TAutoId int=null

				if(@LotterySale > 0)
					Begin
					   set @ApplicableOrderTotal=(select (OrderTotal-@LotterySale) from #TableT2)
					End
				else
				 Begin
				  set @ApplicableOrderTotal=(select OrderTotal from #TableT2)
				 End

			if not exists(select * from CouponMaster where convert(date,StartDate,109)<=convert(date,getdate(),109) and convert(date,EndDate,109)>=convert(date,getdate(),109) and isnull(Applied,0)=0 and Status=1 and StoreId=@StoreId  and CAST(CouponCode AS VARBINARY(30)) = CAST(@CouponCode AS VARBINARY(30)))
				Begin
					SET @exceptionMessage='Invalid Coupon Code!'
					SET @isException=1
					SET @responseCode='301'
				End
			Else if exists(select * from CouponMaster where convert(date,StartDate,109)<=convert(date,getdate(),109) and convert(date,EndDate,109)>=convert(date,getdate(),109) and isnull(Applied,0)=0 and Status=1 and StoreId=@StoreId  and CAST(CouponCode AS VARBINARY(30)) = CAST(@CouponCode AS VARBINARY(30)) and CouponAmount<=@ApplicableOrderTotal)
				BEGIN				
					select AutoId,CouponCode,CouponType,Discount,CouponAmount --,case when CouponType=1 then 'Fix' else 'Per' end as Type
					into #TableT1 from CouponMaster
					where convert(date,StartDate,109)<=convert(date,getdate(),109) and convert(date,EndDate,109)>=convert(date,getdate(),109) and isnull(Applied,0)=0 and Status=1 and StoreId=@StoreId and  CAST(CouponCode AS VARBINARY(30)) = CAST(@CouponCode AS VARBINARY(30)) and CouponAmount<=@ApplicableOrderTotal

					if(isnull((select count(*) from TransactionType where PaymentType='Coupon' and TransactionAutoId=@TransactionAutoId),0)>0)
					Begin					
					Update dbo.[Transaction] set PaidAmt=PaidAmt-(select PaymentAmt from TransactionType where PaymentType='Coupon' and TransactionAutoId=@TransactionAutoId),ReturnAmt=0,PaymentStatus='Pending'
					delete from TransactionType where PaymentType='Coupon' and TransactionAutoId=@TransactionAutoId
					
					set @ApplicableOrderTotal=@ApplicableOrderTotal - isnull((select PaidAmt from dbo.[Transaction] where AutoId=@TransactionAutoId),0)

						if(@ApplicableOrderTotal>(select CouponAmount from #TableT1))
							Begin
								if((select CouponType from #TableT1)=1)
									Begin
										set @CouponAmt=(select Discount from #TableT1)
									End
								Else
									Begin
										set @CouponAmt=convert(decimal(18,2),(@ApplicableOrderTotal/100)) * (select Discount from #TableT1)
									End
								update dbo.[Transaction] set OrderAmt=(select OrderTotal from #TableT2),PaidAmt=(PaidAmt+@CouponAmt),ReturnAmt=0,PaymentStatus='Pending' where AutoId=@TransactionAutoId 
							
								Insert into TransactionType (TransactionAutoId,PaymentType,PaymentAmt,Status,PaymentCode,CardNo) 
								values(@TransactionAutoId,'Coupon',@CouponAmt,0,(select CouponCode from #TableT1),'')

								select isnull((select AutoId,OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus from dbo.[Transaction] for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionDetail],
								Isnull((select TT.AutoId,TT.TransactionAutoId,TT.PaymentType,TT.PaymentAmt,TT.Status,TT.PaymentCode,TT.CardNo from TransactionType TT
								where TT.TransactionAutoId=@TransactionAutoId for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionTypeDetail]
								for json path, INCLUDE_NULL_VALUES
							END
						Else if(@ApplicableOrderTotal=(select CouponAmount from #TableT1))
							Begin
								if((select CouponType from #TableT1)=1)
									Begin
										set @CouponAmt=(select Discount from #TableT1)
									End
								Else
									Begin
										set @CouponAmt=convert(decimal(18,2),(@ApplicableOrderTotal/100)) * (select Discount from #TableT1)
									End
								update dbo.[Transaction] set OrderAmt=(select OrderTotal from #TableT2),PaidAmt=@CouponAmt,ReturnAmt=0,PaymentStatus='Success' where AutoId=@TransactionAutoId 

								Insert into TransactionType (TransactionAutoId,PaymentType,PaymentAmt,Status,PaymentCode,CardNo) 
								values(@TransactionAutoId,'Coupon',@CouponAmt,0,(select CouponCode from #TableT1),'')

								select isnull((select AutoId,OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus from dbo.[Transaction] for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionDetail],
								Isnull((select TT.AutoId,TT.TransactionAutoId,TT.PaymentType,TT.PaymentAmt,TT.Status,TT.PaymentCode,TT.CardNo from TransactionType TT
								where TT.TransactionAutoId=@TransactionAutoId for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionTypeDetail]
								for json path, INCLUDE_NULL_VALUES
							END
						Else
							Begin
							SET @exceptionMessage='Coupon is not applicable on this Amount.'
							SET @isException=1
							SET @responseCode='301'
						END

					ENd
					Else
					Begin
						if(@ApplicableOrderTotal>(select CouponAmount from #TableT1))
							Begin
								if((select CouponType from #TableT1)=1)
									Begin
										set @CouponAmt=(select Discount from #TableT1)
									End
								Else
									Begin
										set @CouponAmt=convert(decimal(18,2),(@ApplicableOrderTotal/100)) * (select Discount from #TableT1)
									End
								Insert into dbo.[Transaction] (OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus,CreatedDate,InvoiceAutoId) 
								values(@OrderNo,@OrderId,(select OrderTotal from #TableT2),@CouponAmt,0,'Pending',GETDATE(),null)

								set @TAutoId=SCOPE_IDENTITY()

								Insert into TransactionType (TransactionAutoId,PaymentType,PaymentAmt,Status,PaymentCode,CardNo) 
								values(@TAutoId,'Coupon',@CouponAmt,0,(select CouponCode from #TableT1),'')

								select isnull((select AutoId,OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus from dbo.[Transaction] for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionDetail],
								Isnull((select TT.AutoId,TT.TransactionAutoId,TT.PaymentType,TT.PaymentAmt,TT.Status,TT.PaymentCode,TT.CardNo from TransactionType TT
								where TT.TransactionAutoId=@TAutoId for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionTypeDetail]
								for json path, INCLUDE_NULL_VALUES
							END
						Else if(@ApplicableOrderTotal=(select CouponAmount from #TableT1))
							Begin
								if((select CouponType from #TableT1)=1)
									Begin
										set @CouponAmt=(select Discount from #TableT1)
									End
								Else
									Begin
										set @CouponAmt=convert(decimal(18,2),(@ApplicableOrderTotal/100)) * (select Discount from #TableT1)
									End
								Insert into dbo.[Transaction] (OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus,CreatedDate,InvoiceAutoId) 
								values(@OrderNo,@OrderId,(select OrderTotal from #TableT2),@CouponAmt,0,'Success',GETDATE(),null)

								set @TAutoId=SCOPE_IDENTITY()

								Insert into TransactionType (TransactionAutoId,PaymentType,PaymentAmt,Status,PaymentCode,CardNo) 
								values(@TAutoId,'Coupon',@CouponAmt,0,(select CouponCode from #TableT1),'')

								select isnull((select AutoId,OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus from dbo.[Transaction] for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionDetail],
								Isnull((select TT.AutoId,TT.TransactionAutoId,TT.PaymentType,TT.PaymentAmt,TT.Status,TT.PaymentCode,TT.CardNo from TransactionType TT
								where TT.TransactionAutoId=@TAutoId for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionTypeDetail]
								for json path, INCLUDE_NULL_VALUES
							END
						Else
							Begin
							SET @exceptionMessage='Coupon is not applicable on this Amount.'
							SET @isException=1
							SET @responseCode='301'
						END
					End
				End
			Else
			begin
				Set @TotalAmt=isnull((select convert(decimal(18,2),CouponAmount) from CouponMaster where Status=1 and StoreId=@StoreId and  CAST(CouponCode AS VARBINARY(30)) = CAST(@CouponCode AS VARBINARY(30))),0)
				SET @exceptionMessage='Order Total should be equal to Amount ' + convert(varchar(10),@TotalAmt) + '.'
				SET @isException=1
				SET @responseCode='301'
			End
		End
	End

	if(@Opcode=28)    --- GetCustomerDetails
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetCustomerDetails', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed.'	
			SET @responseCode='301'
	  END
	 else	
		 Begin
			if not exists(select * from CustomerMaster where AutoId=@CustomerId and Status=1)
			Begin
				SET @exceptionMessage='No Customer Found.'
				SET @isException=1
				SET @responseCode='301'
			End
			Else 
			BEGIN
				select isnull((
					select AutoId,CustomerId,FirstName,LastName,FORMAT(convert(datetime,isnull(DOB,'')),'MM/dd/yyyy') DOB,MobileNo,PhoneNo,EmailId,
					Address,State,City,Country,ZipCode from CustomerMaster where AutoId=@CustomerId and Status=1
				for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail] for json path, INCLUDE_NULL_VALUES
			end
		End
	end

	if(@Opcode=29)    --- GetPayNowButtonList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetPayNowButtonList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'User is Not Allowed'	
		SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT * from ScreenMaster where StoreId=@StoreId)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'No Screen Found'	
		SET @responseCode='301'
	  END	  
	  else
	  begin
			select 
				isnull((select * from ActionButton where Type='Currency' ORDER BY SeqNo asc for json path, INCLUDE_NULL_VALUES),'[]') as [Currency],
				isnull((select * from ActionButton where Type='Pay' ORDER BY SeqNo asc for json path, INCLUDE_NULL_VALUES),'[]') as [Pay]				
			for json path, INCLUDE_NULL_VALUES
	  end
	end

	if(@Opcode=30)    --- GetRewardPointDetails
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetRewardPointDetails', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'User is Not Allowed'	
		SET @responseCode='301'
	  END
	  else if exists(select * from RoyaltyMaster where StoreId=@StoreId and Status=1)
	begin
	Declare @RP int=null,@CRP int
	set @RP=isnull((select AssignedRoyaltyPoints from CustomerRoyaltyPoints where CustomerId=@CustomerId),0)

		select @RP as CustomerRP, isnull((
			select AutoId,AmtPerRoyaltyPoint,MinOrderAmt
			from RoyaltyMaster where StoreId=@StoreId
		for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerRPDetail] for json path, INCLUDE_NULL_VALUES
	end
	else
	begin
         set @isException=1
		 set @exceptionMessage='Not Applicable!'
		 SET @responseCode='300'
	end	
	end

	if(@Opcode=32)    --- GetCreditCardList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetCreditCardList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else IF not EXISTS(select * from CardTypeMaster)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'No Card Found.'	
		SET @responseCode='301'
	  END
	  else 
	begin
		select isnull((
			select AutoId,CardTypeName,textColor,BGColor,CardNameAbbr from CardTypeMaster where Status=1 Order By seq Asc
		for json path, INCLUDE_NULL_VALUES),'[]') as [CardTypeDetail] for json path, INCLUDE_NULL_VALUES
	end
	
	end

	if(@Opcode=33)    --- GetSecurityPin
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetSecurityPin', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else IF not EXISTS(select SecurityPin,Status,type from tbl_SecurityPinMaster where UserId=@AutoId and SecurityPin=@SecurityPin and Type=@SearchString)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'failed'	
		SET @responseCode='301'
	  END
	  else IF EXISTS(select SecurityPin,Status,type from tbl_SecurityPinMaster where UserId=@AutoId and SecurityPin=@SecurityPin and Type=@SearchString)
	begin
		SET @isException=1  
	    SET @exceptionMessage= 'success'	
		SET @responseCode='200'
	end
	
	end

	if(@Opcode=34)    --- DraftOrder
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('DraftOrder', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else if not exists(select * from CartMaster where DraftName=@DraftName and Status=1 and StoreId=@StoreId and convert(date,DraftDateTime)=convert(date,GETDATE()))
		BEgin
           update CartMaster Set DraftName=@DraftName, DraftDateTime=getdate(),ShowAsDraft=1, CustomerId=@CustomerId where StoreId=@StoreId and OrderNo=@OrderNo
			Set @isException=1                                                                                                   
			Set @exceptionMessage='Draft Order saved successfully.' 
			SET @responseCode='200'
		  
		END
	   else if exists(select * from CartMaster where DraftName=@DraftName and Status=1 and StoreId=@StoreId and convert(date,DraftDateTime)=convert(date,GETDATE()))
		BEgin
           update CartMaster Set DraftName=@DraftName, DraftDateTime=getdate(),ShowAsDraft=1,CustomerId=@CustomerId where StoreId=@StoreId and OrderNo=@OrderNo
			Set @isException=1                                                                                                   
			Set @exceptionMessage='Draft Order updated successfully.' 
			SET @responseCode='200'
		  
		END
		ELSE
		BEGIN
		Set @isException=1                                                                                                   
		Set @exceptionMessage='Draft Name already exists!' 
		SET @responseCode='301'
		END
	end

	if(@Opcode=35)    --- DeleteDraftOrder
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('DeleteDraftOrder', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else if exists(select * from CartMaster where OrderNo=@OrderNo and StoreId=@StoreId)
		BEgin
          update CartMaster Set DraftName='', DraftDateTime='',ShowAsDraft=0 where StoreId=@StoreId and OrderNo=@OrderNo
			Set @isException=1                                                                                                   
			Set @exceptionMessage='Draft Order deleted successfully.' 
			SET @responseCode='200'
		 
		END
	  ELSE
		BEGIN
		Set @isException=1                                                                                                   
		Set @exceptionMessage='Draft Order not exists.' 
		SET @responseCode='301'
		END
	end

	if(@Opcode=36)    --- GetDraftList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetDraftList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else 
		BEgin

		   select isnull((
		   	select isnull(DraftName,'') DraftName,format(DraftDateTime, 'MM/dd/yyyy hh:mm tt') DraftDateTime,OrderNo,DM.AutoId as OrderId,case when isnull(DraftName,'')!='' then 'Draft By User' else 'Auto Draft' end as [Type],
			UM.FirstName + ' ' + UM.LastName as UserName,cm.FirstName + cm.LastName as CustomerName from CartMaster DM
			inner join CustomerMaster cm on cm.AutoId=DM.CustomerId
			Inner Join UserDetailMaster UM on UM.UserAutoId=DM.CreatedBy
			where DM.StoreId=@StoreId and DM.TerminalId=@TerminalId and isnull(DM.DraftName,'')!='' and DM.ShowAsDraft=1 and format(DraftDateTime, 'MM/dd/yyyy')=format(GETDATE(), 'MM/dd/yyyy')
		 for json path, INCLUDE_NULL_VALUES),'[]') as [DraftDetail] for json path, INCLUDE_NULL_VALUES
		END
		
	end

	if(@Opcode=37)    --- Payout
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('Payout', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else 
		BEgin
			BEGIN TRY
			BEGIN TRAN  
					INSERT INTO PayoutMaster(PayTo,Remark,Amount,PayoutMode,TransactionId,CreatedBy,CreatedDate,CompanyId,Expense,Vendor,PayoutType,Terminal,PayoutDate,PayoutTime,ShiftId) 		   
					values(@PayoutTo,@Remark,@TotalAmt,@PaymentMode,'',@AutoId,GETDATE(),@StoreId,@Expense,@Vendor,@PayoutType,@TerminalId,@PayoutDate,@PayoutTime,@ShiftId)

					Declare @PayoutId int=SCOPE_IDENTITY()

					INSERT INTO PayoutMasterLog(PayoutId,PayTo,Remark,Amount,PayoutMode,TransactionId,CreatedBy,CreatedDate,CompanyId,Expense,Vendor,PayoutType,Terminal,PayoutDate,PayoutTime,ShiftId) 		   
					values(@PayoutId,@PayoutTo,@Remark,@TotalAmt,@PaymentMode,'',@AutoId,GETDATE(),@StoreId,@Expense,@Vendor,@PayoutType,@TerminalId,@PayoutDate,@PayoutTime,@ShiftId)
			
			COMMIT TRANSACTION    
			END TRY                                                                                                                                      
			BEGIN CATCH                                                                                                                                
				ROLLBACK TRAN                                                                                                                         
				Set @isException=1                                                                                                   
				Set @exceptionMessage=ERROR_MESSAGE()                                                                       
			End Catch
		END
		
	end

	if(@Opcode=38)    --- GetPayoutList
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('Payout', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  	SET @isException=1  
		SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
		SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  	SET @isException=1  
		SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
		SET @responseCode='301'
	  END
	  else 	 
		   SELECT pm.AutoId,PayTo,Remark,Amount,cp.CompanyName,
		   PayoutMode,isnull(TransactionId,'') TransactionId, ud.FirstName+' '+ud.LastName as CreatedBy,pm.CreatedBy as EmpId,isnull(EM.ExpenseName,'') ExpenseName,isnull(VM.VendorName,'') VendorName,PTM.PayoutType, 
		   format(pm.CreatedDate,'MM/dd/yyyy') CreatedDate, format(pm.PayoutDate,'MM/dd/yyyy') as PayoutDate,pm.PayoutTime      
		   into #temp2       
		   FROM PayoutMaster pm
			inner join UserDetailMaster ud on ud.UserAutoId=pm.CreatedBy
			left join PayoutTypeMaster PTM on PTM.AutoId=pm.PayoutType
			left join ExpenseMaster EM on EM.AutoId=pm.Expense
			left join VendorMaster VM on VM.AutoId=pm.Vendor
			left join CompanyProfile cp on cp.AutoId=pm.CompanyId
			where (@PayoutTo is null or @PayoutTo='' or PayTo like @PayoutTo+'%') 
			and(@TotalAmt is null or @TotalAmt=0 or Amount=@TotalAmt)
			and (@StoreId is null or @StoreId=0 or pm.CompanyId=@StoreId)
			and (@PayoutType is null or @PayoutType=0 or PTM.AutoId=@PayoutType)
			and (@Expense is null or @Expense=0 or  EM.AutoId=@Expense)
			and (@Vendor is null or @Vendor=0 or VM.AutoId=@Vendor)
			and convert(date,pm.CreatedDate)=convert(date,getdate())
		   order by pm.CreatedDate desc 

		   select (SELECT SUM(Amount) As TotalAmount FROM #temp2) TotalAmt,
		   isnull(( select * from #temp2 for json path, INCLUDE_NULL_VALUES),'[]') as [CardTypeDetail] for json path, INCLUDE_NULL_VALUES		   
	end

	if(@Opcode=39)    --- CashTransaction
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('CashTransaction', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
	  if not exists(select AutoId from API_CredentialDetail where AccessToken=@AccessToken and Hashkey=@Hashkey)
	  begin
	  		SET @isException=1  
			SET @exceptionMessage=' AccessToken or Hashkey are invalid' 
			SET @responseCode='301'
	  end
	  Else if not exists(select AutoId from [dbo].[API_Version] where [Version]=@AppVersion AND [Status]=1)
	  BEGIN
	  		SET @isException=1  
			SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+')'
			SET @responseCode='301'
	  END
	  else IF not EXISTS(SELECT LoginID from [UserDetailMaster] where UserAutoId=@AutoId and IsAppAllowed=1 and isnull(Status,0)=1)  
	  BEGIN
			SET @isException=1  
			SET @exceptionMessage= 'User is Not Allowed'	
			SET @responseCode='301'
	  END
	 else	
		 Begin			
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

				select * into #TableT4 from (select  isnull(@Disc,0) Discount,@DiscType DiscType,case when @DiscType='Percentage' then @Discount else 0 end as DiscountPer,				
				isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
				isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
				isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
				isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
				isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]) A

				Declare @ApplicableOrderTotal1 decimal(18,2)=null,@TAutoId1 int=null

					set @ApplicableOrderTotal1=(select (OrderTotal-LotteryTotal) from #TableT4)
				
					if(isnull((select count(*) from TransactionType where PaymentType='Cash' and TransactionAutoId=@TransactionAutoId),0)>0)
					Begin							
						Update dbo.[Transaction] set PaidAmt=PaidAmt-(select PaymentAmt from TransactionType where PaymentType='Cash' and TransactionAutoId=@TransactionAutoId),ReturnAmt=0,PaymentStatus='Pending'
						delete from TransactionType where PaymentType='Cash' and TransactionAutoId=@TransactionAutoId
					END
						if(isnull((select count(*) from dbo.[Transaction] where AutoId=@TransactionAutoId),0)>0)
						Begin
							set @ApplicableOrderTotal1=@ApplicableOrderTotal1 - isnull((select PaidAmt from dbo.[Transaction] where AutoId=@TransactionAutoId),0)

							if(@ApplicableOrderTotal1 > @CashAmount)
							Begin
								set @ReturnAmt=0; set @PaymentStatus='Pending'
							End
							ELSE if(@ApplicableOrderTotal1 < @CashAmount)
							Begin
								set @ReturnAmt=(@ApplicableOrderTotal1-@CashAmount); set @PaymentStatus='Success'
							End
							ELSE if(@ApplicableOrderTotal1 = @CashAmount)
							Begin
								set @ReturnAmt=(@ApplicableOrderTotal1-@CashAmount); set @PaymentStatus='Success'
							End
							update dbo.[Transaction] set OrderAmt=(select OrderTotal from #TableT4),PaidAmt=(PaidAmt+@CashAmount),ReturnAmt=@ReturnAmt,PaymentStatus=@PaymentStatus where AutoId=@TransactionAutoId 
							
							Insert into TransactionType (TransactionAutoId,PaymentType,PaymentAmt,Status,PaymentCode,CardNo) 
							values(@TransactionAutoId,'Cash',@CashAmount,0,'','')

							select isnull((select AutoId,OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus from dbo.[Transaction] for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionDetail],
							Isnull((select TT.AutoId,TT.TransactionAutoId,TT.PaymentType,TT.PaymentAmt,TT.Status,TT.PaymentCode,TT.CardNo from TransactionType TT
							where TT.TransactionAutoId=@TransactionAutoId for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionTypeDetail]
							for json path, INCLUDE_NULL_VALUES						
					END
					Else
					Begin							
							if(@ApplicableOrderTotal1 > @CashAmount)
							Begin
								set @ReturnAmt=0; set @PaymentStatus='Pending'
							End
							ELSE if(@ApplicableOrderTotal1 < @CashAmount)
							Begin
								set @ReturnAmt=(@ApplicableOrderTotal1-@CashAmount); set @PaymentStatus='Success'
							End
							ELSE if(@ApplicableOrderTotal1 = @CashAmount)
							Begin
								set @ReturnAmt=(@ApplicableOrderTotal1-@CashAmount); set @PaymentStatus='Success'
							End

							Insert into dbo.[Transaction] (OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus,CreatedDate,InvoiceAutoId) 
							values(@OrderNo,@OrderId,(select OrderTotal from #TableT4),@CashAmount,@ReturnAmt,@PaymentStatus,GETDATE(),null)

							set @TAutoId=SCOPE_IDENTITY()

							Insert into TransactionType (TransactionAutoId,PaymentType,PaymentAmt,Status,PaymentCode,CardNo) 
							values(@TAutoId,'Cash',@CashAmount,0,'','')

							select isnull((select AutoId,OrderNo,OrderId,OrderAmt,PaidAmt,ReturnAmt,PaymentStatus from dbo.[Transaction] for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionDetail],
							Isnull((select TT.AutoId,TT.TransactionAutoId,TT.PaymentType,TT.PaymentAmt,TT.Status,TT.PaymentCode,TT.CardNo from TransactionType TT
							where TT.TransactionAutoId=@TAutoId for json path, INCLUDE_NULL_VALUES),'[]') as [TransactionTypeDetail]
							for json path, INCLUDE_NULL_VALUES						
					END
			End
	End
	END TRY  
	BEGIN CATCH  
		SET @isException=1  
		SET @exceptionMessage=ERROR_MESSAGE()  
		SET @responseCode='300'
	END CATCH  
 end
GO
