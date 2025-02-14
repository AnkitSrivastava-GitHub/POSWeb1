alter   procedure [dbo].[ProcSchemeMaster]
@Opcode int= null,
@AutoId int=null,
@who int=null,
@SchemeName varchar(100)=null,
@SKUAutoId int=null,
@StoreId int=null,
@FromDate datetime=null,
@ToDate datetime=null,
@SchemeDaysString varchar(500)=null,
@Quantity int=null,
@UnitPrice decimal(18,3)=null,
@Status int=null,
@DT_SchemeProduct DT_SchemeProduct readonly,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
begin
BEGIN TRY
SET @isException=0
SET @exceptionMessage='Success!!'
if @Opcode=11
begin
	If exists (select [SchemeName] from SchemeMaster where replace([SchemeName],' ','')=replace(@SchemeName,' ','') and StoreId=@StoreId)   
	Begin
		Set @isException=1
		SET @exceptionMessage='Scheme name already exists!'
	End 
	else If exists (select * from SchemeMaster where SKUAutoId=@SKUAutoId and Quantity=@Quantity)   
	Begin
	    declare @SchemeCurrentStatus varchar(50)='';
		set @SchemeCurrentStatus=(select top 1 case when Status=1 then 'active' when Status=0 then 'inactive' else 'inactive' end from SchemeMaster where SKUAutoId=@SKUAutoId and Quantity=@Quantity)
		Set @isException=1
		SET @exceptionMessage='A '+@SchemeCurrentStatus+' Scheme is already exists with same product/SKU and same quantity!'
	End 
	ELSE
	BEGIN
		BEGIN TRY
		BEGIN TRAN  
		
			INSERT INTO SchemeMaster(SchemeName, SKUAutoId, Quantity,Status,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,FromDate,ToDate,SchemeDaysString,StoreId)
			values(@SchemeName, @SKUAutoId, @Quantity,@Status,@who,getdate(),@who,getdate(),@FromDate,@ToDate,@SchemeDaysString,@StoreId)
			
			set @AutoId=(SELECT SCOPE_IDENTITY())
	
			insert into SchemeItemMaster(SchemeAutoId, ProductAutoId, PackingAutoId, Quantity, UnitPrice)
			select @AutoId, [ProductId], [PackingId], [Quantity], [UnitPrice] from @DT_SchemeProduct

		 COMMIT TRANSACTION    
		END TRY                                                                                                                                      
		BEGIN CATCH                                                                                                                                
			ROLLBACK TRAN                                                                                                                         
			Set @isException=1                                                                                                   
			Set @exceptionMessage=ERROR_MESSAGE()                                                                     
		End Catch                                                                                                                                      
	END
end
if @Opcode=21
BEGIN
    If exists (select [SchemeName] from SchemeMaster where replace([SchemeName],' ','')=replace(@SchemeName,' ','') and [AutoId]!=@AutoId and StoreId=@StoreId)   
	Begin
		Set @isException=1
		SET @exceptionMessage='Scheme name already exists!'
	End 
	 else If exists (select * from SchemeMaster where SKUAutoId=@SKUAutoId and Quantity=@Quantity and AutoId!=@AutoId)   
	Begin
	    declare @SchemeCurrentStatus1 varchar(50)='';
		set @SchemeCurrentStatus1=(select top 1 case when Status=1 then 'active' when Status=0 then 'inactive' else 'inactive' end from SchemeMaster where SKUAutoId=@SKUAutoId and Quantity=@Quantity and AutoId!=@AutoId)
		Set @isException=1
		SET @exceptionMessage='A '+@SchemeCurrentStatus1+' Scheme is already exists with same product/SKU and same quantity!'
	End 
	ELSE
	begin
	BEGIN TRY
		UPDATE SchemeMaster set  SchemeName=@SchemeName, SKUAutoId=@SKUAutoId, Quantity=@Quantity,Status=@Status 
		,UpdatedBy=@who,UpdatedDate=getdate(),FromDate=@FromDate,ToDate=@ToDate,SchemeDaysString=@SchemeDaysString
		where [AutoId]=@AutoId

		delete from SchemeItemMaster where SchemeAutoId=@AutoId

		insert into SchemeItemMaster(SchemeAutoId, ProductAutoId, PackingAutoId, Quantity, UnitPrice)
		select @AutoId, [ProductId], [PackingId], [Quantity], [UnitPrice] from @DT_SchemeProduct
    END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                       
	End Catch
	end
