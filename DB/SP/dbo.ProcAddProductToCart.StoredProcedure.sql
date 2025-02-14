create or alter proc [dbo].[ProcAddProductToCart]
@Opcode int=Null,
@AccessToken varchar(50)=null,
@Hashkey varchar(50)=null,
@DeviceId varchar(100)=null,
@LatLong varchar(100)=null,
@AppVersion varchar(20)=null,
@RequestSource varchar(20)=null,
@LoginId varchar(100)=null,
@URL varchar(200)=null,
@OrderId int=null,
@DraftName varchar(100)=null,
@ShiftId int=null,
@SchemeAutoId int=null,
@Discount decimal(18,2)=null,
@DiscType varchar(20)=null,
@OrderNo varchar(20)=null,
@StoreId int=null,
@SKUAmt decimal(18,2)=null,
@GiftCardCode varchar(30)=null,
@TerminalId int=null,
@SKUName varchar(150)=null,
@ProductName varchar(500)=null,
@CustomerId int=null,
@PackingId int=null,
@Disc decimal(18,2)=null,
@Type varchar(50)=null,
@CartItemId int=null,
@AutoId int=null,
@Quantity int=null,
@TotalQty int=null,
@Barcode varchar(100)=null,
@ProductId int=null,
@SKUId int=null,
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
	if(@Opcode=41)    --- AddToCartAPI
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('AddToCartAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF((select case when @SKUId!=0 or @SKUId!='' then (SELECT COUNT(*) from SKUMaster where AutoId=@SKUId and StoreId=@StoreId) end as AutoId)<=0)  
	  BEGIN
		SET @isException=1  
		SET @exceptionMessage= 'No Product Found'	
	  END
	  else
	  begin
		if(@OrderNo!='')
        begin    
			set @OrderId=(select AutoId from CartMaster where OrderNo=@OrderNo)
			update CartMaster set CustomerId=@CustomerId, UpdatedDate=GETDATE(), TerminalId=@TerminalId, ShiftAutoId=@ShiftId where AutoId=@OrderId 
        end
        else
        begin
			SET @OrderNo = (SELECT DBO.SequenceCodeGenerator('OrderNo'))             
			
			insert into CartMaster(OrderNo, CustomerId, CreatedDate, UpdatedDate,UpdatedBy, Status, CreatedBy, StoreId, TerminalId, ShiftAutoId,DraftName,DraftDateTime,ShowAsDraft,DiscType,Discount,IsDeleted)
			values(@OrderNo, @CustomerId, GETDATE(), GETDATE(),@AutoId, 1, @AutoId, @StoreId, @TerminalId , @ShiftId,ISNULL(@DraftName,''),'',0,isnull(@DiscType,''),isnull(@Discount,0),0)

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
	end
	end

	if(@Opcode=21)    --- ApplyDiscount
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('ApplyDiscount', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF not EXISTS(SELECT * from CartMaster where OrderNo=@OrderNo)  
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
	  end
	end

	if(@Opcode=22)    --- GetCartDetails
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetCartDetails', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF not EXISTS(SELECT * from CartMaster where OrderNo=@OrderNo)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'Order Details Not Found.'
	  END
	  else
	  begin 
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
	  end
	end

	if(@Opcode=23)    --- ResetCartDetails
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('ResetCartDetails', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF not EXISTS(SELECT * from CartMaster where OrderNo=@OrderNo)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'Order Details Not Found.'
	  END
	  else
	  begin 
		    Update CartMaster set IsDeleted=1 where OrderNo=@OrderNo
	  end
	end
	END TRY  
	BEGIN CATCH  
		SET @isException=1  
		SET @exceptionMessage=ERROR_MESSAGE()  
		SET @responseCode='300'
	END CATCH  
 end
GO
