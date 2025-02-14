Create or Alter PROCEDURE [dbo].[ProcSKUMaster]
@Opcode int= null,
@SKUAutoId int=null,
@AutoId int=null,							 
@Who int=null,
@StoreId int=null,
@ProductAutoId int=null,
@PackingAutoId int=null,
@SKUId varchar(25)=null,
@PackingName varchar(200)=null,
@Image  varchar(500)=null,
@ProductSearchString varchar(50)=null,
@SellingPrice decimal(18,3)=null,
@Barcode varchar(50)=null,
@SKUName varchar(200)=null,
@VerificationCode int=null,
@SKUProductDeletedIds varchar(max)=null,
@SKUBarcodeDeletedIds varchar(max)=null,
@ProductName varchar(200)=null,
@Description nvarchar(500)=null,
@TaxId int=null,
@Status int=null,
@MasterInsertId int=null,
@Discount decimal(10,2)=null,
@DT_SKUProduct DT_SKUProduct readonly,
@DT_Barcode DT_Barcode readonly,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
BEGIN
BEGIN TRY
        Set @isException=0                                                                                                   
		Set @exceptionMessage='Success'
If @Opcode=11
BEGIN
	BEGIN TRY
	BEGIN TRAN  
	 
	 if EXISTS(Select SKUName from SKUMaster where replace(SKUName,' ','')=replace(@SKUName,' ','') and StoreId=@StoreId)
	 begin
	    Set @isException=1                                                                                                   
		Set @exceptionMessage='SKU name already exists.'   
	 end
	 else if((select count(*) from BarcodeMaster where StoreId=@StoreId and  Barcode in (select trim(isnull(barcode,'')) from @DT_Barcode) )>0)
	 begin
	    Set @isException=1                                                                                                   
		Set @exceptionMessage='Barcode already exists.'       
	 end
	 else
	 begin	
		  
		  declare @StoreCount int=0,@i int=1, @StoreWiseStatus int;

		  set @MasterInsertId=(select isnull(Max(MasterInsertId),0)+1 from SKUMaster)

		  ---select ROW_NUMBER() over(order by AutoId asc)RowNo, AutoId as StoreId into #TempStoreList  from CompanyProfile where Status=1
		  
		  --select @StoreCount=count(1) from  #TempStoreList

		  Select ROW_NUMBER() over (order by  PackingId) as RowNumber,  * into #tempSKUProduct from @DT_SKUProduct
		  Select ROW_NUMBER() over (order by Barcode desc) as RowNumber,  * into #tempBarcode from @DT_Barcode

		  --while(@i<=@StoreCount)
		  --begin
		       Set @SKUId = (SELECT DBO.SequenceCodeGenerator('SKU'))  
		       --set @StoreWiseStatus=(select (Case when StoreId=@StoreId then @Status else 0 end ) from #TempStoreList where RowNo=@i)
	           insert into [dbo].[SKUMaster]([SKUId],StoreProductId,[ProductId],StoreId, [SKUName], PackingName,[SKUType], [Favorite],[Description],SKUImagePath, [Status], [CreatedBy], [CreatedDate], CreatedByStoreId,  [UpdatedBy], [UpdatedDate],[APIStatus], [IsDeleted],MasterInsertId )
	           Select @SKUId,0, 0,@StoreId,@SKUName, '','1', 0,@Description,@Image, @Status,  @Who, GETDATE(), @StoreId,@Who, GETDATE(), 0, 0,@MasterInsertId --from #TempStoreList where RowNo=@i
	           
	           set @SKUAutoId=(SELECT SCOPE_IDENTITY())
		       
	           insert into [dbo].[SKUItemMaster]([SKUAutoId], StoreProductId,[ProductId], [ProductUnitAutoId], [Quantity], [UnitPrice], [Discount],CreatedBy,CreatedDate,CreatedByStoreId,Status,IsDeleted,DiscountPercentage,MasterInsertId)
	           Select @SKUAutoId,(select AutoId from StoreWiseProductList where ProductId=t.ProductId and StoreId=@StoreId), ProductId, PackingId, Quantity, UnitPrice, Discount,@Who,GETDATE(),@StoreId,1,0,DiscountPer,@MasterInsertId
	           from #tempSKUProduct t
	           
	           insert into [dbo].[BarcodeMaster] ( [SKUId],StoreId,ProductUnitId,[Barcode], [CreatedDate], [UpdatedDate],[IsDefault],CreatedBy,UpdatedBy,CreatedByStoreId,IsDeleted,MasterInsertId)
	           --Select  @SKUAutoId,(select StoreId from #TempStoreList where RowNo=@i),0,Barcode, getdate(), getdate(),0,@Who,@Who,@StoreId,0,@MasterInsertId
	           Select  @SKUAutoId,@StoreId,0,Barcode, getdate(), getdate(),0,@Who,@Who,@StoreId,0,@MasterInsertId
			   from #tempBarcode
	           
	           UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='SKU'

		  --     set @i=@i+1;
		  --end

     end
    COMMIT TRANSACTION    
	END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                             
		Set @exceptionMessage=ERROR_MESSAGE()                                                                     
	End Catch  
END
If @Opcode=12
BEGIN
	BEGIN TRY
	BEGIN TRAN 
	
	
		 select PM.AutoId as [A], ProductSizeName as [P]
		  from ProductMaster PM
		  inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		  where   SPL.StoreId=@StoreId and PM.IsDeleted=0 and SPL.IsDeleted=0 and ProductName  not like '%Lottery%' and  SPL.SKUCount>0
		  and PM.AutoId in (select ProductId from ProductUnitDetail where StoreId=@StoreId and IsDeleted=0) and SPL.Status=1 
		 -- and PM.ProductSizeName like '%'+@ProductSearchString+'%'
		  order by [P] Asc for json path, INCLUDE_NULL_VALUES 
		                                         
		


	  --    select top 1000 PM.AutoId, ProductSizeName as ProductName
		 -- from ProductMaster PM
		 -- inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		 -- where   SPL.StoreId=@StoreId and PM.IsDeleted=0 and SPL.IsDeleted=0 and ProductName  not like '%Lottery%' and  SPL.SKUCount>0
		 -- and PM.AutoId in (select ProductId from ProductUnitDetail where StoreId=@StoreId and IsDeleted=0) and SPL.Status=1 
		 ---- and PM.ProductSizeName like '%'+@ProductSearchString+'%'
		 -- order by PM.updatedDate desc
    COMMIT TRANSACTION    
	END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                     
	End Catch  
END
If @Opcode=13
BEGIN
	BEGIN TRY
	BEGIN TRAN  

	     if(@SKUAutoId=0)
		 begin
	         select PD.AutoId, ProductId,  ISNULL(convert(varchar(50),NoOfPieces)+ (case when NoOfPieces>1 then ' Pieces' else ' Piece' end),'')PackingName,CostPrice,
		     SellingPrice, TaxAutoId, TX.TaxPer
		     from ProductUnitDetail PD
		     inner join TaxMaster TX on PD.TaxAutoId=TX.AutoId 
		     where ProductId=@ProductAutoId and IsDeleted=0 and PD.StoreId=@StoreId and PD.Status=1
		 end
		 else 
		 begin
		     select PD.AutoId, ProductId,  ISNULL(convert(varchar(50),NoOfPieces)+ (case when NoOfPieces>1 then ' Pieces' else ' Piece' end),'')PackingName,CostPrice,
		     SellingPrice, TaxAutoId, TX.TaxPer
		     from ProductUnitDetail PD
		     inner join TaxMaster TX on PD.TaxAutoId=TX.AutoId 
		     where ProductId=@ProductAutoId and IsDeleted=0 and PD.StoreId=@StoreId and PD.Status=1

			 union 

			 select PD.AutoId, ProductId,  ISNULL(convert(varchar(50),NoOfPieces)+ (case when NoOfPieces>1 then ' Pieces' else ' Piece' end),'')PackingName,CostPrice,
		     SellingPrice, TaxAutoId, TX.TaxPer
		     from ProductUnitDetail PD
		     inner join TaxMaster TX on PD.TaxAutoId=TX.AutoId
		     where ProductId=@ProductAutoId and IsDeleted=0 and PD.StoreId=@StoreId --and PD.Status=1
			 and PD.AutoId in (select ProductUnitAutoId from SKUItemMaster where SKUAutoId=@SKUAutoId)
		 end
    COMMIT TRANSACTION    
	END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                     
	End Catch  
END
If @Opcode=14
BEGIN
	BEGIN TRY
	BEGIN TRAN  
	      select ROW_NUMBER() over(order by SM.AutoId desc) RowNumber, SM.AutoId, SM.SKUId, SKUName, Description, SM.Status, --BM.Barcode ,
		  Favorite,
		  isnull(UM1.FirstName,'')+' '+isnull(UM1.LastName,'')+'<br/>'+format(SM.UpdatedDate , 'MM/dd/yyyy hh:mm tt') as UpdationDetails,SM.UpdatedDate,
		  ISNULL(UM.FirstName,'')+' '+isnull(UM.LastName,'')+'<br/>'+format(SM.CreatedDate , 'MM/dd/yyyy hh:mm tt')as CreationDetails, SM.CreatedDate,
		  SKUUnitTotal, SKUTotalTax, SKUTotal, [SKUDiscountTotal] as TotalDiscount, [SKUSubTotal]
		  ,(SELECT STRING_AGG(Barcode, ',<br/>') AS Barcode FROM BarcodeMaster BM WHERE BM.SKUId=SM.AutoId)as Barcode
		  into #TempSKUList
		  from SKUMaster SM
		  --inner join BarcodeMaster BM on BM.SKUId=SM.AutoId
		  left join UserDetailMaster UM on SM.CreatedBy=UM.UserAutoId
		  left join UserDetailMaster UM1 on SM.UpdatedBy=UM1.UserAutoId
		  where  ProductId=0  and StoreId=@StoreId and IsDeleted=0 --and SM.Status=1 
          --and (@SKUAutoId is null or @SKUAutoId='' or SM.AutoId=@SKUAutoId)
		  and (@SKUName is null or @SKUName='' or SM.SKUName like '%'+@SKUName+'%')
		  and (@Barcode is null or @Barcode='' or @Barcode=(select Barcode from BarcodeMaster BM where bm.Barcode=@Barcode and bm.SKUId=sm.AutoId))
          and (@Status is null or @Status=0 or (@Status=1 and SM.Status=1) or (@Status=2 and SM.Status=0))    
		  --group by SM.AutoId
          order by CreatedDate,UpdatedDate Desc       
            
          SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Date desc' as SortByString FROM #TempSKUList      
             
          Select  * from #TempSKUList t      
          WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
          order by UpdatedDate Desc
    COMMIT TRANSACTION    
	END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                     
	End Catch  
END
If @Opcode=15
BEGIN
	BEGIN TRY
	BEGIN TRAN  
	      select AutoId, SKUId, SKUName from SKUMaster where Status=1 and ProductId=0
    COMMIT TRANSACTION    
	END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                     
	End Catch  
END
If @Opcode=16
BEGIN
	BEGIN TRY
	BEGIN TRAN 
	      
		  select * into #TempProductList from (
		      select PM.AutoId A, ProductSizeName as --ProductName
			  B,PM.updatedDate
		      from ProductMaster PM
		      inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId 
		      where  PM.AutoId in (select distinct ProductId from SKUItemMaster where SKUAutoId=@SKUAutoId) 
		      
		      UNION
		      
		      select PM.AutoId A, ProductSizeName as B --ProductName
			  ,PM.updatedDate
		      from ProductMaster PM
		      inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		      where SPL.StoreId=@StoreId and PM.IsDeleted=0 and SPL.IsDeleted=0 and PM.ProductName not like '%Lottery%'
			  and PM.AutoId not in (select distinct ProductId from SKUItemMaster where SKUAutoId=@SKUAutoId) 
              and PM.AutoId in (select ProductId from ProductUnitDetail where StoreId=@StoreId and IsDeleted=0) and  SPL.Status=1
		  ) t

		  select (isnull((
	      Select [AutoId],[SKUId], [SKUName], [Description], [Status], [SKUType], [ProductId], [Favorite], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus],SKUImagePath 
		  from [dbo].[SKUMaster]
	      where AutoId=@SKUAutoId and StoreId=@StoreId 
		  for json path,include_null_values),'')
		  ) SKUDetails,
		  (isnull((
	      Select SIM.[AutoId], SIM.[ProductId], PM.ProductSizeName as ProductName,
		  ISNULL(convert(varchar(50),PUD.NoOfPieces)+ (case when PUD.NoOfPieces>1 then ' Pieces' else ' Piece' end),'')PackingName,
		  (select AutoId from ProductUnitDetail where ProductId=SIM.[ProductId] and StoreId=@StoreId and NoOfPieces=PUD.NoOfPieces) as [ProductUnitAutoId], 
		  [Quantity], SIM.[UnitPrice], [Discount] ,DiscountPercentage,
		  SIM.Tax,SIM.TaxPer as TaxPercentagePerUnit,PUD.AutoId as TaxAutoId, SIM.SKUItemTotal
		  from [dbo].[SKUItemMaster] SIM
		  inner join ProductMaster PM on Pm.AutoId=SIM.ProductId
		  inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		  inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
	      where SKUAutoId=@SKUAutoId and SPL.StoreId=@StoreId and SIM.IsDeleted=0 
		  for json path,include_null_values),'')
		  ) SKUProductList,
		  (isnull((
	      Select AutoId,[Barcode], [CreatedDate], [UpdatedDate], [SKUId],[IsDefault]
		  from [dbo].[BarcodeMaster]
	      where SKUId=@SKUAutoId and StoreId=@StoreId and IsDeleted=0
		  for json path,include_null_values),'')
		  ) SKUBarcodeList,
		  (isnull((
		  select * from #TempProductList
		  order by B Asc
		  for json path,include_null_values),'[]')
		  ) PL,
		  (isnull((
		  select CurrencySymbol A from CompanyProfile CP
	      inner join CurrencySymbolMaster CM on CM .AutoId=CP.CurrencyId
	      where Cp.AutoId=@StoreId
		  for json path,include_null_values),'[]')
		  ) CurrencySymbol
		  for json path,include_null_values

    COMMIT TRANSACTION    
	END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                     
	End Catch  