END
if @Opcode=41
BEGIN


      select * into #TempSKUList from(
	   Select  AutoId,CreatedDate, SKUName+isnull((case when PackingName='' then '' when PackingName='1pcs' then '/1Piece' else replace('/'+PackingName,'pcs', 'Pieces') end),'') SKUName
	   from SKUMaster  SM
	   where SM.Status=1 and StoreId=@StoreId and AutoId not in (select AutoId from SKUMaster where SKUName like '%Lottery%')
	   and (SM.productId=0 or productId in (select ProductId from StoreWiseProductList where StoreId=@StoreId and Status=1))

	   union 

	   Select  AutoId,CreatedDate, SKUName+isnull((case when PackingName='' then '' when PackingName='1pcs' then '/1Piece' else replace('/'+PackingName,'pcs', 'Pieces') end),'') SKUName
	   from SKUMaster  SM
	   where 
	   SM.AutoId in (select SKUAutoId from SchemeMaster where AutoId=@AutoId)
	 )t

	 select (isnull((
     select scm.AutoId, SchemeName as SchemeName, sm.SKUName as SKUName, scm.Quantity as Quantity,  scm.UnitPrice as SchemePrice,
     scm.Status,scm.SKUAutoId, sm.[SKUSubTotal] as SKUPrice,format(scm.FromDate,'MM/dd/yyyy')FromDate ,format(scm.ToDate,'MM/dd/yyyy')ToDate , scm.SchemeDaysString
     from  SchemeMaster scm
     inner join SKUMaster sm on sm.AutoId=scm.SKUAutoId
     where scm.AutoId =@AutoId
     order by SchemeName for json path,include_null_values),'[]'))SKUDetails,
     (isnull((
     Select sim.AutoId,SIM.ProductAutoId as ProductId, pm.ProductSizeName as ProductName, SIM.PackingAutoId as PackingId, ptm.PackingName as PackingName,PTM.SellingPrice,
     sim.Quantity as Quantity, sim.UnitPrice as UnitPrice ,PTM.TaxAutoId,(select TaxPer from taxmaster tm where tm.AutoId=PTM.TaxAutoId)as TaxPer,
	 (select isnull(sum(isnull(discount,0)),0) from SKUItemMaster SKIM 
	 where SKIM.ProductId=sim.ProductAutoId and SKIM.ProductUnitAutoId=siM.PackingAutoId and SKIM.SKUAutoId=SM.SKUAutoId) as Discount
     from SchemeItemMaster  sim
     inner join ProductUnitDetail PTM on PTM.AutoId=sim.PackingAutoId
     inner join ProductMaster pm on pm.AutoId=sim.ProductAutoId
	 inner join SchemeMaster SM on SM.AutoId=SIM.SchemeAutoId
     where sim.SchemeAutoId=@AutoId
     order by sim.AutoId for json path,include_null_values),'[]'))SKUProductList,
	 (isnull((
	 select * from #TempSKUList
	 order by isnull(CreatedDate,getdate()) desc 
	 for json path,include_null_values),'[]'))SKUList,
	 (isnull((
	  select CurrencySymbol A from CompanyProfile CP
	  inner join CurrencySymbolMaster CM on CM .AutoId=CP.CurrencyId
	  where Cp.AutoId=@StoreId
	 for json path,include_null_values),'[]'))CurrencySymbol
	 for json path,include_null_values
	
SET @isException=0
END
if @Opcode=42
begin
	Select  AutoId as [A], SKUPackingName as [P]
	from SKUMaster  SM
	where SM.Status=1 and StoreId=@StoreId and AutoId not in (select AutoId from SKUMaster where SKUName like '%Lottery%' )
	and (productId=0 or productId in (select ProductId from StoreWiseProductList where StoreId=@StoreId and Status=1))
	order by isnull(CreatedDate,getdate()) desc for json path, INCLUDE_NULL_VALUES 

 --   Select  AutoId, SKUName+isnull((case when PackingName='' then '' when PackingName='1pcs' then '/1Piece' else replace('/'+PackingName,'pcs', 'Pieces') end),'') SKUName
	--from SKUMaster  SM
	--where SM.Status=1 and StoreId=@StoreId and AutoId not in (select AutoId from SKUMaster where SKUName like '%Lottery%' )
	--and (productId=0 or productId in (select ProductId from StoreWiseProductList where StoreId=@StoreId and Status=1))
	--order by isnull(CreatedDate,getdate()) desc 

