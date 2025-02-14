
CREATE or alter  procedure [dbo].[ProcPurchaseInvoiceMaster]
@Opcode int =null,
@PoAutoId int=null,
@Who int=null,
@StoreId int=null,
@InvoiceNo varchar(50)=null,
@BatchNo varchar(50)=null,
@Status int=null,
@PoNumber varchar(50)=null,
@Vendor varchar(50)=null,
@VendorAutoId  int=null,
@InvoiceId int=null,
@InvoiceItemId int=null,
@CostPrice decimal(18,2)=null,
@SaleInvoice varchar(50)=null,
@PurchageDate datetime=null,
@Remark varchar(500)=null,
@DT_InvoiceItem DT_InvoiceItem readonly,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
AS
Begin
BEGIN TRY
    set @isException=0
	set @exceptionMessage='Success'
   If @Opcode = 11
  BEGIN
  BEGIN TRY
  BEGIN TRAN

        --set @PoAutoId =@PoNumber
        if exists(select * from PurchaseInvoiceMaster where InvoiceNo=@InvoiceNo)
		begin
		     set @isException=1
	         set @exceptionMessage='Invoice number already exists!'
		end
		else
		begin
		set @VendorAutoId=(select VendorId from PoMaster where AutoId=@PoAutoId)
        insert into PurchaseInvoiceMaster(PoAutoId,InvoiceNo,PoNumber,InvoiceDate,Remark,CreatedDate,UpdateDate,CreatedBy,UpdatedBy,VendorAutoId,StoreId,BatchNo)
        values(@PoAutoId,@InvoiceNo,@PoNumber,@PurchageDate,@Remark,GETDATE(),GETDATE(),@Who,@Who,@VendorAutoId,@StoreId,@BatchNo)
       
        set @InvoiceId=(SELECT SCOPE_IDENTITY())
        
        insert into PurchaseItemMaster(InvoiceId,TaxType,ProductId,Packingid,ReceivedQty,UnitPrice,Taxper,createddate,StoreId,ProductUnitPrice,SecUnitPrice,VendorProductCode)
        select @InvoiceId,@SaleInvoice,ProductId,Packingid,ReceivedQty,UnitPrice,Taxper,GETDATE(),@StoreId,ProductUnitPrice,SecUnitPrice,VendorProductCode from @DT_InvoiceItem
        
        Insert into InventoryMaster (ProductAutoId, PackingAutoId, UnitPrice, Quantity,InvoiceId,StoreId)
        select ProductId,Packingid,UnitPrice,ReceivedQty,@InvoiceId,@StoreId from @DT_InvoiceItem

		Declare @ct int=null

		select t.ProductId,sum(PUD.NoOfPieces*t.ReceivedQty) as productQty,ROW_NUMBER() over(order by t.ProductId desc)as RowNumber into #Temp21 from @DT_InvoiceItem t
		inner Join ProductUnitDetail PUD on PUD.AutoId=t.Packingid
		group by t.ProductId
		
		set @ct=(select COUNT(*) from #Temp21)		
		
		while(@ct >= 1)
		Begin 
		Declare @InstockQty int=0
		set @InstockQty=isnull((select InstockQty from StoreWiseProductList where StoreId=@StoreId and ProductId=(select ProductId from #Temp21 where @ct=RowNumber)),0)
		if exists (select * from ManageStockMaster where ProductId in (select ProductId from #Temp21 where @ct=RowNumber) and StoreId=@StoreId)
		Begin
			insert into ManageStockMasterLog(ProductId,StockQTY,CreatedBy,CreatedDate,CreatedByStore,IsDeleted,PreviousStock,MSMAutoId,InvoiceId)
			select t.ProductId,t.productQty,@Who,GETDATE(),@StoreId,0, @InstockQty,MS.AutoId,@InvoiceId 
			from #Temp21 t Inner join ManageStockMaster MS on t.ProductId=MS.ProductId and MS.StoreId=@StoreId
			where @ct=RowNumber

			Update ManageStockMaster set UpdateDate=GETDATE(), StockQty=StockQty+(select productQty from #Temp21 where @ct=RowNumber) 
			where ProductId=(select ProductId from #Temp21 where @ct=RowNumber) and StoreId=@StoreId

			Update StoreWiseProductList set InstockQty=InstockQty+(select productQty from #Temp21 where @ct=RowNumber) 
			where ProductId=(select ProductId from #Temp21 where @ct=RowNumber) and StoreId=@StoreId
		End
		Else
		Begin
			insert into ManageStockMaster( ProductId, BatchNo, StockQty, AlertQty, CreatedBy, CreatedDate, CreatedByStoreId, Status, IsDeleted,StoreId)
			select ProductId,'',productQty,'',@Who,GETDATE(),@StoreId,1,(select StockQty from ManageStockMaster m where m.ProductId=t.ProductId and m.StoreId =@StoreId),@StoreId from #Temp21 t where @ct=RowNumber

			Declare @MSMAutoId int=null
			set @MSMAutoId=(SELECT SCOPE_IDENTITY())

			insert into ManageStockMasterLog(ProductId,StockQTY,CreatedBy,CreatedDate,CreatedByStore,IsDeleted,PreviousStock,MSMAutoId,InvoiceId)
			select t.ProductId, t.productQty,@Who,GETDATE(),@StoreId,0,@InstockQty,@MSMAutoId,@InvoiceId
			from #Temp21 t Inner join ManageStockMaster MS on t.ProductId=MS.ProductId and MS.StoreId=@StoreId
			where @ct=RowNumber

			Update StoreWiseProductList set InstockQty=InstockQty+(select productQty from #Temp21 where @ct=RowNumber) 
			where ProductId=(select ProductId from #Temp21 where @ct=RowNumber) and StoreId=@StoreId
		End	
		set @ct=(@ct-1)
        END 

        select PIM.PoNumber, isnull(sum(PUIM.ReceivedQty),0) as ReceivedQty , PUIM.Packingid, PUIM.ProductId
        into #temp11
        from PurchaseInvoiceMaster as PIM
        inner join PurchaseItemMaster as PUIM on PUIM.InvoiceId=PIM.AutoId
        where PIM.PoAutoId=@PoAutoId
        group by PIM.PoNumber,PUIM.Packingid, PUIM.ProductId
        
        Select PIM.ProductId, pm.ProductName, PIM.PackingId, ptm.PackingName, PIM.RequiredQty,ptm.CostPrice,tm.AutoId, case when ptm.TaxAutoId=0 then 0 else tm.TaxPer end as Tax,
        isnull((Select isnull(ReceivedQty,0) from #temp11 where Packingid=PIM.PackingId and ProductId=PIM.ProductId),0)as PartialReceivedQty,
        isnull((PIM.RequiredQty-isnull((Select isnull(ReceivedQty,0) from #temp11 where Packingid=PIM.PackingId and ProductId=PIM.ProductId),0)),PIM.RequiredQty)as RemainingQty
        into #t11_1
        from PoItemMaster as PIM
        inner join ProductMaster pm on pm.AutoId=PIM.ProductId
        inner join ProductUnitDetail ptm on ptm.AutoId=PIM.PackingId
        left join TaxMaster tm on tm.AutoId=ptm.TaxAutoId
        where PIM.PoAutoId=@PoAutoId
        
        if((select sum(RemainingQty) from #t11_1)=0)
        begin
             Update Pomaster set Status=2 where AutoId=@PoAutoId --2 is for PO Completed
        end
        --else
        --begin
        --    Update Pomaster set Status=@Status where AutoId=@PoAutoId
        --end 
        Select * from #t11_1
        select AutoId, PoNumber,convert(varchar(10),PoDate,101) as PoDate,VendorId,Remark,Status from PoMaster where AutoId=@PoAutoId
       end
   COMMIT TRANSACTION    
   END TRY                                                                                                                                      
   BEGIN CATCH                                                                                                                                
   ROLLBACK TRAN                                                                                                                        
           Set @isException=1                                                                                                  
           Set @exceptionMessage=ERROR_MESSAGE()                                                                    
    End Catch      
   END
   If @Opcode = 12
  BEGIN
  If exists (select InvoiceNo from PurchaseInvoiceMaster where InvoiceNo=@InvoiceNo)  
	Begin
		Set @isException=1
		Set @exceptionMessage='Invoice no. already exists!'
	End 
	ELSE
	BEGIN
  BEGIN TRY
  BEGIN TRAN
        insert into PurchaseInvoiceMaster(PoAutoId,InvoiceNo,PoNumber,InvoiceDate,Remark,CreatedDate,UpdateDate,CreatedBy,UpdatedBy,VendorAutoId,BatchNo,StoreId)
        values(@PoAutoId,@InvoiceNo,@PoNumber,@PurchageDate,@Remark,GETDATE(),GETDATE(),@Who,@Who,@VendorAutoId,@BatchNo,@StoreId)
       
        set @InvoiceId=(SELECT SCOPE_IDENTITY())
        
        insert into PurchaseItemMaster(InvoiceId,TaxType,ProductId,Packingid,ReceivedQty,UnitPrice,Taxper,createddate,ProductUnitPrice,SecUnitPrice,StoreId,VendorProductCode)
        select @InvoiceId,@SaleInvoice,ProductId,Packingid,ReceivedQty,UnitPrice,Taxper,GETDATE(),ProductUnitPrice,SecUnitPrice,@StoreId,VendorProductCode from @DT_InvoiceItem
        
        Insert into InventoryMaster (ProductAutoId, PackingAutoId, UnitPrice, Quantity,InvoiceId,StoreId)
        select ProductId,Packingid,UnitPrice,ReceivedQty,@InvoiceId,@StoreId from @DT_InvoiceItem

		Declare @count int=null

		select t.ProductId,sum(PUD.NoOfPieces*t.ReceivedQty) as productQty,ROW_NUMBER() over(order by t.ProductId desc)as RowNumber into #Temp211 from @DT_InvoiceItem t
		inner Join ProductUnitDetail PUD on PUD.AutoId=t.Packingid
		group by t.ProductId
		
		set @count=(select COUNT(*) from #Temp211)		
		
		while(@count >= 1)
		Begin 
		Declare @InstockQty1 int=0
		set @InstockQty1=isnull((select InstockQty from StoreWiseProductList where StoreId=@StoreId and ProductId=(select ProductId from #Temp211 where @count=RowNumber)),0)
		if exists (select * from ManageStockMaster where ProductId in (select ProductId from #Temp211 where @count=RowNumber) and StoreId=@StoreId)
		Begin	
			insert into ManageStockMasterLog(ProductId,StockQTY,CreatedBy,CreatedDate,CreatedByStore,IsDeleted,PreviousStock,MSMAutoId,InvoiceId)
			select t.ProductId,t.productQty,@Who,GETDATE(),@StoreId,0, @InstockQty1,MS.AutoId,@InvoiceId 
			from #Temp211 t Inner join ManageStockMaster MS on t.ProductId=MS.ProductId and MS.StoreId=@StoreId
			where @count=RowNumber

			Update ManageStockMaster set UpdateDate=GETDATE(), StockQty=StockQty+(select productQty from #Temp211 where @count=RowNumber) 
			where ProductId=(select ProductId from #Temp211 where @count=RowNumber)  and StoreId=@StoreId

			Update StoreWiseProductList set InstockQty=InstockQty+(select productQty from #Temp211 where @count=RowNumber) 
			where ProductId=(select ProductId from #Temp211 where @count=RowNumber) and StoreId=@StoreId
		End
		Else
		Begin
			insert into ManageStockMaster( ProductId, BatchNo, StockQty, AlertQty, CreatedBy, CreatedDate, CreatedByStoreId, Status, IsDeleted,StoreId)
			select ProductId,'',productQty,'',@Who,GETDATE(),@StoreId,1,0,@StoreId from #Temp211 t where @count=RowNumber

			Declare @MSMAutoId1 int=null
			set @MSMAutoId1=(SELECT SCOPE_IDENTITY())

			insert into ManageStockMasterLog(ProductId,StockQTY,CreatedBy,CreatedDate,CreatedByStore,IsDeleted,PreviousStock,MSMAutoId,InvoiceId)
			select t.ProductId, t.productQty,@Who,GETDATE(),@StoreId,0,@InstockQty1,@MSMAutoId1,@InvoiceId
			from #Temp211 t Inner join ManageStockMaster MS on t.ProductId=MS.ProductId and MS.StoreId=@StoreId
			where @count=RowNumber

			Update StoreWiseProductList set InstockQty=InstockQty+(select productQty from #Temp211 where @count=RowNumber) 
			where ProductId=(select ProductId from #Temp211 where @count=RowNumber) and StoreId=@StoreId
		End	
		set @count=(@count-1)
        END 
       
   COMMIT TRANSACTION    
   END TRY                                                                                                                                      
   BEGIN CATCH                                                                                                                                
   ROLLBACK TRAN                                                                                                                        
           Set @isException=1                                                                                                  
           Set @exceptionMessage=ERROR_MESSAGE()                                                                    
    End Catch      
   END
   END
   If @Opcode = 21
   BEGIN
    If exists (select InvoiceNo from PurchaseInvoiceMaster where InvoiceNo=@InvoiceNo and AutoId!=@InvoiceId)  
	Begin
		Set @isException=1
		Set @exceptionMessage='Invoice no. already exists!'
	End 
	ELSE
	BEGIN
    BEGIN TRY
   BEGIN TRAN

          update PurchaseInvoiceMaster set InvoiceNo=@InvoiceNo,InvoiceDate=@PurchageDate,Remark=@Remark,UpdateDate=GETDATE() where AutoId=@InvoiceId 

          delete from PurchaseItemMaster  where InvoiceId=@InvoiceId
          
		  delete from InventoryMaster where InvoiceId=@InvoiceId

          insert into PurchaseItemMaster(InvoiceId,TaxType,ProductId,Packingid,ReceivedQty,UnitPrice,Taxper,createddate,ProductUnitPrice,SecUnitPrice,StoreId,VendorProductCode)
          select @InvoiceId,@SaleInvoice,ProductId,Packingid,ReceivedQty,UnitPrice,Taxper,GETDATE(),ProductUnitPrice,SecUnitPrice,@StoreId,VendorProductCode from @DT_InvoiceItem
          
		  if((select PoNumber from PurchaseInvoiceMaster where AutoId=@InvoiceId)!='Direct Invoice')
		  begin
		       
		       select @PoAutoId=PoAutoId from PurchaseInvoiceMaster where AutoId=@InvoiceId

			   select ProductId,Packingid,PM.PoAutoId,sum(ReceivedQty)as ReceivedQty into #temp12 
			   from PurchaseItemMaster PIM
               inner join PurchaseInvoiceMaster PM on PM.Autoid=PIM.InvoiceId
               where PM.PoAutoId=@PoAutoId
               group by ProductId,Packingid,PoAutoId

			   update PM set PM.RequiredQty=(case when isnull(t.ReceivedQty,0)>isnull(PM.RequiredQty,0) then t.ReceivedQty else PM.RequiredQty end)
			   from PoItemMaster PM
			   inner join #temp12 t on t.ProductId=PM.ProductId and t.Packingid=PM.PackingId
			   where PM.PoAutoId=@PoAutoId

		  end
          Insert into InventoryMaster (ProductAutoId, PackingAutoId, UnitPrice, Quantity,InvoiceId,StoreId)
          select ProductId,Packingid,UnitPrice,ReceivedQty,@InvoiceId,@StoreId from @DT_InvoiceItem
        
    COMMIT TRANSACTION    
    END TRY                                                                                                                                      
    BEGIN CATCH                                                                                                                                
    ROLLBACK TRAN                                                                                                                        
         Set @isException=1                                                                                                  
         Set @exceptionMessage=ERROR_MESSAGE()                                                                    
         End Catch      
    END
    END
	If @Opcode =31
   BEGIN
    BEGIN TRY
   BEGIN TRAN
          delete from  PurchaseInvoiceMaster  where AutoId=@InvoiceId  
		  
          delete from PurchaseItemMaster  where InvoiceId=@InvoiceId

    COMMIT TRANSACTION    
    END TRY                                                                                                                                      
    BEGIN CATCH                                                                                                                                
    ROLLBACK TRAN                                                                                                                        
         Set @isException=1                                                                                                  
         Set @exceptionMessage=ERROR_MESSAGE()                                                                    
         End Catch      
    END
	If @Opcode =32
   BEGIN
    BEGIN TRY
   BEGIN TRAN
		  
          delete from PurchaseItemMaster  where AutoId=@InvoiceItemId

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
	       select  AutoId,VendorName from VendorMaster

           select AutoId,PoNumber,convert(varchar(10),PoDate,101) as PoDate,VendorId,Remark,Status from PoMaster where AutoId=@PoAutoId
           
           select PIM.PoNumber, isnull(sum(PUIM.ReceivedQty),0) as ReceivedQty , PUIM.Packingid, PUIM.ProductId
           into #temp
           from PurchaseInvoiceMaster as PIM
           inner join PurchaseItemMaster as PUIM on PUIM.InvoiceId=PIM.AutoId
           where PIM.PoAutoId=@PoAutoId
           group by PIM.PoNumber,PUIM.Packingid, PUIM.ProductId
           
     --      Select PIM.ProductId, pm.ProductName, PIM.PackingId, ptm.PackingName, PIM.RequiredQty,
		   --ptm.CostPrice, tm.AutoId, 
		   --case when ptm.TaxAutoId=0 then 0 else tm.TaxPer end as TaxPer,
     --      isnull((Select isnull(ReceivedQty,0) from #temp where Packingid=PIM.PackingId and ProductId=PIM.ProductId),0)as PartialReceivedQty,
     --      isnull((PIM.RequiredQty-(Select isnull(ReceivedQty,0) from #temp where Packingid=PIM.PackingId and ProductId=PIM.ProductId)),0)as RemainingQty
     --      from PoItemMaster as PIM
     --      inner join ProductMaster pm on pm.AutoId=PIM.ProductId
     --      inner join ProductUnitDetail ptm on ptm.AutoId=PIM.PackingId
     --      left join TaxMaster tm on tm.AutoId=ptm.TaxAutoId
     --      where PIM.PoAutoId=@PoAutoId

	       Select PIM.ProductId, pm.ProductName, PIM.PackingId, ptm.PackingName, PIM.RequiredQty,
		   ptm.CostPrice, tm.AutoId, 
		   case when ptm.TaxAutoId=0 then 0 else tm.TaxPer end as TaxPer,
           isnull((Select isnull(ReceivedQty,0) from #temp where Packingid=PIM.PackingId and ProductId=PIM.ProductId),0)as PartialReceivedQty,
           isnull((PIM.RequiredQty-
		   isnull((Select isnull(ReceivedQty,0) from #temp where Packingid=PIM.PackingId and ProductId=PIM.ProductId),0)
		   ),0)as RemainingQty,UnitPrice,SecUnitPrice,VendorProductCode
           from PoItemMaster as PIM
           inner join ProductMaster pm on pm.AutoId=PIM.ProductId
           inner join ProductUnitDetail ptm on ptm.AutoId=PIM.PackingId
           left join TaxMaster tm on tm.AutoId=ptm.TaxAutoId
           where PIM.PoAutoId=@PoAutoId

           
   END
   if @Opcode=42
   BEGIN
        select  VendorId,VendorName from VendorMaster
   END
   if @Opcode=43
   BEGIN
        select POM.AutoId as PoAutoId, PIM.AutoId, PIM.InvoiceNo, vm.VendorName, PIM.Remark, convert(varchar(10),PIM.CreatedDate,101) as CreatedDate
        from PurchaseInvoiceMaster as PIM
        inner join poMaster POM on POM.AutoId=PIM.PoNumber
        inner join VendorMaster vm on vm.VendorId=POM.VendorId
        where (@InvoiceNo is null or @InvoiceNo=''  or PIM.InvoiceNo like'%'+ @InvoiceNo +'%')
         and(@Vendor is null or @Vendor='' or VM.VendorName like '%'+ @Vendor+'%')
   END
   if @Opcode=44
   BEGIN

           select pom.Ponumber,pom.VendorId,pom.Remark,pom.PoDate,pom.Status,PIM.AutoId,PIM.InvoiceNo,convert (varchar(10),PIM.CreatedDate,101) as ReceivedDate,PIM.Remark as InRemark
           from PurchaseInvoiceMaster as PIM
           inner join poMaster POM on POM.AutoId=PIM.PoNumber
           where PIM.AutoId=@InvoiceId 
           
           select PIM.PoNumber, isnull(sum(PUIM.ReceivedQty),0) as ReceivedQty , PUIM.Packingid, PUIM.ProductId
           into #temp1
           from PurchaseInvoiceMaster as PIM
           inner join PurchaseItemMaster as PUIM on PUIM.InvoiceId!=PIM.AutoId
           where PIM.PoNumber=@PoAutoId and PUIM.InvoiceId!=@InvoiceId
           group by PIM.PoNumber,PUIM.Packingid, PUIM.ProductId
           
           select PUIM.ProductId,pm.ProductName, PUIM.Packingid,POIM2.RequiredQty,ptm.PackingName,PUIM.ReceivedQty,PUIM.UnitPrice,PUIM.TaxPer,Total,Tax,
           (Select isnull(ReceivedQty,0) from #temp1 where Packingid=PUIM.PackingId and ProductId=PUIM.ProductId)as PartialReceivedQty,
           (POIM2.RequiredQty-((Select isnull(ReceivedQty,0) from #temp1 where Packingid=PUIM.PackingId and ProductId=PUIM.ProductId)+PUIM.ReceivedQty))as RemainingQty
           from PurchaseInvoiceMaster as PIM
           inner join PurchaseItemMaster as PUIM on PUIM.InvoiceId=PIM.AutoId
           inner join ProductUnitDetail ptm on ptm.AutoId=PUIM.PackingId
           inner join ProductMaster pm on pm.AutoId=PUIM.ProductId
           inner join PoMaster POM1 on POM1.AutoId=PIM.PoNumber
           inner join PoItemMaster POIM2 on POIM2.PoAutoId=POM1.AutoId and POIM2.PackingId=PUIM.PackingId
           where  PIM.AutoId=@InvoiceId
   END
    if @Opcode=45
   BEGIN
       select ROW_NUMBER() over(order by PIM.AutoId desc) RowNumber,
	   PIM.AutoId, InvoiceNo, PoNumber, format(InvoiceDate, 'MM/dd/yyyy')InvoiceDate, Remark, PoAutoId,VM.VendorName,
	   (UM.FirstName+' '+ISNULL(UM.LastName,'')+'<br/>'+format(PIM.CreatedDate,'MM/dd/yyyy hh:mm tt'))as CreationDetails,
	   (UM.FirstName+' '+ISNULL(UM.LastName,'')+'<br/>'+format(PIM.UpdateDate,'MM/dd/yyyy hh:mm tt'))as UpdationDetails,PIM.BatchNo
	   into #TempInvoice
	   from PurchaseInvoiceMaster PIM
	   left join VendorMaster VM on VM.AutoId=isnull(PIM.VendorAutoId,0)
	   left join UserDetailMaster UM on UM.UserAutoId=PIM.CreatedBy
       left join UserDetailMaster UM1 on UM1.UserAutoId=PIM.UpdatedBy  
	   where PIM.StoreId=@StoreId
	   and (@VendorAutoId is null or @VendorAutoId=0 or VM.AutoId=@VendorAutoId)
	   and(@InvoiceNo is null or @InvoiceNo='' or InvoiceNo like '%'+@InvoiceNo+'%')
	   and(@PoNumber is null or @PoNumber='' or PoNumber like '%'+@PoNumber+'%')
	   order by PIM.AutoId desc

	   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By:Puchase Date Desc' as SortByString 
	   FROM #TempInvoice      
             
       Select  * from #TempInvoice t      
       WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
       order by AutoId desc
   END
    if @Opcode=46
   BEGIN
       select PIM.AutoId,PIM.InvoiceId,PIM.ProductId,PM.ProductName,PackingId,UnitPrice,PUD.PackingName,ReceivedQty,
	   format(PIM.CreatedDate,'MM/dd/yyyy hh:mm tt')as CreatedDate
	   from PurchaseItemMaster PIM
	   inner join ProductMaster PM on PM.AutoId=PIM.ProductId
	   inner join ProductUnitDetail PUD on PUD.AutoId=PIM.PackingId
	   where PIM.InvoiceId=@InvoiceId
	   order by AutoId
   END
   if @Opcode=47
   BEGIN
       select AutoId as InvoiceId, InvoiceNo, PoNumber, format(InvoiceDate,'MM/dd/yyyy')InvoiceDate, Remark, CreatedDate, UpdateDate, PoAutoId, CreatedBy, UpdatedBy, VendorAutoId
	   from PurchaseInvoiceMaster
	   where Autoid=@InvoiceId

	   select PIM.AutoId, InvoiceId, PIM.ProductId, ProductName,Packingid,PackingName, UnitPrice, PIM.createddate, ReceivedQty, TaxType, PIM.TaxPer,Tax, Total,isnull(PUD.SellingPrice,0) as ProductUnitPrice,isnull(PUD.SecondaryUnitPrice,0) as SecUnitPrice
	   ,VendorProductCode,isnull(PUD.CostPrice,0) as CostPrice
	   from PurchaseItemMaster PIM
	   inner join ProductMaster PM on Pm.AutoId=PIM.ProductId
	   inner join ProductUnitDetail PUD on PUD.AutoId=PIM.Packingid
	   where InvoiceId=@InvoiceId
   END
   if @Opcode=48
   BEGIN
       select PIM.AutoId,PIM.InvoiceId,PIM.ProductId,PM.ProductSizeName ProductName,PackingId,UnitPrice,PUD.PackingName,ReceivedQty,isnull(PUD.SellingPrice,0) as ProductUnitPrice,
	   isnull(PUD.SecondaryUnitPrice,0) as SecUnitPrice,isnull(PUD.CostPrice,0) as CostPrice,Tax, Total,
	   format(PIM.CreatedDate,'MM/dd/yyyy hh:mm tt')as CreatedDate
	   from PurchaseItemMaster PIM
	   inner join ProductMaster PM on PM.AutoId=PIM.ProductId
	   inner join ProductUnitDetail PUD on PUD.AutoId=PIM.PackingId
	   where PIM.InvoiceId=@InvoiceId
	   order by AutoId
   END
   if @Opcode=49
   BEGIN
		Select ML.AutoId, PM.ProductSizeName as ProductName,ML.StockQTY as PurchaseStock, ML.PreviousStock as PreviousStock,(ML.StockQTY + ML.PreviousStock) as EffectedStock ,ML.InvoiceId from ManageStockMasterLog ML 
		Inner join ProductMaster PM on PM.AutoId=ML.ProductId
		Inner join StoreWiseProductList Sl on Sl.ProductId=PM.AutoId and Sl.StoreId=@StoreId
		where ML.InvoiceId=@InvoiceId and ML.CreatedByStore=@StoreId
		order by ML.AutoId 
   END
   END TRY
    BEGIN CATCH
         SET @isException=1
         SET @exceptionMessage=ERROR_MESSAGE()
   END CATCH
   End
GO
