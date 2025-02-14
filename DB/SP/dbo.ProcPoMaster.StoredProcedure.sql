Create or alter   procedure [dbo].[ProcPoMaster]
@Opcode int= null,
@PoNumber varchar(50)=null,
@PackingAutoId int=null,
@ProductAutoId int=null,
@VendorAutoId int=null,
@VenderProductCode varchar(50)=null,
@Vendor varchar(100)=null,
@PoAutoId int =null,
@ProductUnitId int=null,
@StoreId int=null,
@Status1 varchar(50)=null,
@Barcode varchar(100)=null,
@Status int=null,
@PoDate datetime=null,
@Remark varchar(max)=null,
@Who int=null,
@DT_PoItemMasert DT_PoItemMasert  readonly,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
AS 
BEGIN
BEGIN TRY
    Set @isException=0                                                                                                   
	Set @exceptionMessage='Succeess'
if @Opcode=11
BEGIN
 BEGIN TRY
	BEGIN TRAN
	SET @PoNumber = (SELECT DBO.SequenceCodeGenerator('PoNumber'))  	
	
	insert into PoMaster(PoNumber,PoDate,VendorId,ReMark,Status,CreatedDate,UpdatedDate,CreatedBy,UpdatedBy,StoreId)
	values(@PoNumber,@PoDate,@VendorAutoId,@Remark,@Status,GETDATE(),GETDATE(),@Who,@Who,@StoreId)

	set @PoAutoId=(SELECT SCOPE_IDENTITY())
	
	insert into PoItemMaster(PoAutoId,ProductId,PackingId,RequiredQty,CreatedDate,UpdatedDate,StoreId,UnitPrice,SecUnitPrice,VendorProductCode)
	select @PoAutoId,ProductId,PackingId,RequiredQty,GETDATE(),GETDATE(),@StoreId,UnitPrice,SecUnitPrice,VendorProductCode from @DT_PoItemMasert

	UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='PoNumber'  
	COMMIT TRANSACTION    
 END TRY                                                                                                                                      
 BEGIN CATCH                                                                                                                                
	ROLLBACK TRAN                                                                                                                         
	Set @isException=1                                                                                                   
	Set @exceptionMessage=ERROR_MESSAGE()                                                                     
 End Catch      
END
if @Opcode=21
BEGIN
 BEGIN TRY
	BEGIN TRAN
	update PoMaster set PoDate=@PoDate,VendorId=@VendorAutoId,ReMark=@Remark, Status=@Status,StoreId=@StoreId where AutoId=@PoAutoId
	
	--0 for deleted items/ products from the po list
	delete from PoItemMaster where PoAutoId=@PoAutoId

	--1 for Insert or new Added items/product
	insert into PoItemMaster(PoAutoId,ProductId,PackingId,RequiredQty,CreatedDate,UpdatedDate,StoreId,UnitPrice,SecUnitPrice,VendorProductCode)
	select @PoAutoId,ProductId,PackingId,RequiredQty,GETDATE(),GETDATE(),@StoreId,UnitPrice,SecUnitPrice,VendorProductCode from @DT_PoItemMasert
	--where DPM.ActionId=1

	--2 for updated items/products
	--Update PIM set PIM.ProductId=DPTM.ProductId,PIM.PackingId=DPTM.PackingId,PIM.RequiredQty=DPTM.RequiredQty,
	--PIM.UpdatedDate=GETDATE(),StoreId=@StoreId,VendorProductCode=DPTM.VendorProductCode,UnitPrice=DPTM.UnitPrice,SecUnitPrice=DPTM.SecUnitPrice
	--from PoItemMaster PIM
	--inner join @DT_PoItemMasert DPTM on DPTM.PoItemAutoId=PIM.AutoId
	--where DPTM.ActionId=2

	COMMIT TRANSACTION    
 END TRY                                                                                                                                      
 BEGIN CATCH                                                                                                                                
	ROLLBACK TRAN                                                                                                                         
	Set @isException=1                                                                                                   
	Set @exceptionMessage=ERROR_MESSAGE()                                                                     
 End Catch      
