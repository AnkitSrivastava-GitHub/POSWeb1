Create or alter procedure [dbo].[ProcProductGrouping]
@Opcode int=null,
@who  int=null,
@StoreId int=null,
@DepartmentId int=null,
@CategoryId int=null,
@SKUId int=null,
@MixNMatchId int=null,
@GroupName varchar(100)=null,
@Status int=null,
@Quantity  int=null,
@DiscountCriteria  int=null,
@DiscountValue decimal(18,2)=null,
@ProductGroupTable [dbo].[DT_MixNMatch] readonly,
@PageIndex  int=null,
@PageSize  int=null,
@RecordCount  int=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
BEGIN
BEGIN TRY
begin tran
         SET @exceptionMessage='Success'
         SET @isException=0
		 If @Opcode=11
      BEGIN
	  if exists(select * from MixNMatchMaster where trim(groupName) like trim(@GroupName))
	  begin
	     set @isException=1
		 set @exceptionMessage='Group Name already exists!'
	  end
	  else
	  begin
      BEGIN TRY
     	 BEGIN TRAN
		         insert into MixNMatchMaster(GroupName,MinQty,DiscountCriteria ,DiscountVal ,StoreId ,CreatedBy ,CreatedDate ,UpdatedBy ,UpdatedDate ,CreatedByStoreId ,Status)
		         values(@GroupName,@Quantity,@DiscountCriteria,@DiscountValue,@StoreId,@who,GETDATE(),@who,GETDATE(),@StoreId,@Status)
		 
		         set @MixNMatchId=SCOPE_IDENTITY()

				 insert into MixNMatchItemList(MixNMatchId ,SKUAutoId ,SKUQuantity )
				 select @MixNMatchId,SKUAutoId,SKUQuantity from @ProductGroupTable

		 commit tran
	  end try
		 begin catch
		    rollback tran
		    set @isException=1
		    set @exceptionMessage=ERROR_MESSAGE()
		 end catch
      end
	  end
	  If @Opcode=21
      BEGIN
	  if exists(select * from MixNMatchMaster where trim(groupName) like trim(@GroupName) and AutoId!=@MixNMatchId)
	  begin
	     set @isException=1
		 set @exceptionMessage='Group Name already exists!'
	  end
	  else

	  begin
      BEGIN TRY
     	 BEGIN TRAN
			update MixNMatchMaster set GroupName=@GroupName,MinQty=@Quantity,DiscountCriteria=@DiscountCriteria,DiscountVal=@DiscountValue,
			UpdatedBy=@who,UpdatedDate=getdate(),Status=@Status where AutoId=@MixNMatchId

			delete from MixNMatchItemList where MixNMatchId=@MixNMatchId

			insert into MixNMatchItemList(MixNMatchId ,SKUAutoId ,SKUQuantity )
			select @MixNMatchId,SKUAutoId,SKUQuantity from @ProductGroupTable

		 commit tran
	  end try
		 begin catch
		    rollback tran
		    set @isException=1
		    set @exceptionMessage=ERROR_MESSAGE()
		 end catch
      end
	  end
	  If @Opcode=31
      BEGIN
	 
      BEGIN TRY
     	 BEGIN TRAN
		    delete from MixNMatchItemList where MixNMatchId=@MixNMatchId
			delete from MixNMatchMaster where AutoId=@MixNMatchId
		 commit tran
	  end try
		 begin catch
		    rollback tran
		    set @isException=1
		    set @exceptionMessage=ERROR_MESSAGE()
		 end catch
     
	  end
      If @Opcode=41
      BEGIN
		Select (isnull((select AutoId as [A], SKUPackingName as [P]
		from SKUMaster  SM
		where SM.Status=1 and StoreId=@StoreId and SM.ProductId!=0 and AutoId not in (select AutoId from SKUMaster where SKUName like '%Lottery%' )
		and (productId=0 or productId in (select ProductId from StoreWiseProductList where StoreId=@StoreId and Status=1))
		order by isnull(CreatedDate,getdate()) desc for json path, INCLUDE_NULL_VALUES),'[]'))PL, 
		(isnull((
		select distinct  DM.AutoId A , DepartmentName B
		from DepartmentMaster DM
		inner join ProductMaster PM on PM.DeptId=DM.AutoId
		inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		where DM.Status=1 and SPL.Status=1 and SPL.StoreId=@StoreId  and DepartmentName not like '%Lottery%'
		for json path, INCLUDE_NULL_VALUES),'[]'))DL,
		(isnull((
		select distinct CM.AutoId A , CategoryName B 
		from CategoryMaster  CM
		inner join ProductMaster PM on PM.CategoryId=CM.AutoId
		inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
		where CM.Status=1 and SPL.Status=1 and SPL.StoreId=@StoreId and CategoryName not like '%Lottery%'
		for json path, INCLUDE_NULL_VALUES),'[]'))CL,
		(isnull((
		select AutoId A , DiscountCriteria B from MixNMatchDiscountCriteriaMaster  
		where Status=1
		order by SeqNo asc
		for json path, INCLUDE_NULL_VALUES),'[]'))DCL
		for json path, INCLUDE_NULL_VALUES
      end
	  If @Opcode=42
      BEGIN
		 Select (isnull((
		 select SM.AutoId SKUId,DM.DepartmentName,CM.CategoryName, SM.ProductId,SKUPackingName SKUName,SKUSubTotal,SKUTotalTax,SKUTotal, 
		 SIM.taxper,SPL.TaxId
		 from SKUMaster SM
         inner join ProductMaster PM on PM.AutoId=SM.ProductId
		 inner join DepartmentMaster DM on DM.AutoId=PM.DeptId
		 inner join CategoryMaster CM on CM.AutoId=PM.CategoryId
         inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId
         inner join SKUItemMaster SIM on SIM.SKUAutoId=SM.AutoId
         Inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
         where SM.ProductId!=0 and SPL.Status=1 and SM.Status=1 and PUD.Status=1 and SPL.SKUCount>0
         and SPL.StoreId=@StoreId and SM.StoreId=@StoreId and PUD.StoreId=@StoreId 
         and (@DepartmentId is null or @DepartmentId=0 or DeptId=@DepartmentId)
		 and (@CategoryId is null or @CategoryId=0 or PM.CategoryId=@CategoryId)
		 and (@SKUId is null or @SKUId=0 or SM.AutoId=@SKUId)
		 for json path, INCLUDE_NULL_VALUES),'[]'))SL
		 for json path, INCLUDE_NULL_VALUES
      end
	  if(@Opcode=43)
	  begin
	      select ROW_NUMBER() over(order by MM.UpdatedDate desc)RowNumber,MM.AutoId,MM.GroupName,MM.MinQty,MM.DiscountCriteria DisTypeId,MM.DiscountVal,
		  MM.UpdatedDate,MD.DiscountCriteria DisType,MM.Status,
		  UDM.FirstName+isnull(' '+UDM.LastName,'')+'<br>'+format(MM.UpdatedDate , 'MM/dd/yyyy hh:mm tt') CreationDetail
		  into #tempList
		  from MixNMatchMaster MM
		  inner join MixNMatchDiscountCriteriaMaster MD on MD.AutoId=MM.DiscountCriteria
		  inner join UserDetailMaster UDM on UDM.UserAutoId=MM.UpdatedBy
		  where (@GroupName is null or @GroupName='' or MM.GroupName like '%'+@GroupName+'%')
		  and (@Status is null or @Status=2 or MM.Status=@Status)
		  and StoreId=@StoreId
		  order by MM.UpdatedDate desc

		  SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, '#Sort By: Updated date & time desc' as SortByString FROM #tempList      
      
          Select  * from #tempList t      
          WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex - 1) * @PageSize + 1 AND(((@PageIndex - 1) * @PageSize + 1) + @PageSize) - 1))       
          order by  updatedDate desc  

	  end

	  if(@Opcode=44)
	  begin
	      select ROW_NUMBER() over(order by MML.AutoId desc)RowNumber,MML.AutoId,MML.MixNMatchId,DM.DepartmentName,CM.CategoryName,SM.SKUPackingName,
		  PUD.SellingPrice OrgUnitPrice,0 Discount,0 DiscountP, 0 DiscountedUnitedPrice,TM.TaxPer,0 Tax, PUD.SellingPrice Total
		  into #tempProductItemList
		  from MixNMatchItemList MML
		  inner join SKUMaster SM on SM.AutoId=MML.SKUAutoId
		  inner join SKUItemMaster SIM on SIM.SKUAutoId=MML.SKUAutoId
		  inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
		  inner join StoreWiseProductList SPL on SPL.ProductId=PUD.ProductId
		  inner join ProductMaster PM on PM.AutoId=PUD.ProductId
		  inner join DepartmentMaster DM on DM.AutoId=PM.DeptId
		  inner join CategoryMaster CM on CM.AutoId=PM.CategoryId
		  inner join TaxMaster TM on TM.AutoId=SPL.TaxId
		  where SM.StoreId=@StoreId and MMl.MixNMatchId=@MixNMatchId and SPL.StoreId=@StoreId
		  order by  MML.AutoId desc

		  SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, '#Sort By: Created date desc' as SortByString FROM #tempProductItemList      
      
          Select  * from #tempProductItemList t      
          WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex - 1) * @PageSize + 1 AND(((@PageIndex - 1) * @PageSize + 1) + @PageSize) - 1))       
          order by  AutoId desc 
		  
		  select DiscountCriteria DiscountType,DiscountVal from MixNMatchMaster where AutoId=@MixNMatchId

	  end
	  if(@Opcode=45)
	  begin
	      Select (isnull((
	      select AutoId, GroupName, MinQty, DiscountCriteria, DiscountVal, Status from MixNMatchMaster where AutoId=@MixNMatchId
	      for json path, INCLUDE_NULL_VALUES),'[]'))GroupDetails,
		  (isnull((
		  select MML.AutoId,MML.MixNMatchId,DM.DepartmentName,CM.CategoryName,SM.SKUPackingName SKUName,MML.SKUAutoId SKUId,SM.SKUSubTotal,SM.SKUTotal,
		  PUD.SellingPrice OrgUnitPrice,0 Discount,0 DiscountP, 0 DiscountedUnitedPrice,TM.TaxPer taxper,TM.AutoId TaxId,0 Tax, PUD.SellingPrice Total
		  from MixNMatchItemList MML
		  inner join SKUMaster SM on SM.AutoId=MML.SKUAutoId
		  inner join SKUItemMaster SIM on SIM.SKUAutoId=MML.SKUAutoId
		  inner join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
		  inner join StoreWiseProductList SPL on SPL.ProductId=PUD.ProductId
		  inner join ProductMaster PM on PM.AutoId=PUD.ProductId
		  inner join DepartmentMaster DM on DM.AutoId=PM.DeptId
		  inner join CategoryMaster CM on CM.AutoId=PM.CategoryId
		  inner join TaxMaster TM on TM.AutoId=SPL.TaxId
		  where SM.StoreId=@StoreId and MMl.MixNMatchId=@MixNMatchId and SPL.StoreId=@StoreId
		  order by  MML.AutoId desc
		  for json path, INCLUDE_NULL_VALUES),'[]'))GroupItemList
		  for json path, INCLUDE_NULL_VALUES
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