end
if @Opcode=43
begin
       Select [SKUSubTotal] as SKUPrice from SKUMaster where AutoId=@SKUAutoId  
	
       Select sim.AutoId, pm.AutoId as ProductId, pm.ProductSizeName as ProductName, Ptm.AutoId as PackingId, ptm.PackingName as PackingName,
       sim.Quantity as Quantity, convert(decimal(18,2),sim.UnitPrice) as UnitPrice,sim.Discount,--,[dbo].[FN_GetPercentage](sim.PriceAfterDis,isnull(tm.TaxPer,0))as SKUItemTotalTax,
       convert(decimal(18,2),sim.PriceAfterDis) as SKUItemUnitPrice  ,sim.Tax as Tax, isnull(tm.TaxPer,0) as TaxPer,
	   tm.AutoId as TaxAutoId, sim.SKUItemTotal
       from SKUItemMaster sim
       inner join ProductUnitDetail PTM on PTM.AutoId=sim.ProductUnitAutoId
       inner join ProductMaster pm on pm.AutoId=sim.ProductId
       left join TaxMaster tm on PTM.TaxAutoId=tm.AutoId
       where sim.SKUAutoId=@SKUAutoId
       order by sim.AutoId 
end
if @Opcode=44
BEGIN
       select row_number() over(order by scm.UpdatedDate desc)RowNumber, scm.AutoId, SchemeName as SchemeName, sm.SKUName as SKUName, 
	   convert(decimal(10,2),sm.SKUUnitTotal)as SKUUnitPrice,convert(decimal(18,2),scm.Tax)Tax,scm.UnitPrice as SchemePriceWithoutTax1,
	   scm.Quantity as Quantity, convert(decimal(18,2),scm.Tax) + scm.UnitPrice as SchemePrice,
       scm.Status as Status ,scm.SKUAutoId ,isnull((convert(decimal(10,2),sm.SKUUnitTotal)-convert(decimal(10,2),scm.UnitPrice)),0)Discount,
       --isnull(UM.FirstName+' '+isnull(UM.LastName,'')+'<br/>'+format(scm.CreatedDate , 'MM/dd/yyyy hh:mm tt'),'')as CreationDetails,
	   isnull(UM.FirstName,'')+' '+isnull(UM.LastName,'')+'<br/>'+format(scm.CreatedDate , 'MM/dd/yyyy hh:mm tt')as CreationDetails,
      -- isnull(UM1.FirstName+' '+isnull(UM1.LastName,'')+'<br/>'+format(scm.UpdatedDate , 'MM/dd/yyyy hh:mm tt'),'') as UpdationDetails
	   isnull(UM1.FirstName,'')+' '+isnull(UM1.LastName,'')+'<br/>'+format(scm.UpdatedDate , 'MM/dd/yyyy hh:mm tt') as UpdationDetails,
	   format(scm.FromDate,'MM/dd/yyyy')FromDate ,format(scm.ToDate,'MM/dd/yyyy')ToDate , scm.SchemeDaysString,scm.UpdatedDate  UpdatedDate1
	   into #SchemeTemp
       from  SchemeMaster scm
       inner join SKUMaster sm on sm.AutoId=scm.SKUAutoId
       left join UserDetailMaster UM on UM.UserAutoId=scm.CreatedBy
       left join UserDetailMaster UM1 on UM1.UserAutoId=scm.UpdatedBy
       where scm.StoreId=@StoreId and (@SchemeName is Null or @SchemeName = '' or SchemeName like '%'+@SchemeName+'%')
      	and (@Status is Null or @Status=2 or scm.Status =@Status)
      	and (@SKUAutoId is Null or @SKUAutoId = 0 or sm.AutoId =@SKUAutoId)
      	order by scm.UpdatedDate desc

		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By:Updated Date Desc' as SortByString FROM #SchemeTemp      
             
        Select  * from #SchemeTemp t      
        WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
        order by UpdatedDate1 desc

      	SET @isException=0
END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