END
if @Opcode=31
BEGIN
 BEGIN TRY
	BEGIN TRAN
	    delete from PoMaster where AutoId=@PoAutoId
		
		delete from PoItemMaster where PoAutoId=@PoAutoId
	COMMIT TRANSACTION    
 END TRY                                                                                                                                      
 BEGIN CATCH                                                                                                                                
	ROLLBACK TRAN                                                                                                                         
	Set @isException=1                                                                                                   
	Set @exceptionMessage=ERROR_MESSAGE()                                                                     
 End Catch      
END
if @Opcode=41
BEGIN
   select AutoId,VendorName from VendorMaster where Status=1
END
if @Opcode=42
BEGIN
	select isnull((
		select PM.AutoId as [A],ProductSizeName as [P]	from ProductMaster PM 
		inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and StoreId=@StoreId
		where PM.ProductSizeName not like '%Lottery%'
		order by [P] asc for json path, INCLUDE_NULL_VALUES),'[]') as [ProductList],
        isnull((Select AutoId as [A],VendorName as [P] from VendorMaster where
		Status=1 order by isnull(SeqNo,0) desc, VendorName asc for json path, INCLUDE_NULL_VALUES),'[]') as [VendorList] for json path, INCLUDE_NULL_VALUES

 --   select PM.AutoId,ProductSizeName as ProductName 
	--from ProductMaster PM 
	--inner join StoreWiseProductList SPL on SPL.ProductId=PM.AutoId and StoreId=@StoreId
 --   where --PM.status=1 and
	--PM.ProductSizeName not like '%Lottery%'
	--order by PM.ProductName asc

	--Select AutoId,VendorName from VendorMaster where
	--Status=1 order by isnull(SeqNo,0) desc, VendorName asc
END
if @Opcode=43
BEGIN
  select pud.AutoId,PackingName, TaxPer from ProductUnitDetail pud
   inner join TaxMaster tm on tm.AutoId=pud.TaxAutoId
   where ProductId=@ProductAutoId and StoreId=@StoreId Order by pud.NoOfPieces
   --select CostPrice from  ProductUnitDetail where AutoId =@PackingAutoId
   
   select isnull(VendorProductCode,'')VendorProductCode from VendorProductCodeList where StoreId=@StoreId and VendorId=isnull(@VendorAutoId,0) and ProductId=@ProductAutoId
   
   
END
if @Opcode=49
BEGIN
Select SPL.ProductId as ProductId,SPL.SKUName as ProductName,SPL.PackingName as PackingName,pud.AutoId as UnitID
	    from SKUMaster SPL	    
		Inner Join ProductUnitDetail pud on pud.ProductId=SPL.ProductId and pud.StoreId=@StoreId 
		inner join ProductMaster PM on PM.AutoId=SPL.ProductId 
		Inner join BarcodeMaster BM on BM.SKUId=SPL.AutoId and BM.StoreId=@StoreId and pud.AutoId=BM.ProductUnitId
	    where  BM.Barcode=@Barcode and SPL.StoreId=@StoreId and PM.ProductName not like '%Lottery%' order by pud.NoOfPieces   
END

if @Opcode=47
BEGIN
  	select PM.AutoId,concat(PM.ProductName ,' -',PM.Size,PM.MeasurementUnit) as ProductName from VendorProductCodeList VPC 
	Left Join ProductMaster PM ON PM.AutoId=VPC.ProductId and PM.Status=1
	Left JOIN VendorMaster VM on VM.AutoId=VPC.VendorId and VM.Status=1
    where VPC.VendorProductCode=@VenderProductCode and StoreId=@StoreId and VM.AutoId=@VendorAutoId   
END

if @Opcode=48
BEGIN
  	select pud.AutoId,CostPrice,SellingPrice,SecondaryUnitPrice from ProductUnitDetail pud
   where ProductId=@ProductAutoId and StoreId=@StoreId and pud.AutoId=@ProductUnitId Order by pud.NoOfPieces
END

