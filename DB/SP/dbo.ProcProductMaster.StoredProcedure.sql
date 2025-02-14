
ALTER   procedure [dbo].[ProcProductMaster]
@Opcode int =null,
@AutoId int=null,
@VendorId int=null,
@DeptId int=null,
@ProductAutoId  int=null,
@ProductId varchar(50)=null,
@BrandAutoId int=null,
@StoreId int=null,
@ProductShortName varchar(30)=null,
@ProductSize varchar(100)=null,
@GroupId int=null,
@BarcodeForEdit varchar(50)=null,
@InStockQty int=null,
@AlertQty int=null,
@MeasurementUnitId int=null,
@ProductIdsList varchar(max)=null,
@CatgoryAutoId int=null,
@MeasurementUnit varchar(50)=null,
@NoOfPieces  int=null,
@VendorProductCode varchar(50)=null,
@PieceSize varchar(20)=null,
@SecondaryUnitPrice decimal(18,2)=null,
@ImageName varchar(200)=null,
@WebAvailability varchar(20)=null,
@ProductName varchar(200)=null,
@Packing varchar(200)=null,
@Description varchar(max)=null,
@CostPrice decimal(18,2)=null,
@UnitPrice decimal(18,2)=null,
@AgeRestrictionId int=null,
@TaxAutoId int=null,
@ManageStock int=null,
@InStock int=null,
@LowStock int=null,
@Barcode varchar(200)=null,
@ViewImage int=null,
@VerificationCode int=null,
@Image varchar(max)=null,
@DT_PakingType [dbo].[DT_PakingType] readonly,
@DT_VendorProductCode DT_VendorProductCode readonly,
@DT_Barcode  DT_Barcode readonly,
@StoreIdsString varchar(500)=null,
@SKUAutoId int=null,
@MasterInsertId int=null,
@SKUId varchar(50)=null,
@Status int=null,
@Who int=null,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
AS
Begin
declare @i11 int=1, @row11 int=0;
BEGIN TRY
Set @isException=0  
If @Opcode=11
begin
	If exists (select ProductName,* from ProductMaster where ProductName=@ProductName and Size=@ProductSize and MeasurementUnit=(select UnitName from measurementUnitMaster where AutoId=@MeasurementUnit))  
	Begin
		Set @isException=1
		Set @exceptionMessage='Product details already exist.'
	End  
	else if(( select count(*) from BarcodeMaster where Barcode in (select Barcode from @DT_Barcode))>0)
	Begin
		Set @isException=1
		Set @exceptionMessage='Barcodes already exist.'
	End 
	else if not exists( select *  from BrandMaster where AutoId=@BrandAutoId and IsDeleted=0)
	Begin
		Set @isException=1
		Set @exceptionMessage='Brand does not exists.'
	End 
	else if not exists( select * from DepartmentMaster where AutoId=@DeptId and IsDeleted=0)
	Begin
		Set @isException=1
		Set @exceptionMessage='Department does not exists.'
	End 
	else if not exists( select * from CategoryMaster where AutoId=@CatgoryAutoId and IsDeleted=0)
	Begin
		Set @isException=1
		Set @exceptionMessage='Category does not exists.'
	End 
	else if not exists( select * from AgeRestrictionMaster where AutoId=@AgeRestrictionId)
	Begin
		Set @isException=1
		Set @exceptionMessage='Age restriction does not exists.'
	End 
	else if not exists( select * from TaxMaster where AutoId=@TaxAutoId)
	Begin
		Set @isException=1
		Set @exceptionMessage='Tax does not exists.'
	End 
	else
	begin
	BEGIN TRY
	BEGIN TRAN
	       
		   declare @row12 int,@i12 int;

		   set @MasterInsertId=(select isnull(Max(MasterInsertId),0)+1 from SKUMaster)

	       Set @ProductId = (SELECT DBO.SequenceCodeGenerator('ProductId'))  
	       insert into ProductMaster([BrandId], [CategoryId], [ProductId],Preferred_VendorId,ImagePath,	ViewImage, [ProductName], Size, Description,[AgeRestrictionId],  [Status], [CreatedBy], [CreatedDate], [UpdatedBy], [updatedDate],DeptId,CreatedByStoreId,IsDeleted,MeasurementUnit,MasterInsertId,ProductShortName)
	       values(@BrandAutoId, @CatgoryAutoId, @ProductId, @VendorId,@Image,1,@ProductName,@ProductSize,@Description,@AgeRestrictionId,  @Status, @Who, GETDATE(), @Who, GETDATE(),@DeptId,@StoreId,0,(select UnitName from measurementUnitMaster where AutoId=@MeasurementUnit),@MasterInsertId,@ProductShortName)
	       set @ProductAutoId=(SELECT SCOPE_IDENTITY())
	       
		  -- if(@GroupId=0)
		  -- begin
				--if exists(select AutoId from GroupMaster where trim(GroupName)=trim(@ProductName))
				--begin
				--     set @GroupId=(select AutoId from GroupMaster where trim(GroupName)=trim(@ProductName))
				--end
				--else
				--begin
		  --           insert into GroupMaster(GroupName, CreatedBy, CreatedDate, CreatedByStoreId, Status, IsDeleted)
				--     values(@ProductName,@Who,GETDATE(),@StoreId,1,0)
				     
				--     set @GroupId=(SELECT SCOPE_IDENTITY())
				--end
		  -- end

		   --insert into [dbo].[ProductGroupMaster](GroupId, ProductId, CreatedBy, CreatedDate, CreatedByStoreId, Status, IsDeleted)
		   --values(@GroupId,@ProductAutoId,@Who,GETDATE(),@StoreId,1,0)

		   insert into ManageStockMaster( ProductId, BatchNo, StockQty, AlertQty, CreatedBy, CreatedDate, CreatedByStoreId, Status, IsDeleted,MasterInsertId)
		   select @ProductAutoId,'',(Case when CP.AutoId=@StoreId then @InStockQty else 0 end),(Case when CP.AutoId=@StoreId then @AlertQty else 0 end),@Who,GETDATE(),@StoreId,@Status,0,@MasterInsertId from CompanyProfile CP 

		   insert into [dbo].[StoreWiseProductList]( StoreId, ProductId,  IsFavourite,  ManageStock,InstockQty ,AlertQty,CreatedBy, CreatedDate, Status1, IsDeleted,CreatedByStoreId,TaxId,WebAvailibilty,MasterInsertId,UpdatedDate,UpdatedBy)
		   select CP.AutoId ,@ProductAutoId,0,(case when CP.AutoId=@StoreId then @ManageStock else 0 end),(case when CP.AutoId=@StoreId then @InStockQty else 0 end),(case when CP.AutoId=@StoreId then @AlertQty else 0 end),@Who,GETDATE(),(case when CP.AutoId=@StoreId then @Status when (CP.AutoId in (select splitdata from dbo.fnSplitString(@StoreIdsString,','))) then @Status else 0 end),0,@StoreId,@TaxAutoId,@WebAvailability,@MasterInsertId,GETDATE(),@Who from CompanyProfile CP
		   
		   select  ROW_NUMBER() over(order by AutoId asc)RowNo, DTVP.*,AutoId as StoreId into #TempStorecnt from CompanyProfile CP,@DT_VendorProductCode DTVP where CP.Status=1
		   
		   insert into VendorProductCodeList(ProductId,StoreId,ProductStoreId,VendorId,VendorProductCode,OtherVPC,CreatedBy,CreatedDate,CreatedByStoreId,Status,MasterInsertId)
		   select @ProductAutoId,t.StoreId, (select max(AutoId) from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=t.StoreId),t.VendorId,t.VendorProductCode ,t.OtherVPC,@Who ,GETDATE(),@StoreId ,1,@MasterInsertId   from #TempStorecnt t
		   
           Select ROW_NUMBER() over (order by PackingName desc) as RowNumber,  DT.*,CP.AutoId as StoreId,(case when CP.AutoId=@StoreId then DT.Status when (CP.AutoId in (select splitdata from dbo.fnSplitString(@StoreIdsString,','))) then DT.Status else 0 end)PackingStatus into #temp_11 from @DT_PakingType DT,CompanyProfile CP
		   where CP.Status=1
		   
	       set @row11=(Select count(1) from #temp_11)
	       set @i11=1
	       
	       while(@row11>=@i11)
	       begin
		         
				 declare @StoreId1 int,@StoreProductId int;
				 set @StoreId1=(select StoreId from #temp_11 where RowNumber=@i11)

				 set @StoreProductId=(select max(AutoId) from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=@StoreId1)
				 
	             insert into [dbo].[ProductUnitDetail]([ProductId], StoreProductId,[PackingName], [Barcode], [CostPrice], [SellingPrice], [TaxAutoId], [ManageStock], [AvailableQty], [AlertQty], [Status],NoOfPieces,SizeOfSinglePiece,IsShowOnWeb,SecondaryUnitPrice,ImageName,StoreId,CreatedByStoreId,IsDeleted,CreatedBy,CreatedDate,MasterInsertId)
	             Select @ProductAutoId,@StoreProductId, [PackingName], [Barcode], [CostPrice], [SellingPrice], @TaxAutoId, [ManageStock], [AvailableQty], [AlertQty], Status,NoOfPieces,PieceSize,WebAvailability,SecondaryUnitPrice,ImageName,StoreId,@StoreId,0,@Who,GETDATE(),@MasterInsertId
	             from #temp_11 where RowNumber=@i11
	             set @AutoId=(SELECT SCOPE_IDENTITY())
	             
	             Set @SKUId = (SELECT DBO.SequenceCodeGenerator('SKU'))  
	             insert into [dbo].[SKUMaster]([SKUId],StoreProductId, [SKUName],PackingName, [Description], [Status], [SKUType], [ProductId], [Favorite], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus],SKUImagePath,StoreId,CreatedByStoreId,MasterInsertId)
	             Select @SKUId,@StoreProductId, @ProductName +'-'+@ProductSize+''+(select UnitName from measurementUnitMaster where AutoId=@MeasurementUnit) , [PackingName], '', Status, '1', @ProductAutoId, 0,  @Who, GETDATE(), @Who, GETDATE(), 0, 0,@Image,StoreId,@StoreId,@MasterInsertId
	             from #temp_11 where RowNumber=@i11
	             
	             set @SKUAutoId=(SELECT SCOPE_IDENTITY())
	             
	             insert into [dbo].[SKUItemMaster]([SKUAutoId], StoreProductId,[ProductId], [ProductUnitAutoId], [Quantity], [UnitPrice], [Discount],CreatedBy,CreatedDate,CreatedByStoreId,	Status,	IsDeleted,MasterInsertId)
	             Select @SKUAutoId,@StoreProductId ,@ProductAutoId, @AutoId, 1, [SellingPrice], 0,@Who,GETDATE(),@StoreId,Status,0,@MasterInsertId
	             from #temp_11 where RowNumber=@i11
	             
	             insert into [dbo].[BarcodeMaster] ([Barcode], StoreProductId,[CreatedDate], [UpdatedDate], [SKUId], [IsDefault],CreatedBy,UpdatedBy,CreatedByStoreId,StoreId,IsDeleted,ProductUnitId,MasterInsertId)
	             Select dt.[Barcode],@StoreProductId , getdate(), getdate(), @SKUAutoId, 1,@Who,0,@StoreId,StoreId,0,@AutoId,@MasterInsertId
	             from #temp_11,@DT_Barcode dt where RowNumber=@i11
	             
	             UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='SKU'
	             
	             set @i11 =@i11+1;
	             
	             UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='ProductId'
	             
	             Select @ProductAutoId as AutoId, @ProductId as ProductId
			END
		
	COMMIT TRANSACTION    
	END TRY
	BEGIN CATCH     
	ROLLBACK TRAN                                                               
	Set @isException=1        
	Set @exceptionMessage=ERROR_MESSAGE()   
	End Catch  
	End
	--END
end
else If @Opcode=12
begin
	If exists (select [PackingName] from [dbo].[ProductUnitDetail] where replace(trim([PackingName]),' ','')= replace(trim(isnull(@Packing,'')),' ','') and [ProductId]=@ProductAutoId and StoreId=@StoreId )
	Begin
		Set @isException=1
		Set @exceptionMessage='Unit already exists.'
	End
	--ELSE if exists(select * from BarcodeMaster where Barcode=@Barcode)
	--begin
	--    Set @isException=1
	--	Set @exceptionMessage='Barcode already exists!'
	--end
	else
	BEGIN
	BEGIN TRY
	BEGIN TRAN
	     select Row_Number() over(order by AutoId asc)RowNumber,AutoId as StoreId into #PackingTemp from CompanyProfile where Status=1
		 Declare @PackingRow int, @i int,@CurrentStoreId int; 
		 set @PackingRow=(Select count(1) from #PackingTemp)
	     set @i=1
		 Set @ImageName=(select isnull(ImagePath,'') from ProductMaster where AutoId=@ProductAutoId)
	    while(@PackingRow>=@i)
	    begin
	          select  @CurrentStoreId=StoreId from #PackingTemp where RowNumber=@i
			  set @MasterInsertId=(select MasterInsertId from ProductMaster where AutoId=@ProductAutoId)
			  select @TaxAutoId=TaxId from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=@CurrentStoreId

			  select distinct Barcode into #TempBarcode from BarcodeMaster where StoreProductId=(select AutoId from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=@CurrentStoreId) and StoreId=@CurrentStoreId

		      insert into [ProductUnitDetail](ProductId, StoreProductId,StoreId,PackingName, Barcode, CostPrice, SellingPrice, TaxAutoId, ManageStock, AvailableQty, AlertQty, NoOfPieces, SizeOfSinglePiece, IsShowOnWeb, SecondaryUnitPrice, ImageName,CreatedBy,CreatedDate,CreatedByStoreId, Status, IsDeleted,MasterInsertId)
		      select @ProductAutoId,(select AutoId from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=@CurrentStoreId),@CurrentStoreId,@Packing, @Barcode, @CostPrice, @UnitPrice, @TaxAutoId, @ManageStock, @InStock, @LowStock, @NoOfPieces, @PieceSize, '', @SecondaryUnitPrice, @ImageName ,@Who,GETDATE(),@StoreId,(Case when @CurrentStoreId=@StoreId then @Status else 0 end),0,@MasterInsertId 
		      
		      set @AutoId=(SELECT SCOPE_IDENTITY())
		      
		      ------------------------------------------------
		      select @ProductName=ProductName, @Description='',@ProductSize=Size from ProductMaster where AutoId=@ProductAutoId
		      
			
		      Set @SKUId = (SELECT DBO.SequenceCodeGenerator('SKU'))  
		      insert into SKUMaster([SKUId], StoreProductId,[ProductId], StoreId, [SKUName], PackingName,[SKUType],[Favorite], [Description],SKUImagePath,[CreatedBy], [CreatedDate],CreatedByStoreId,  [UpdatedBy], [UpdatedDate],APIStatus, [Status], IsDeleted,MasterInsertId)
		      values(@SKUId,(select AutoId from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=@CurrentStoreId),@ProductAutoId ,@CurrentStoreId, @ProductName +'-'+@ProductSize+''+(select MeasurementUnit from ProductMaster where AutoId=@ProductAutoId), @Packing, 1,0,@Description, @ImageName,@Who ,GETDATE(),@StoreId ,@Who,GETDATE(),0,(Case when @CurrentStoreId=@StoreId then @Status else 0 end),0,@MasterInsertId)
		      ---(case when @CurrentStoreId=@StoreId then @Status else 0 end)

		      set @SKUAutoId=(SELECT SCOPE_IDENTITY())
		      UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='SKU'
		      
		      ------------------------------------------------
		     
		      insert into [SKUItemMaster]([SKUAutoId], StoreProductId,[ProductId], [ProductUnitAutoId], [Quantity], [UnitPrice], [Discount],CreatedBy,CreatedDate,CreatedByStoreId,Status,IsDeleted,MasterInsertId)
		      values(@SKUAutoId, (select AutoId from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=@CurrentStoreId),@ProductAutoId, @AutoId, 1, @UnitPrice, 0,@Who,GETDATE(),@StoreId,1,0,@MasterInsertId)
		      
		      ------------------------------------------------
		      
			  insert into BarcodeMaster([SKUId],StoreProductId,StoreId,ProductUnitId,Barcode, [IsDefault],CreatedBy,[CreatedDate],CreatedByStoreId,UpdatedBy, [UpdatedDate], IsDeleted,MasterInsertId )
		      select @SKUAutoId,(select AutoId from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=@CurrentStoreId),@CurrentStoreId,@AutoId,Barcode, 1,@Who , getdate(),@StoreId ,0 ,getdate(), 0,@MasterInsertId from #TempBarcode

			  drop table #TempBarcode

			  set @i =@i+1;
		END
	COMMIT TRANSACTION    
	END TRY                                          
	BEGIN CATCH     
	ROLLBACK TRAN                                                               
	Set @isException=1        
	Set @exceptionMessage=ERROR_MESSAGE()   
	End Catch      
	END
end
else if @Opcode=13
begin
   if exists(select * from VendorProductCodeList where VendorId=@VendorId and VendorProductCode=@VendorProductCode and Status=1 and StoreId=@StoreId)
   begin
       Set @isException=1
	   set @exceptionMessage='Same vendor product code for other product already exists.'
   end
   else
   begin
       insert into VendorProductCodeList(StoreId,ProductId,	ProductStoreId,	VendorId,VendorProductCode,OtherVPC,CreatedBy,CreatedDate,CreatedByStoreId,	Status)
       values(@StoreId,@AutoId,(select AutoId from StoreWiseProductList where StoreId=@StoreId and ProductId=@AutoId),@VendorId,@VendorProductCode,'',@Who,getdate(),@StoreId,1)
   end
end
else if @Opcode=14
begin
   if exists(select top 10 * from BarcodeMaster where Barcode=@Barcode) --and (StoreProductId not in (select AutoId from StoreWiseProductList where ProductId=@ProductAutoId and Status=1)))
	begin
	   SET @isException=1
       SET @exceptionMessage='Barcode already exists.'
	end
	else
	begin
	    Set @MasterInsertId=(select MasterInsertId from ProductMaster where AutoId=@ProductAutoId)

        select @Barcode Barcode,(select ProductUnitAutoId from SKUItemMaster where SKUAutoId= SM.AutoId)ProductUnitAutoId,* into #TempAddBarcode from SKUMaster  SM where ProductId=@ProductAutoId
        
        insert into BarcodeMaster([SKUId],StoreProductId,StoreId,ProductUnitId,Barcode, [IsDefault],CreatedBy,[CreatedDate],CreatedByStoreId, IsDeleted,MasterInsertId )
        select AutoId,StoreProductId,StoreId,ProductUnitAutoId,Barcode,1,@Who,getdate(),@StoreId,0,@MasterInsertId from #TempAddBarcode
    end
end

else if @Opcode=15
begin
   begin try
   begin tran
          if((@UnitPrice!=0 and @UnitPrice is not null) or (@CostPrice!=0 and @CostPrice is not null) or (@SecondaryUnitPrice!=0 and @SecondaryUnitPrice is not null))
		  begin
			   select StoreId,productId,StoreProductId,count(1)PackingCnt 
               into #TempPackingCnt
               from ProductUnitDetail
               where StoreId=@StoreId and StoreProductId in (select AutoId from StoreWiseProductList where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) and StoreId=@StoreId)
               group By StoreId,productId,StoreProductId
			   if((select count(1) from  #TempPackingCnt where PackingCnt>1)>0 and isnull(@VerificationCode,0)=0)
			   begin
			        declare @ProductListString varchar(max)
					--declare @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)

			        select @ProductListString=STRING_AGG(PM.ProductSizeName,', <br/>') 
					from #TempPackingCnt t
					inner join ProductMaster PM on PM.AutoId=t.ProductId
					where PackingCnt>1

					select 0 as ResponseCode,@ProductListString ResponseMessage
			   end
			   else if(@VerificationCode=1 or (select count(1) from  #TempPackingCnt where PackingCnt>1)=0)
			   begin
			       if(isnull(@UnitPrice,0)!=0)
			       begin
			          select AutoId into #TempUnit1 from ProductUnitDetail 
			          where StoreProductId in (select StoreProductId from #TempPackingCnt where PackingCnt=1) --where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) and StoreId=@StoreId) and NoOfPieces=1
			          
			          update ProductUnitDetail set SellingPrice=@UnitPrice 
			          where AutoId in (select AutoId from #TempUnit1)
			       
			          update SIM set  SIM.UnitPrice=@UnitPrice, SIM.Discount=0,DiscountPercentage=0
			          from SKUItemMaster SIM
			          inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId --and SM.ProductId!=0
			          where ProductUnitAutoId in ( select AutoId from #TempUnit1)
					  
					  update SchemeItemMaster set Unitprice=@UnitPrice
					  where PackingAutoId in ( select AutoId from #TempUnit1)
		        
				      update StoreWiseProductList set UpdatedDate=GETDATE() , UpdatedBy=@Who
					  where AutoId in (select StoreProductId from #TempPackingCnt where PackingCnt=1)

			       end
			       if(isnull(@CostPrice,0)!=0)
			       begin
			          select AutoId into #TempCost1 from ProductUnitDetail 
			          where StoreProductId in (select StoreProductId from #TempPackingCnt where PackingCnt=1) --ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) and StoreId=@StoreId) and NoOfPieces=1
			          
			          update ProductUnitDetail set CostPrice=@CostPrice 
			          where AutoId in (select AutoId from #TempCost1)

					  update StoreWiseProductList set UpdatedDate=GETDATE() ,UpdatedBy=@Who
					  where AutoId in (select StoreProductId from #TempPackingCnt where PackingCnt=1)
			       end
			       if(isnull(@SecondaryUnitPrice,0)!=0)
			       begin
			          update ProductUnitDetail set SecondaryUnitPrice=@SecondaryUnitPrice 
			          where StoreProductId in ( select StoreProductId from #TempPackingCnt where PackingCnt=1)---where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) and StoreId=@StoreId) and NoOfPieces=1
			          
					  update StoreWiseProductList set UpdatedDate=GETDATE() ,UpdatedBy=@Who
					  where AutoId in (select StoreProductId from #TempPackingCnt where PackingCnt=1)
				   end
                   if(isnull(@DeptId,0)!=0 and exists(select * from DepartmentMaster where AutoId=isnull(@DeptId,0) and Status=1))
			       begin
			           update ProductMaster set DeptId=@DeptId 
			           where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

					   update StoreWiseProductList set UpdatedDate=GETDATE() ,UpdatedBy=@Who
					   where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) --and StoreId=@StoreId
			       end
			       if(isnull(@CatgoryAutoId,0)!=0 and exists(select * from CategoryMaster where AutoId=isnull(@CatgoryAutoId,0) and Status=1))
			       begin
			           update ProductMaster set CategoryId=@CatgoryAutoId 
			       	   where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

					   update StoreWiseProductList set UpdatedDate=GETDATE() ,UpdatedBy=@Who
					   where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) --and StoreId=@StoreId
			       end
			       
			       if(isnull(@BrandAutoId,0)!=0 and exists(select * from BrandMaster where AutoId=isnull(@BrandAutoId,0) and Status=1))
			       begin
			           update ProductMaster set BrandId=@BrandAutoId 
			       	   where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

					   update StoreWiseProductList set UpdatedDate=GETDATE() ,UpdatedBy=@Who
					   where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) --and StoreId=@StoreId
			       end
			       if(isnull(@AgeRestrictionId,0)!=0 and exists(select * from AgeRestrictionMaster where AutoId=isnull(@AgeRestrictionId,0) and Status=1))
			       begin
			           update ProductMaster set AgeRestrictionId=@AgeRestrictionId 
			       	   where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

					   update StoreWiseProductList set UpdatedDate=GETDATE() ,UpdatedBy=@Who
					   where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) --and StoreId=@StoreId
			       end
			       if(isnull(@ProductSize,'')!='')
			       begin
			           update ProductMaster set Size=@ProductSize 
			       	   where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))
					   
					   update SM set SM.SKUName=PM.ProductName+'-'+PM.Size+PM.MeasurementUnit
					   from SKUMaster SM
					   inner join ProductMaster PM on PM.AutoId=SM.ProductId
					   where SM.ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))

					   update StoreWiseProductList set UpdatedDate=GETDATE(),UpdatedBy=@Who 
					   where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) --and StoreId=@StoreId
			       end 
			       if(isnull(@MeasurementUnitId,0)!=0 and exists(select * from MeasurementUnitMaster where AutoId=isnull(@MeasurementUnitId,0) and Status=1))
			       begin
			           update ProductMaster set MeasurementUnit=(select UnitName from MeasurementUnitMaster where AutoId=@MeasurementUnitId)
			       	   where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

					   update SM set SM.SKUName=PM.ProductName+'-'+PM.Size+PM.MeasurementUnit
			           from SKUMaster SM
			           inner join ProductMaster PM on PM.AutoId=SM.ProductId
			           where SM.ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))

					   update StoreWiseProductList set UpdatedDate=GETDATE() ,UpdatedBy=@Who
					   where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) --and StoreId=@StoreId
			       end
			       if(isnull(@TaxAutoId,0)!=0 and isnull((select count(*) from TaxMaster where AutoId=isnull(@TaxAutoId,0)),0)>0)
			       begin
			          select AutoId into #TempTax1 from ProductUnitDetail 
			          where StoreProductId in (select AutoId from StoreWiseProductList where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) and StoreId=@StoreId) --and NoOfPieces=1
			          
			          update StoreWiseProductList set TaxId=@TaxAutoId ,UpdatedDate=GETDATE(),UpdatedBy=@Who
			          where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) and StoreId=@StoreId
			       
			          update ProductUnitDetail set TaxAutoId=@TaxAutoId 
			          where AutoId in (select AutoId from #TempTax1)
			       end
			       if(isnull(@Status,2)!=2)
			       begin
			          update StoreWiseProductList set Status1=@Status ,UpdatedDate=GETDATE(),UpdatedBy=@Who
			          where ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))  and StoreId=@StoreId

					  update SM set Status=@Status 
					  from SKUMaster SM
					  inner join StoreWiseProductList  SPL on SPL.ProductId=SM.ProductId 
					  where SPL.StoreId=@StoreId and SM.StoreId=@StoreId and SKUCount=1
					  and SM.ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) 

					  update SM set SM.Status=0
                      from SKUItemMaster SIM
                      inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
                      inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
                      where PUD.Status=0 and SM.Status=1 and SM.productId!=0
			       end
				   select 1 as ResponseCode,'Success!' ResponseMessage
			   end
			   else
			   begin
			      select 0 as ResponseCode,'Not Verified' ResponseMessage
			   end
		  end
		  else
		  begin
            if(isnull(@DeptId,0)!=0 and isnull((select count(*) from DepartmentMaster where AutoId=isnull(@DeptId,0) and Status=1),0)>0)
			begin
			    update ProductMaster set DeptId=@DeptId 
				where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

				update StoreWiseProductList set UpdatedDate=GETDATE(),UpdatedBy=@Who
			    where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) --and StoreId=@StoreId
			end
			if(isnull(@CatgoryAutoId,0)!=0 and isnull((select count(*) from CategoryMaster where AutoId=isnull(@CatgoryAutoId,0) and Status=1),0)>0)
			begin
			    update ProductMaster set CategoryId=@CatgoryAutoId 
				where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

				update StoreWiseProductList set UpdatedDate=GETDATE(),UpdatedBy=@Who
			    where ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))
			end

			if(isnull(@BrandAutoId,0)!=0 and isnull((select count(*) from BrandMaster where AutoId=isnull(@BrandAutoId,0) and Status=1),0)>0)
			begin
			    update ProductMaster set BrandId=@BrandAutoId 
				where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

				update StoreWiseProductList set UpdatedDate=GETDATE(),UpdatedBy=@Who
			    where ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))
			end
			if(isnull(@AgeRestrictionId,0)!=0 and exists(select * from AgeRestrictionMaster where AutoId=isnull(@AgeRestrictionId,0) and Status=1))
			begin
			    update ProductMaster set AgeRestrictionId=@AgeRestrictionId 
				where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

				update StoreWiseProductList set UpdatedDate=GETDATE(),UpdatedBy=@Who
			    where ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))
			end
			if(isnull(@ProductSize,'')!='')
			begin
			    update ProductMaster set Size=@ProductSize 
				where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

				update SM set SM.SKUName=PM.ProductName+'-'+PM.Size+PM.MeasurementUnit
			    from SKUMaster SM
			    inner join ProductMaster PM on PM.AutoId=SM.ProductId
			    where SM.ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))

				update StoreWiseProductList set UpdatedDate=GETDATE(),UpdatedBy=@Who
			    where ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))
			end 
			if(isnull(@MeasurementUnitId,0)!=0 and  exists(select * from MeasurementUnitMaster where AutoId=isnull(@MeasurementUnitId,0) and Status=1))
			begin
			    update ProductMaster set MeasurementUnit=(select UnitName from MeasurementUnitMaster where AutoId=@MeasurementUnitId)
				where AutoId in (select splitdata from fnSplitString(@ProductIdsList,','))

				update SM set SM.SKUName=PM.ProductName+'-'+PM.Size+PM.MeasurementUnit
			    from SKUMaster SM
			    inner join ProductMaster PM on PM.AutoId=SM.ProductId
			    where SM.ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))

				update StoreWiseProductList set UpdatedDate=GETDATE(),UpdatedBy=@Who
			    where ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))
			end
			if(isnull(@TaxAutoId,0)!=0 and exists(select * from TaxMaster where AutoId=isnull(@TaxAutoId,0)))
			begin
			   select AutoId into #TempTax from ProductUnitDetail 
			   where StoreProductId in (select AutoId from StoreWiseProductList where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) and StoreId=@StoreId) --and NoOfPieces=1
			   
			   update StoreWiseProductList set TaxId=@TaxAutoId,UpdatedDate=GETDATE() ,UpdatedBy=@Who
			   where ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) and StoreId=@StoreId

			   update ProductUnitDetail set TaxAutoId=@TaxAutoId 
			   where AutoId in (select AutoId from #TempTax)
			end
			if(isnull(@Status,2)!=2)
			begin
			   update StoreWiseProductList set Status1=@Status ,UpdatedDate=GETDATE(),UpdatedBy=@Who
			   where ProductId in (select splitdata from fnSplitString(@ProductIdsList,','))  and StoreId=@StoreId

			   update SM set Status=@Status 
			   from SKUMaster SM
			   inner join StoreWiseProductList  SPL on SPL.ProductId=SM.ProductId 
			   where SPL.StoreId=@StoreId and SM.StoreId=@StoreId --and SKUCount=1
			   and SM.ProductId in (select splitdata from fnSplitString(@ProductIdsList,',')) 

			   update SM set SM.Status=0
               --select *  
               from SKUItemMaster SIM
               inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
               inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
               where PUD.Status=0 and SM.Status=1 and SM.productId!=0
			 end

			 select 1 as ResponseCode,'Success!' ResponseMessage
          end
   commit tran
   end try
   begin catch
      rollback tran
	  set @isException=1
	  set @exceptionMessage=ERROR_MESSAGE()
   end catch
end

else If @Opcode=21
begin
	If exists (select ProductName from ProductMaster where trim(replace(ProductName,' ',''))=replace(trim(@ProductName),' ','') and  trim(Size)=trim(@ProductSize) and MeasurementUnit=(select UnitName from MeasurementUnitMaster where AutoId=@MeasurementUnit) and AutoId!=@AutoId)  
	Begin
		Set @isException=1
		Set @exceptionMessage='Product details already exist.'
	End 
	else if not exists( select *  from BrandMaster where AutoId=@BrandAutoId and IsDeleted=0)
	Begin
		Set @isException=1
		Set @exceptionMessage='Brand does not exists.'
	End 
	else if not exists( select * from DepartmentMaster where AutoId=@DeptId and IsDeleted=0)
	Begin
		Set @isException=1
		Set @exceptionMessage='Department does not exists.'
	End 
	else if not exists( select * from CategoryMaster where AutoId=@CatgoryAutoId and IsDeleted=0)
	Begin
		Set @isException=1
		Set @exceptionMessage='Category does not exists.'
	End 
	else if not exists( select * from AgeRestrictionMaster where AutoId=@AgeRestrictionId)
	Begin
		Set @isException=1
		Set @exceptionMessage='Age restriction does not exists.'
	End 
	else if not exists( select * from TaxMaster where AutoId=@TaxAutoId)
	Begin
		Set @isException=1
		Set @exceptionMessage='Tax does not exists.'
	End 
	ELSE
	BEGIN
	BEGIN TRY
	BEGIN TRAN

		update ProductMaster set [ProductName]=@ProductName, Size=@ProductSize,MeasurementUnit=(select UnitName from MeasurementUnitMaster where AutoId=@MeasurementUnit),[BrandId]=@BrandAutoId, [CategoryId]=@CatgoryAutoId,  [AgeRestrictionId]=@AgeRestrictionId,
		DeptId=@DeptId,Preferred_VendorId=@VendorId,[Description]=@Description,[ViewImage]=1, [UpdatedBy]=@Who, [updatedDate]=GETDATE() , [ImagePath]=@Image, ProductShortName=@ProductShortName --, [Status]=@Status
		where AutoId=@AutoId

		--if(@GroupId=0)
	 --   begin
		--     ---delete from ProductGroupMaster where ProductId=@AutoId
		--	 if exists(select * from GroupMaster where trim(GroupName)=trim(@ProductName))
		--	 begin
		--	      set @GroupId=(select AutoId from GroupMaster where trim(GroupName)=trim(@ProductName))
		--	 end
		--	 else
		--	 begin
	 --            insert into GroupMaster(GroupName, CreatedBy, CreatedDate, CreatedByStoreId, Status, IsDeleted)
	 --		     values(@ProductName,@Who,GETDATE(),@StoreId,1,0)
	 		     
	 --		     set @GroupId=(SELECT SCOPE_IDENTITY())

	 --		     ---update [dbo].[ProductGroupMaster] set GroupId=@GroupId where ProductId=@AutoId
		--	 end
	 --   end
	    --else
	    --begin
	 		 --update [dbo].[ProductGroupMaster] set GroupId=@GroupId where ProductId=@AutoId
	    --end

		--update [dbo].[ProductGroupMaster] set GroupId=@GroupId where ProductId=@AutoId

		update ManageStockMaster set StockQty=@InStockQty,AlertQty=@AlertQty where ProductId=@AutoId
		
		update ProductUnitDetail set TaxAutoId=@TaxAutoId where ProductId=@AutoId

		update StoreWiseProductList set ManageStock=@ManageStock,InstockQty=@InStockQty,AlertQty=@AlertQty, Status1=@Status,UpdatedDate=GETDATE(),UpdatedBy=@Who where ProductId=@AutoId and StoreId=@StoreId
		
		update StoreWiseProductList set TaxId=@TaxAutoId,UpdatedDate=GETDATE(),UpdatedBy=@Who where ProductId=@AutoId --and StoreId=@StoreId

		update sm set [SKUName]=@ProductName+'-'+isnull(@ProductSize,'')+''+isnull((select UnitName from MeasurementUnitMaster where AutoId=@MeasurementUnit),'') ,sm.PackingName=pud.PackingName , [Description]=@Description, [UpdatedBy]=@Who, [UpdatedDate]=GETDATE()
		,sm.SKUImagePath=@Image
		from SKUMaster sm 
		inner join SKUItemMaster sim on sim.SKUAutoId=sm.AutoId
		inner join ProductUnitDetail pud on pud.AutoId=sim.ProductUnitAutoId
		where sm.ProductId=@AutoId and sim.ProductId=@AutoId and sm.SKUType=1
		and sm.ProductId!=0 and sm.StoreId=@StoreId

		update sm set sm.[Status]=pud.Status
		from SKUMaster sm 
		inner join SKUItemMaster sim on sim.SKUAutoId=sm.AutoId
		inner join ProductUnitDetail pud on pud.AutoId=sim.ProductUnitAutoId
		where sm.ProductId=@AutoId and sim.ProductId=@AutoId and sm.SKUType=1
		and sm.StoreId=@StoreId and sm.ProductId!=0

	COMMIT TRANSACTION    
	END TRY                                          
	BEGIN CATCH     
	ROLLBACK TRAN                                                               
	Set @isException=1        
	Set @exceptionMessage=ERROR_MESSAGE()   
	End Catch      
	END
end
else If @Opcode=22
begin
	If exists (select [PackingName] from [dbo].[ProductUnitDetail] where [PackingName]=@Packing and ProductId=@ProductAutoId and AutoId!=@AutoId and StoreId=@StoreId)  
	Begin
		Set @isException=1
		Set @exceptionMessage='Unit already exist.'
	End  
	--ELSE if exists(select * from BarcodeMaster where Barcode=@Barcode and [SKUId]!=(select sm.AutoId
	--	from SKUMaster sm 
	--	inner join SKUItemMaster sim on sim.SKUAutoId=sm.AutoId
	--	where sm.ProductId=@ProductAutoId and sim.ProductId=@ProductAutoId and sim.ProductUnitAutoId=@AutoId and sm.SKUType=1))
	--begin
	--    Set @isException=1
	--	Set @exceptionMessage='Barcode already exists!'
	--end
	else
	BEGIN
	BEGIN TRY
	BEGIN TRAN
	    declare @PackingName varchar(50),@ProductUnitId int=0;
		select @PackingName=PackingName from ProductUnitDetail where AutoId=@AutoId

		select @ProductUnitId=AutoId from [dbo].[ProductUnitDetail] 
		where  ProductId=@ProductAutoId and PackingName=@PackingName and StoreId=@StoreId

		select SIM.AutoId SKUItemId,SM.AutoId SKUId
		into #TempSKUItemIds
		from SKUMaster SM
        inner join SKUItemMaster SIM on SIM.SKUAutoId=SM.AutoId
        where SM.ProductId=0 and StoreId=@StoreId
        and ProductUnitAutoId=@ProductUnitId

		select AutoId as SchemeItemIds 
		into #TempSchemeItemIds 
		from SchemeItemMaster
		where PackingAutoId=@ProductUnitId

		if(((select isnull(COUNT(*),0) from #TempSKUItemIds)>0 or (select isnull(COUNT(*),0) from #TempSchemeItemIds)>0)and @VerificationCode=0)
		begin
		    select 0 as responseCode,'This unit is used in some SKU and Scheme.<br>Their Unit price will be updated and discount will be zero.' as ResponseMessage
		end
		else
		begin
		    update [dbo].[ProductUnitDetail] 
		    set ProductId=@ProductAutoId, [PackingName]=@Packing, [Barcode]=@Barcode, [CostPrice]=@CostPrice, [SellingPrice]=@UnitPrice, [ManageStock]=@ManageStock, [AvailableQty]=@InStock, [AlertQty]=@LowStock
		    ,NoOfPieces=@NoOfPieces,SizeOfSinglePiece=@PieceSize,IsShowOnWeb='',SecondaryUnitPrice=@SecondaryUnitPrice,ImageName=@ImageName, [Status]=@Status
		    where  ProductId=@ProductAutoId and PackingName=@PackingName and StoreId=@StoreId
		    
		    select @ProductName=ProductName, @Description='',@ProductSize=Size,@MeasurementUnit=MeasurementUnit from ProductMaster where AutoId=@ProductAutoId
		    
		    update sim set sim.[UnitPrice]=@UnitPrice, sim.Status=@Status--, case when [Discount]=
		    from SKUMaster sm 
		    inner join SKUItemMaster sim on sim.SKUAutoId=sm.AutoId
		    where sm.ProductId=@ProductAutoId and sim.ProductId=@ProductAutoId  and sm.SKUType=1 --and sim.ProductUnitAutoId=@AutoId
		    and sm.PackingName=@PackingName and sm.StoreId=@StoreId
		    
			update sim set sim.[UnitPrice]=@UnitPrice, Discount=0,DiscountPercentage=0
		    from SKUMaster sm 
		    inner join SKUItemMaster sim on sim.SKUAutoId=sm.AutoId
			where sim.AutoId in (select SKUItemId from #TempSKUItemIds)

			update SchemeItemMaster set Unitprice=@UnitPrice
			where AutoId in (select SchemeItemIds from #TempSchemeItemIds)
			 
		    update sm set  [SKUName]=@ProductName +'-'+@ProductSize+''+@MeasurementUnit, PackingName= @Packing, [Description]=@Description, 
		    [Status]=@Status, [UpdatedBy]=@Who, 
		    [UpdatedDate]=GETDATE(),--SKUImagePath='',--(select ImagePath from ProductMaster where AutoId=@ProductAutoId ),
		    @SKUAutoId=sm.AutoId
		    from SKUMaster sm 
		    inner join SKUItemMaster sim on sim.SKUAutoId=sm.AutoId
		    where sm.ProductId=@ProductAutoId and sim.ProductId=@ProductAutoId and  sm.SKUType=1 --and sim.ProductUnitAutoId=@AutoId 
		    and sm.PackingName=@PackingName and sm.StoreId=@StoreId
		        
		    update StoreWiseProductList set UpdatedDate=GETDATE(),UpdatedBy=@Who where ProductId= @ProductAutoId and StoreId=@StoreId
		    --update [dbo].[BarcodeMaster] set [Barcode]=@Barcode,UpdatedBy=@Who,UpdatedDate=GETDATE() where [SKUId]=@SKUAutoId and [IsDefault]=1
		    --and StoreId=@StoreId

	        select 1 as responseCode,'Product Details updated successfully.' as ResponseMessage
	  
	  end
	COMMIT TRANSACTION    
	END TRY                                          
	BEGIN CATCH     
	ROLLBACK TRAN                                                               
	Set @isException=1        
	Set @exceptionMessage=ERROR_MESSAGE()   
	End Catch      
	END
end
else if @OpCode=23
begin
    update StoreWiseProductList set Status1=@Status,UpdatedDate=GETDATE(),UpdatedBy=@Who where AutoId=@AutoId
end
else if @OpCode=24
begin
if exists(select * from VendorProductCodeList where VendorId=@VendorId and VendorProductCode=@VendorProductCode and AutoId!=@AutoId and Status=1 and StoreId=@StoreId)
begin
    set @isException=1
	set @exceptionMessage='Same vendor product code for other product already exists.'
end
else 
begin
    update VendorProductCodeList set VendorId=@VendorId,VendorProductCode=@VendorProductCode where AutoId=@AutoId
end
end
else if @OpCode=25
begin
   if exists(select * from BarcodeMaster where Barcode=@Barcode and StoreProductId not in (select AutoId from StoreWiseProductList where ProductId=@ProductAutoId))
   begin
       set @isException=1
	   set @exceptionMessage='Barcode already exists.'
   end
   else if exists(select * from BarcodeMaster where Barcode=@Barcode and StoreProductId in (select AutoId from StoreWiseProductList where ProductId=@ProductAutoId) and Barcode!=@BarcodeForEdit)
   begin
       set @isException=1
	   set @exceptionMessage='Barcode already exists.'
   end
   else if exists(select * from BarcodeMaster where Barcode=@Barcode and isnull(ProductUnitId,0)=0 and StoreId=@StoreId)
   begin
       set @isException=1
	   set @exceptionMessage='Barcode already exists.'
   end
   else
   begin
       update BarcodeMaster set Barcode=@Barcode,UpdatedBy=@Who,UpdatedDate=getdate() where Barcode=@BarcodeForEdit and StoreProductId in (select AutoId from StoreWiseProductList where ProductId=@ProductAutoId)  
   end
end
else if @OpCode=32
begin
    delete from VendorProductCodeList where AutoId=@AutoId
end
else if @OpCode=33
begin
    delete from BarcodeMaster where Barcode=@Barcode and StoreProductId in (select AutoId from StoreWiseProductList where ProductId=@ProductAutoId )
end
else IF @Opcode=41
BEGIN
   
	Select ROW_NUMBER() over(order by SPL.updatedDate desc) as RowNumber, SPL.Status,Size as ProductSize,
	pm.AutoId, pm.ProductSizeName ProductName, DM.DepartmentName,bm.BrandName, cm.CategoryName,
	(Select count(1) from [dbo].[ProductUnitDetail] where StoreId=@StoreId and Status=1) as Unit,SPL.updatedDate,
	UDM.FirstName+isnull(' '+UDM.LastName,'')+'<br/>'+format(SPL.updatedDate, 'MM/dd/yyyy hh:mm tt') as CreationDetail,SPL.InstockQty as StockQTY,SPL.AlertQty
	--GM.GroupName,
	into #temp41
	from  ProductMaster pm
	inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and  SPL.StoreId=@StoreId
	inner join BrandMaster bm on bm.AutoId=pm.BrandId
	inner join CategoryMaster cm on cm.AutoId=pm.CategoryId
	--inner join ProductGroupMaster PGM on PGM.ProductId=PM.AutoId
	--left join GroupMaster GM on GM.AutoId=PGM.GroupId
	left join DepartmentMaster DM on DM.AutoId=pm.DeptId
	left join UserDetailMaster UDM on UDM.UserAutoId=SPL.UpdatedBy
	where SPL.IsDeleted=0 --and SPL.Status=1 
	and pm.ProductSizeName not like '%Lottery%'
	and (@ProductName is null or @ProductName='' or pm.ProductName like '%'+@ProductName+'%')
	and (@DeptId is null or @DeptId=0 or pm.DeptId=@DeptId)
	and (@BrandAutoId is null or @BrandAutoId=0 or pm.BrandId=@BrandAutoId)
	and (@CatgoryAutoId is null or @CatgoryAutoId=0 or pm.CategoryId=@CatgoryAutoId)
	and (@Status is null or @Status=2 or SPL.Status=@Status)
	order by  SPL.updatedDate desc

	SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, '#Sort By: Updated date & time desc' as SortByString FROM #temp41      
      
    Select  * from #temp41 t      
    WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex - 1) * @PageSize + 1 AND(((@PageIndex - 1) * @PageSize + 1) + @PageSize) - 1))       
    order by  updatedDate desc   
end
else IF @Opcode=42
BEGIN
	select [AutoId], CategoryName from CategoryMaster where isnull(Status,0)=1 order by isnull(SeqNo,0) desc,CategoryName asc
	
	Select [AutoId], BrandName from BrandMaster where isnull(Status,0)=1  order by isnull(SeqNo,0) desc,BrandName asc
	
    Select [AutoId], TaxName from TaxMaster where isnull(Status,0)=1 order by TaxPer asc
	
	Select [AutoId], AgeRestrictionName from AgeRestrictionMaster where isnull(Status,0)=1 order by isnull(SeqNo,0) desc,[Age] asc
	
	select AutoId,DepartmentName from DepartmentMaster where status=1 and IsDeleted=0 order by isnull(SeqNo,0) desc,DepartmentName asc

	select AutoId,VendorName+ISNULL((case when VendorCode!= '' then ' ('+VendorCode+')' else '' end),'') VendorName 
	from vendorMaster where Status=1 and VendorName !='No Vendor'
	order by isnull(SeqNo,0) desc,VendorName asc
	
	select AutoId, GroupName from GroupMaster where Status=1 order by AutoId desc
	
	select AutoId,UnitName from MeasurementUnitMaster where Status=1 order by Seq asc

END
else IF @Opcode=43
BEGIN
     select AutoId,DepartmentName from DepartmentMaster DM where status=1 and IsDeleted=0  or DM.AutoId=(select DeptId from ProductMaster where AutoId=@AutoId) order by isnull(SeqNo,0) desc,AutoId desc  --0
	--select [AutoId], CategoryName from CategoryMaster where isnull(Status,0)=1 order by CategoryName
	 select AutoId,CategoryName from CategoryMaster cm where isnull(Status,0)=1 or cm.AutoId=(select CategoryId from ProductMaster where AutoId=@AutoId) order by isnull(SeqNo,0) desc,CategoryName Asc --1
	--Select [AutoId], BrandName from BrandMaster where isnull(Status,0)=1 order by BrandName
	 select AutoId,BrandName from BrandMaster bm where isnull(Status,0)=1 or bm.AutoId=(select BrandId from ProductMaster where AutoId=@AutoId) order by isnull(SeqNo,0) desc,BrandName Asc --2

	 --Select [AutoId], TaxName from TaxMaster  order by TaxPer asc --3
		select AutoId,TaxName from TaxMaster tm where isnull(Status,0)=1 or tm.AutoId=(select TaxAutoId from ProductUnitDetail where AutoId=@AutoId)
		--select AutoId,AgeRestrictionName from AgeRestrictionMaster bm where isnull(Status,0)=1 or bm.AutoId=(select AgeRestrictionId from ProductMaster where AutoId=@AutoId)

	 Select [AutoId], AgeRestrictionName from AgeRestrictionMaster where isnull(Status,0)=1 order by isnull(SeqNo,0) desc, [Age] asc --4

	 Select PM.*,Preferred_VendorId VendorId,(select Status from StoreWiseProductList where ProductId=PM.AutoId and StoreId=@StoreId)ProductStatus,
	 (select GroupId from ProductGroupMaster where ProductId=PM.AutoId)GroupId,SPL.TaxId,SPL.WebAvailibilty,
	 SPL.ManageStock as ManageStock,SPL.InstockQty as InstockQty, SPL.AlertQty as AlertQty
	 from [dbo].[ProductMaster] PM
	 inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and SPL.StoreId=@StoreId
	 where PM.AutoId=@AutoId  --5

	 Select *, (select [TaxName] from TaxMaster where AutoId=[TaxAutoId]) as TaxName,
	 (select TaxPer from TaxMaster where AutoId=[TaxAutoId]) as TaxPer 
	 from [dbo].[ProductUnitDetail] 
	 where ProductId=@AutoId and StoreId=@StoreId
	 order by PackingName --6

	 declare @VendorAutoIdId int=0;

	 select @VendorAutoIdId=VM.AutoId 
	 from VendorProductCodeList VPC
	 inner join vendorMaster VM on VM.AutoId=VPC.VendorId
	 where ProductId=@AutoId and StoreId=@StoreId order by VPC.AutoId desc

	 select AutoId,VendorName+ISNULL((case when VendorCode!= '' then ' ('+VendorCode+')' else '' end),'') VendorName 
	 from vendorMaster where (AutoId=@VendorAutoIdId or Status=1)
	 and VendorName !='No Vendor'
	 order by VendorName Asc --7
	 
	 select AutoId,GroupName from GroupMaster where Status=1 order by AutoId desc --8
	
	 select VPC.*,VendorName+ISNULL((case when VendorCode!= '' then ' ('+VendorCode+')' else '' end),'')VendorName 
	 from VendorProductCodeList VPC
	 inner join vendorMaster VM on VM.AutoId=VPC.VendorId
	 where ProductId=@AutoId and StoreId=@StoreId order by AutoId desc --9

	 --select AutoId,VendorName+ISNULL((case when VendorCode!= '' then ' ('+VendorCode+')' else '' end),'') VendorName 
	 --from vendorMaster where Status=1 and VendorName !='No Vendor'
	 --order by VendorName Asc --10

	 select SPL.AutoId,StoreId,CompanyName as StoreName,SPL.Status from StoreWiseProductList SPL
	 inner join CompanyProfile CPM on CPM.AutoId=SPL.StoreId
	 where ProductId=@AutoId 
	 and StoreId in (select CompanyId from EmployeeStoreList where EmployeeId=@who and Status=1) order by StoreName --10

	 select AutoId,UnitName from MeasurementUnitMaster where Status=1 order by Seq asc --11

	 select distinct Barcode from BarcodeMaster where StoreProductId=(select AutoId from StoreWiseProductList where ProductId=@AutoId and StoreId=@StoreId)
	 and StoreId=@StoreId  --12
end
else IF @Opcode=44
BEGIN
	Select *, (select [TaxName] from TaxMaster where AutoId=[TaxAutoId]) as TaxName from [dbo].[ProductUnitDetail] 
	where AutoId=@AutoId and StoreId=@StoreId
end
else IF @Opcode=45
BEGIN
	if exists(select top 10 * from BarcodeMaster BM
    inner join StoreWiseProductList SWP on SWP.AutoId=BM.StoreProductId
    where (@ProductAutoId=0 and Barcode=@Barcode)
    or (SWP.ProductId!=@ProductAutoId and Barcode=@Barcode))
	begin
	   SET @isException=1
       SET @exceptionMessage='Barcode already exists.'
	end
	else
	begin
	    SET @isException=0
        SET @exceptionMessage='Success'
	end
end
else IF @Opcode=46
BEGIN
	select AutoId,CompanyName from CompanyProfile 
	where Status=1 and AutoId in (select CompanyId from EmployeeStoreList where EmployeeId=@Who and Status=1)  order by CompanyName

	select @StoreId StoreId
end
else IF @Opcode=47
BEGIN
	select AgeRestrictionId from DepartmentMaster where AutoId=@DeptId
end
else IF @Opcode=48
BEGIN
	if exists(select * from VendorProductCodeList where VendorId=@VendorId and VendorProductCode=@VendorProductCode and StoreId=@StoreId and Status=1)
	begin
	    select 0 as SuccessCode, 'Same vendor product code for other product already exists.' SuccessMessage
	end
	else
	begin
	     select 1 as SuccessCode, 'Success!' SuccessMessage
	end
end
END TRY
BEGIN CATCH
SET @isException=1
SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
End
