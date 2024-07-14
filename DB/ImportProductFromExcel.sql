declare 
@TotalProductCount int=0,
@CurrentProductRow int=1,
@AutoId int=null,
@VendorId int=null,
@DeptId int=null,
@DepartmentId varchar(10)=null,
@ProductAutoId  int=null,
@ProductId varchar(50)=null,
@BrandAutoId int=null,
@StoreId int=1,
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
@CategoryId varchar(20)=null,
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
@StoreIdsString varchar(500)=null,
@SKUAutoId int=null,
@MasterInsertId int=null,
@SKUId varchar(50)=null,
@Status int=null,
@ErrorMessage varchar(max),
@Who int=1


    --select * from  POSProductExcel
    if ((select COUNT(1) from AgeRestrictionMaster where isnull(Age,-1)=18)=0)
	begin
	  insert into AgeRestrictionMaster(	AgeRestrictionName,	Age,Status,SeqNo)
	  values('18+',18,1,1)
	end

	if ((select COUNT(1) from TaxMaster where isnull(TaxPer,'-1')='6.250')=0)
	begin
	   set Identity_insert TaxMaster on
	   insert into TaxMaster	(AutoId,TaxId,	TaxName	,TaxPer,	Status,SeqNo)
	   values(2,'TAX100002','6.6250','6.250',1,1)
	   set Identity_insert TaxMaster off
	   update SequenceCodeGeneratorMaster set currentSequence=2 where SequenceCode='TaxId'
	end

	

	set @TotalProductCount=(select count(1) from POSProductExcel)

	set @CurrentProductRow=1;

    declare @i11 int=1, @row11 int=0,@UnitName varchar(15)='',@TempunitName varchar(15)='',@TempDepartmentName varchar(100)='',
	@TempVendorName varchar(150)='',@TempBarcode varchar(50)='',@VendorIdS varchar(20)='';
	while(@CurrentProductRow<=@TotalProductCount)
	begin
		begin try
		begin tran
	    if((select Status from POSProductExcel where convert(int,AutoId)=@CurrentProductRow)=1)
		begin
	       set @BrandAutoId=(select AutoId from BrandMaster where AutoId=1)
		   set @AgeRestrictionId=(select AutoId from AgeRestrictionMaster where Age=18)
			
		   if exists(select CategoryName from CategoryMaster where trim(CategoryName) like (select trim(Category) from POSProductExcel where AutoId=@CurrentProductRow))
		   begin
		      set @CatgoryAutoId=(select top 1 AutoId from CategoryMaster where trim(CategoryName) like (select trim(Category) from POSProductExcel where AutoId=@CurrentProductRow))
		   end
		   else
		   begin
		      SET @CategoryId = (SELECT DBO.SequenceCodeGenerator('CategoryId'))  	
			  insert into CategoryMaster(Categoryid, CategoryName,  Status, [CreatedBy], [CreatedDate], [IsDeleted],[APIStatus])
			  select @CategoryId,trim(Category), 1, @Who, GETDATE(), 0, 0 from POSProductExcel where AutoId=@CurrentProductRow
			  set @CatgoryAutoId=(select SCOPE_IDENTITY())
			  UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CategoryId'  
		   end

		   set @TempDepartmentName=(select trim(Department) from POSProductExcel where AutoId=@CurrentProductRow)
		   if exists(select DepartmentName from DepartmentMaster where trim(DepartmentName) like @TempDepartmentName)
		   begin
		      set @DeptId=(select top 1 AutoId from DepartmentMaster where trim(DepartmentName) like @TempDepartmentName)
			  set @AgeRestrictionId=(select AgeRestrictionId from DepartmentMaster where AutoId=@DeptId)
		   end
		   else
		   begin
		      SET @DepartmentId = (SELECT DBO.SequenceCodeGenerator('DepartmentId')) 
	          insert into DepartmentMaster(DepartmentId,DepartmentName,AgeRestrictionId, CreatedBy, CreatedDate, Status,IsDeleted)      
              values(@DepartmentId,@TempDepartmentName,@AgeRestrictionId,@Who ,GETDATE(),1,0) 
		      set @DeptId=SCOPE_IDENTITY()
			  UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='DepartmentId'
		   end
		   
		   set @ProductName=(SELECT trim(SUBSTRING(ProductName,0,case when CHARINDEX('-',ProductName,0)=0 then len(ProductName)+1 else CHARINDEX('-',ProductName,0) end)) FROM POSProductExcel where AutoId=@CurrentProductRow)
		   set @ProductSize=(select  (case when isnull(dbo.Fn_Split_Num_Char(Size,'Number'),'1')='' then '1' else isnull(dbo.Fn_Split_Num_Char(Size,'Number'),'1') end) from POSProductExcel where AutoId=@CurrentProductRow)
		   set @TempunitName=(select (case when isnull(dbo.Fn_Split_Num_Char(Size,'Character'),'pcs')='' then 'pcs' else isnull(dbo.Fn_Split_Num_Char(Size,'Character'),'pcs') end)  from POSProductExcel where AutoId=@CurrentProductRow)
		   if exists(select * from MeasurementUnitMaster where UnitName like @TempunitName)
		   begin
		      set @UnitName=@TempunitName 
		   end
		   else
		   begin
		      insert into MeasurementUnitMaster(UnitName,Status,Seq)
			  values(@TempunitName,1,0)
		      set @UnitName=@TempunitName
		   end

		   set @Description=(select isnull(Description_One,'') from POSProductExcel where AutoId=@CurrentProductRow)
		   set @AgeRestrictionId=(select AgeRestrictionId from DepartmentMaster where AutoId=@DeptId)
		   
		   if (isnull((select Vendor from POSProductExcel where AutoId=@CurrentProductRow),'') !='')
		   begin
			   set @TempVendorName=(select Vendor from POSProductExcel where AutoId=@CurrentProductRow)
				if exists(select * from VendorMaster where VendorName like '%'+@TempVendorName+'%')
				begin
					set @VendorId=(select top 1 AutoId from VendorMaster where VendorName like '%'+@TempVendorName+'%')
				end
				else
				begin
					SET @VendorIdS = (SELECT DBO.SequenceCodeGenerator('VendorId'))
					insert into VendorMaster(VendorCode,CompanyId,[VendorId], [VendorName], [Address1], Country,[City], [State], [Zipcode], [Emailid], [MobileNo], Status,CreatedBy,CreatedDate)
					values ('',@StoreId,@VendorIdS, @TempVendorName, '','USA', '', 0, '', '', '', 1,@Who,GETDATE())
					UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='VendorId'  
					set @VendorId=(select SCOPE_IDENTITY())
				end
			end
		   If not exists (select ProductName,* from ProductMaster where ProductName=@ProductName and Size=@ProductSize and MeasurementUnit=@UnitName)  
	       Begin

					set @MasterInsertId=(select isnull(Max(MasterInsertId),0)+1 from SKUMaster)

					Set @ProductId = (SELECT DBO.SequenceCodeGenerator('ProductId'))  
					insert into ProductMaster([BrandId], [CategoryId], [ProductId],Preferred_VendorId,ImagePath,	ViewImage, [ProductName], Size, Description,[AgeRestrictionId],  [Status], [CreatedBy], [CreatedDate], [UpdatedBy], [updatedDate],DeptId,CreatedByStoreId,IsDeleted,MeasurementUnit,MasterInsertId)
					values(@BrandAutoId, @CatgoryAutoId, @ProductId, 0,'',1,@ProductName,@ProductSize,@Description,@AgeRestrictionId,  1, @Who, GETDATE(), @Who, GETDATE(),@DeptId,@StoreId,0,@UnitName,@MasterInsertId)
	       
					set @ProductAutoId=(SELECT SCOPE_IDENTITY())

					set @InStockQty=(select isnull(Inventory,0) from POSProductExcel where AutoId=@CurrentProductRow)
					insert into ManageStockMaster( ProductId, BatchNo, StockQty, AlertQty, CreatedBy, CreatedDate, CreatedByStoreId, Status, IsDeleted,MasterInsertId,StoreId,UpdateDate)
					select @ProductAutoId,'',(Case when CP.AutoId=@StoreId then @InStockQty else 0 end),0,@Who,GETDATE(),@StoreId,1,0,@MasterInsertId,cp.AutoId,GETDATE() from CompanyProfile CP 

					set @ManageStock=(select case when @InStockQty=0 then 0 else 1 end)
					set @TaxAutoId=(select (case when Tax_Code='No' then (select AutoId from TaxMaster where TaxName='No Tax') else (select AutoId from TaxMaster where TaxPer=6.250) end)  from POSProductExcel where AutoId=@CurrentProductRow)
					set @WebAvailability=1

					insert into [dbo].[StoreWiseProductList]( StoreId, ProductId,  IsFavourite,  ManageStock,InstockQty ,AlertQty,CreatedBy, CreatedDate, Status1, IsDeleted,CreatedByStoreId,TaxId,WebAvailibilty,MasterInsertId)
					select CP.AutoId ,@ProductAutoId,0,(case when CP.AutoId=@StoreId then @ManageStock else 0 end),(case when CP.AutoId=@StoreId then @InStockQty else 0 end),0,@Who,GETDATE(),(case when CP.AutoId=@StoreId then 1 else 0 end),0,@StoreId,@TaxAutoId,@WebAvailability,@MasterInsertId from CompanyProfile CP

					if(isnull((select Vendor_Code from POSProductExcel where AutoId=@CurrentProductRow),'') !='')
					begin
						select @VendorId VendorId,Vendor_Code VendorProductCode,other_vc OtherVPC into #TempVendorProductCodeList from POSProductExcel where AutoId=@CurrentProductRow and isnull(Vendor,'')!='' and Vendor_Code!='0' and Vendor_Code!=''
						select  ROW_NUMBER() over(order by AutoId asc)RowNo, DTVP.*,AutoId as StoreId into #TempStorecnt from CompanyProfile CP,#TempVendorProductCodeList DTVP where CP.Status=1
		   
						insert into VendorProductCodeList(ProductId,StoreId,ProductStoreId,VendorId,VendorProductCode,OtherVPC,CreatedBy,CreatedDate,CreatedByStoreId,Status,MasterInsertId)
						select @ProductAutoId,t.StoreId, (select max(AutoId) from StoreWiseProductList where ProductId=@ProductAutoId and StoreId=t.StoreId),t.VendorId,t.VendorProductCode ,t.OtherVPC,@Who ,GETDATE(),@StoreId ,1,@MasterInsertId   from #TempStorecnt t
		            
					end
					select (case when isnull(Case_QTY,0)!=0 then convert(varchar(20),Case_QTY)+' Piece' else '1 Piece' end) [PackingName],
					(case when isnull(Case_QTY,0)!=0 then Case_QTY else 1 end)[NoOfPieces],'' [PieceSize],'' [Barcode],
					0 [CostPrice],Standard_Price [SellingPrice],Standard_Price [SecondaryUnitPrice],@TaxAutoId [TaxAutoId],'' [WebAvailability],''[ImageName],
					0 [ManageStock],0 [AvailableQty],0 [AlertQty],1 [Status] into #TempProductPakingTypeList from POSProductExcel where AutoId=@CurrentProductRow

					Select ROW_NUMBER() over (order by PackingName desc) as RowNumber,  DT.*,CP.AutoId as StoreId,(case when (CP.AutoId in (select splitdata from dbo.fnSplitString(@StoreIdsString,','))) then DT.Status else 0 end)PackingStatus into #temp_11 from #TempProductPakingTypeList DT,CompanyProfile CP
					where CP.Status=1
		   
					select @TempBarcode=isnull([Barcode],'')+(case when (isnull(other_upc,'')!='' and [Barcode]!=other_upc) then ','+other_upc else '' end) from POSProductExcel where AutoId=@CurrentProductRow
	       
					select splitdata Barcode into #TempBarcodeList from dbo.fnSplitString(@TempBarcode,',')
					where splitdata!=''

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
							Select @SKUId,@StoreProductId, @ProductName +'-'+@ProductSize+''+@UnitName , [PackingName], '', Status, '1', @ProductAutoId, 0,  @Who, GETDATE(), @Who, GETDATE(), 0, 0,@Image,StoreId,@StoreId,@MasterInsertId
							from #temp_11 where RowNumber=@i11
	             
							set @SKUAutoId=(SELECT SCOPE_IDENTITY())
	             
							insert into [dbo].[SKUItemMaster]([SKUAutoId], StoreProductId,[ProductId], [ProductUnitAutoId], [Quantity], [UnitPrice], [Discount],CreatedBy,CreatedDate,CreatedByStoreId,	Status,	IsDeleted,MasterInsertId)
							Select @SKUAutoId,@StoreProductId ,@ProductAutoId, @AutoId, 1, [SellingPrice], 0,@Who,GETDATE(),@StoreId,Status,0,@MasterInsertId
							from #temp_11 where RowNumber=@i11
	             
							insert into [dbo].[BarcodeMaster] ([Barcode], StoreProductId,[CreatedDate], [UpdatedDate], [SKUId], [IsDefault],CreatedBy,UpdatedBy,CreatedByStoreId,StoreId,IsDeleted,ProductUnitId,MasterInsertId)
							Select dt.[Barcode],@StoreProductId , getdate(), getdate(), @SKUAutoId, 1,@Who,0,@StoreId,StoreId,0,@AutoId,@MasterInsertId
							from #temp_11,#TempBarcodeList dt where RowNumber=@i11
	             
							UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='SKU'
	             
							set @i11 =@i11+1;
	             
							UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='ProductId'
	           
					END
					if(isnull((select Vendor_Code from POSProductExcel where AutoId=@CurrentProductRow),'') !='')
					begin
		              drop table #TempVendorProductCodeList;
					  drop table #TempStorecnt;
					end
					drop table #TempProductPakingTypeList;
					drop table #temp_11;
					drop table #TempBarcodeList;
					update POSProductExcel set InsertStatus=1 where AutoId=@CurrentProductRow
		           end
				    
		end
		commit tran
		END TRY     
		begin catch
		  rollback tran
					--drop table #TempVendorProductCodeList;
					--drop table #TempProductPakingTypeList;
					--drop table #TempStorecnt;
					--drop table #temp_11;
					--drop table #TempBarcodeList;
		    update POSProductExcel set InsertStatus=0 where AutoId=@CurrentProductRow
		    set @ErrorMessage=ERROR_MESSAGE()
		    select @ErrorMessage
		end catch
		
        set @CurrentProductRow=@CurrentProductRow+1
end