if @Opcode=44
BEGIN
    select top 1 PM.AutoId, PM.PoNumber, convert(varchar(10),PoDate,101) as PoDate, isnull(PIM.PoAutoId,0) as PIMAutoId, VendorId, PM.Remark, Status
    from PoMaster PM
	left JOIN PurchaseInvoiceMaster PIM on PIM.PoAutoId=PM.AutoId
    where PM.AutoId=@PoAutoId
    
    select POIM.AutoId,POIM.ProductId as ProductId, PM.ProductName as ProductName, POIM.PackingId as PackingId, PTM.PackingName as PackingName, 
	PTM.CostPrice as CostPrice, RequiredQty, PTM.CostPrice*RequiredQty as Total,UnitPrice,SecUnitPrice,VendorProductCode
    from PoItemMaster POIM
    inner join ProductMaster as PM on  POIM.ProductId=PM.Autoid
    left join ProductUnitDetail as PTM on POIM.PackingId=PTM.AutoID
    where PoAutoId=@PoAutoId
END
if @Opcode=45
BEGIN
    select ROW_NUMBER() over(order by POM.AutoId desc)as RowNumber,POM.Status,POM.UpdatedDate,
	POM.AutoId as AutoId,POM.PoNumber,convert(varchar(10),PoDate,101) as PoDate,VM.VendorName as VendorName,POM.Remark,
	ISNULL(UDM.FirstName,'')+' '+ISNULL(UDM.LastName,'')+'<br/>'+format(POM.CreatedDate,'MM/dd/yyyy hh:mm tt')as CreatedDetails,
	ISNULL(UDM1.FirstName,'')+' '+ISNULL(UDM1.LastName,'')+'<br/>'+format(POM.UpdatedDate,'MM/dd/yyyy hh:mm tt')as UpdatedDetails--,isnull(PIM.PoAutoId,0) as PIMAutoId
	,isnull((select top 1  AutoId from PurchaseInvoiceMaster t where t.PoAutoId=POM.AutoId),0) as PIMAutoId
	into #Temp 
	from PoMaster as POM
    inner join VendorMaster as VM on VM.AutoId=POM.VendorId
	left join UserDetailMaster UDM on UDM.UserAutoId=POM.CreatedBy
	left join UserDetailMaster UDM1 on UDM1.UserAutoId=POM.UpdatedBy
	--left JOIN PurchaseInvoiceMaster PIM on PIM.PoAutoId=POM.AutoId
    where (@PoNumber is null or @PoNumber=''  or POM.PoNumber like'%'+ @PoNumber +'%')
    and(@VendorAutoId is null or @VendorAutoId=0 or POM.VendorId=@VendorAutoId)
	--and(@Status is null or @Status=2 or POM.Status=@Status)
	and (@Status1='All' or(@Status1='New' and POM.Status=1 and (isnull((select top 1  AutoId from PurchaseInvoiceMaster t where t.PoAutoId=POM.AutoId),0))=0) 
	or (@Status1='Process') or (@Status1='Closed') or (@Status1='Inactive'))
	and(@StoreId is null or @StoreId=0 or POM.StoreId=@StoreId)
    order by POM.UpdatedDate desc


	select * into #Temp1 
	from #Temp
	where (@Status1='All' or(@Status1='New' and Status=1 and PIMAutoId=0) or (@Status1='Process'  and Status=1 and PIMAutoId!=0)
	or (@Status1='Closed' and Status=2) or (@Status1='Inactive' and Status=0))

	SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By:Po Number Desc' as SortByString FROM #Temp1      
             
    Select  * from #Temp1 t      
    WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
    order by UpdatedDate desc
END
if @Opcode=46
BEGIN
    select PIM.AutoId,PoAutoId,PIM.ProductId,PM.ProductName,PackingId,PUD.PackingName,RequiredQty,PIM.CreatedDate,PIM.UpdatedDate
	from PoItemMaster PIM
	inner join ProductMaster PM on PM.AutoId=PIM.ProductId
	inner join ProductUnitDetail PUD on PUD.AutoId=PIM.PackingId
	where PoAutoId=@PoAutoId
END
END TRY
 BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
End
GO