END
If @Opcode=17
BEGIN
    BEGIN TRY
    BEGIN TRAN 
    --declare @MasterInsertId int;
     ---set @MasterInsertId= (Select MasterInsertId from SKUMaster where AutoId=@SKUAutoId)
     if EXISTS(Select SKUName from SKUMaster where replace(SKUName,' ','')=replace(@SKUName,' ','') and AutoId!=@SKUAutoId and StoreId=@StoreId)
     begin
        Set @isException=1                                                                                                   
        Set @exceptionMessage='SKU name already exists.'   
     end
     else if ( (select count(*) from BarcodeMaster where SKUId!=@SKUAutoId and StoreId=@StoreId and Barcode in (select trim(isnull(barcode,'')) from @DT_Barcode where ActionId in (1,2)))>0)
     begin
        Set @isException=1                                                                                                   
        Set @exceptionMessage='Barcode already exists.'   
     end
     else
     begin

	      set @MasterInsertId=(select MasterInsertId from SKUMaster where AutoId=@SKUAutoId)
		  declare @Validate int=0
		  if exists(select * from SchemeMaster where SKUAutoId=@SKUAutoId)
		  begin

			  if((select isnull(count(splitdata),0) from fnSplitString(@SKUProductDeletedIds,','))>0 and isnull(@VerificationCode,0)=0)
			  begin
			     set @Validate=1
				 select 0 ResponseCode, 'This SKU is used in Some Scheme.Changes will be updated in scheme also.' ResponseMessage
			  end
			  else if((select isnull(count(*),0) from @DT_SKUProduct t inner join SKUItemMaster SIM on  SIM.ProductUnitAutoId=t.PackingId inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId  where SM.AutoId=@SKUAutoId and StoreId=@StoreId and isnull(SIM.UnitPrice,0)!=isnull(t.UnitPrice,0) and ActionId=2)>0 and isnull(@VerificationCode,0)=0)
			  begin
			     set @Validate=1
				 select 0 ResponseCode, 'This SKU is used in Some Scheme.Changes will be updated in scheme also.' ResponseMessage
			  end
			  else if((select isnull(count(*),0) from @DT_SKUProduct where ActionId=1)>0 and isnull(@VerificationCode,0)=0)
			  begin
			     set @Validate=1
				 select 0 ResponseCode, 'This SKU is used in Some Scheme.Changes will be updated in scheme also.' ResponseMessage
			  end
			  if(@VerificationCode=1)
			  begin
					Update [dbo].[SKUMaster] set [SKUName]=@SKUName, [Description]=@Description, [Status]=@Status,
					[UpdatedBy]=@Who, [UpdatedDate]=GETDATE(),SKUImagePath=@Image
					where AutoId=@SKUAutoId --and StoreId=@StoreId
		  
					Select ROW_NUMBER() over (order by  PackingId) as RowNumber,  * into #tempSKUProduct1 from @DT_SKUProduct

					--Update SKUItemMaster set Status=0 , IsDeleted=1 where AutoId in (select splitdata from fnSplitString(@SKUProductDeletedIds,',')) --Action id 0 is for delete
					--delete from SKUItemMaster where AutoId in (select splitdata from fnSplitString(@SKUProductDeletedIds,','))

					delete from SKUItemMaster where SKUAutoId=@SKUAutoId -- in (select splitdata from fnSplitString(@SKUProductDeletedIds,','))
					--Update the SKU items 

					--update sim set sim.ProductId=t.ProductId, SIM.ProductUnitAutoId=t.PackingId, sim.Quantity=t.Quantity,
					--sim.UnitPrice=t.UnitPrice, sim.Discount=t.Discount,sim.DiscountPercentage=t.DiscountPer
					--from SKUItemMaster SIM 
					--inner join #tempSKUProduct1 t on SIM.AutoId=t.SKUItemAutoId and SIM.SKUAutoId=@SKUAutoId and t.ActionId=2

					--insert the New SKU items
					insert into [dbo].[SKUItemMaster]([SKUAutoId],StoreProductId, [ProductId], [ProductUnitAutoId], [Quantity], [UnitPrice], [Discount],CreatedBy,CreatedDate,CreatedByStoreId,Status,IsDeleted,DiscountPercentage,MasterInsertId)
					Select @SKUAutoId, (select AutoId from StoreWiseProductList where ProductId=t.ProductId and StoreId=@StoreId),ProductId, PackingId, Quantity, UnitPrice, Discount,@Who,GETDATE(),@StoreId,1,0,DiscountPer,@MasterInsertId
					from #tempSKUProduct1  t--where ActionId=1
          
					Select ROW_NUMBER() over (order by Barcode desc) as RowNumber,  * into #tempBarcode1 from @DT_Barcode

					delete from BarcodeMaster where AutoId in (select splitdata from fnSplitString(@SKUBarcodeDeletedIds,','))

					--Update the existing Barcode
					update BM set BM.Barcode=t.Barcode
					from BarcodeMaster BM 
					inner join #tempBarcode1 t on BM.AutoId=t.BarcodeAutoId and BM.SKUId=@SKUAutoId and t.ActionId=2 -- Action id 2 is for update

					--Insert New Barcodes
					insert into [dbo].[BarcodeMaster] (StoreId,[Barcode], [CreatedDate], [UpdatedDate], [SKUId],[IsDefault],CreatedBy,UpdatedBy,CreatedByStoreId,IsDeleted,MasterInsertId)
					Select @StoreId,Barcode, getdate(), getdate(), @SKUAutoId,0,@Who,@Who,@StoreId,0,@MasterInsertId
					from #tempBarcode1 where ActionId=1 -- Action id 1 is for insert

					delete from SchemeItemMaster where SchemeAutoId in (select AutoId from SchemeMaster where SKUAutoId=@SKUAutoId and StoreId=@StoreId)
			        
			        insert into SchemeItemMaster(SchemeAutoId,ProductAutoId,PackingAutoId,Quantity,UnitPrice)
					select SCM.AutoId, SIM.ProductId,SIM.ProductUnitAutoId,SIM.Quantity,SIM.PriceAfterDis
					from SKUItemMaster SIM
					inner join SchemeMaster SCM on SCM.SKUAutoId=SIM.SKUAutoId
					where SCM.SKUAutoId=@SKUAutoId and StoreId=@StoreId

					select 1 ResponseCode, 'SKU updated successfully.' ResponseMessage

			  end
			end
		  if(@VerificationCode=0 and @Validate=0)
		  begin
		        Update [dbo].[SKUMaster] set [SKUName]=@SKUName, [Description]=@Description, [Status]=@Status,
				[UpdatedBy]=@Who, [UpdatedDate]=GETDATE(),SKUImagePath=@Image
				where AutoId=@SKUAutoId --and StoreId=@StoreId
		  
				Select ROW_NUMBER() over (order by  PackingId) as RowNumber,  * into #tempSKUProduct11 from @DT_SKUProduct

				--Update SKUItemMaster set Status=0 , IsDeleted=1 where AutoId in (select splitdata from fnSplitString(@SKUProductDeletedIds,',')) --Action id 0 is for delete
				--delete from SKUItemMaster where AutoId in (select splitdata from fnSplitString(@SKUProductDeletedIds,','))

				delete from SKUItemMaster where SKUAutoId=@SKUAutoId
				--Update the SKU items 
				--update sim set sim.ProductId=t.ProductId, SIM.ProductUnitAutoId=t.PackingId, sim.Quantity=t.Quantity,
				--sim.UnitPrice=t.UnitPrice, sim.Discount=t.Discount,sim.DiscountPercentage=t.DiscountPer
				--from SKUItemMaster SIM 
				--inner join #tempSKUProduct11 t on SIM.AutoId=t.SKUItemAutoId and SIM.SKUAutoId=@SKUAutoId and t.ActionId=2

				--insert the New SKU items
				insert into [dbo].[SKUItemMaster]([SKUAutoId],StoreProductId, [ProductId], [ProductUnitAutoId], [Quantity], [UnitPrice], [Discount],CreatedBy,CreatedDate,CreatedByStoreId,Status,IsDeleted,DiscountPercentage,MasterInsertId)
				Select @SKUAutoId,(select AutoId from StoreWiseProductList where ProductId=t.ProductId and StoreId=@StoreId), ProductId, PackingId, Quantity, UnitPrice, Discount,@Who,GETDATE(),@StoreId,1,0,DiscountPer,@MasterInsertId
				from #tempSKUProduct11 t --where ActionId=1
          
				Select ROW_NUMBER() over (order by Barcode desc) as RowNumber,  * into #tempBarcode11 from @DT_Barcode

				delete from BarcodeMaster where AutoId in (select splitdata from fnSplitString(@SKUBarcodeDeletedIds,','))

				--Update the existing Barcode
				update BM set BM.Barcode=t.Barcode
				from BarcodeMaster BM 
				inner join #tempBarcode11 t on BM.AutoId=t.BarcodeAutoId and BM.SKUId=@SKUAutoId and t.ActionId=2 -- Action id 2 is for update

				--Insert New Barcodes
				insert into [dbo].[BarcodeMaster] (StoreId,[Barcode], [CreatedDate], [UpdatedDate], [SKUId],[IsDefault],CreatedBy,UpdatedBy,CreatedByStoreId,IsDeleted,MasterInsertId)
				Select @StoreId,Barcode, getdate(), getdate(), @SKUAutoId,0,@Who,@Who,@StoreId,0,@MasterInsertId
				from #tempBarcode11 where ActionId=1 -- Action id 1 is for insert

				select 1 ResponseCode, 'SKU updated successfully.' ResponseMessage
		 end
	
	end
    COMMIT TRANSACTION    
    END TRY                                                                                                                                      
    BEGIN CATCH                                                                                                                                
        ROLLBACK TRAN                                                                                                                         
        Set @isException=1                                                                                                   
        Set @exceptionMessage=ERROR_MESSAGE()                                                                     
    End Catch  
END
If @Opcode=41
BEGIN
	select AutoId,Barcode from BarcodeMaster where SKUId=@SKUAutoId and StoreId=@StoreId

	select SKUName from SKUMaster where AutoId=@SKUAutoId
END
If @Opcode=44
BEGIN
     set @SKUName= (Select SKUName from SKUMaster where AutoId=@SKUAutoId)
	 if exists(select * from BarcodeMaster where Barcode=@Barcode and StoreId=@StoreId and (@SKUAutoId is null or @SKUAutoId=0 or (SKUId not in (select AutoId from SKUMaster where SKUName=@SKUName and StoreId=@StoreId))))
	 begin
	    set @isException=1
		set @exceptionMessage='Barcode already exists.'
	 end
	 else
	 begin
	    set @isException=0
		set @exceptionMessage='Success'
	 end
END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
END
GO
