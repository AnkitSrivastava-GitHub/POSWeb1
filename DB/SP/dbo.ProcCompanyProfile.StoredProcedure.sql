
Alter   PROCEDURE [dbo].[ProcCompanyProfile]
@Opcode int =NULL,
@AutoId int=NULL,
@CompanyId varchar(50) =NULL,
@CompanyName varchar(100)=NULL,
@ContactName varchar(100)=NULL,
@BillingAddress varchar(max)=NULL,
@Country varchar(100)=NULL,
@State varchaR(100)=NULL,
@City varchar(200)=NULL,
@CurrencyId int=null,
@AllowLottoSale int=null,
@ZipCode varchar(50) =NULL,
@EmailId varchar(100)=NULL,
@Website varchar(100)=NULL,
@TeliPhoneNo varchar(20) =NULL,
@PhoneNo varchar(20) =NULL,
@FaxNo varchar(20) =NULL,
@VatNo varchar(20) =NULL,
@CDiscription varchar(max)=NULL,
@SaleInvoice varchar(50)=NULL,
@PrinterName varchar(100)=NULL,
@CLogo varchar(200)=NULL,
@ClogoReport int =NULL,
@Clogoprint int =NULL,
@Inventory int =NULL,
@Verification int =NULL,
@Who int=null,
@StoreId int=null,
@TerminalId int =NULL,
@UseCreditCard varchar(20) =NULL,
@CardSettlement varchar(20) =NULL,
@SettlementTime varchar(20) =NULL,
@status int=null,
@ProductStatus int=null,
@UserName varchar(50) =NULL,
@Password varchar(250) =NULL,
@SubscriptionDays int=null, 
@SerialKey varchar(50) =NULL,
@CompanyKey varchar(50) =NULL,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
AS
BEGIN
BEGIN TRY
	 Set @isException=0                                      
  Set @exceptionMessage='Success'    
If @Opcode = 11
begin
if not exists(select CompanyName from CompanyProfile where CompanyName=@CompanyName)
BEGIN
     BEGIN TRY
     BEGIN TRAN 
            SET @CompanyId = (SELECT DBO.SequenceCodeGenerator('CompanyId'))  
            insert into CompanyProfile(CompanyId,CompanyName,ContactName,BillingAddress,Country,State,City,ZipCode,EmailId,Website,TeliPhoneNo,
            PhoneNo,FaxNo,VatNo,CDiscription,SaleInvoice,CLogo,ClogoReport,Clogoprint,Status,CurrencyId,AllowLotterySale)
            values(@CompanyId,@CompanyName,@ContactName,@BillingAddress,@Country,@State,@City,@ZipCode,@EmailId,@Website,@TeliPhoneNo,
            @PhoneNo,@FaxNo,@VatNo,@CDiscription,@SaleInvoice,@CLogo,@ClogoReport,@Clogoprint,@status,@CurrencyId,@AllowLottoSale)

			set @CompanyId=SCOPE_IDENTITY()

			insert into InvoicePrintDetails (StoreName,ContactPersone,BillingAddress,City,State,Country,ZipCode,WebSite,EmailId,MobileNo,ShowHappyPoints,ShowFooter,Footer,StoreId,ShowLogo)
			values(@CompanyName,@ContactName,@BillingAddress,@City,@State,@Country,@ZipCode,@Website,@EmailId,@PhoneNo,1,1,'Thank You',@CompanyId,1)

			insert into CustomerMaster( CustomerId, FirstName, LastName, DOB, MobileNo, PhoneNo, EmailId, Address, State, City, Country, ZipCode, Status, StoreId,SeqNo)
			values('','Walk In','','','','','','','','','','',1,@CompanyId,1)

			insert into ScreenMaster (Name,	Status,	DefaultScreen,StoreId)
            values('Home Screen',	1,	1,	@CompanyId),('Lottery',	1,	1,	@CompanyId)

			insert into RoyaltyMaster( AmtPerRoyaltyPoint, MinOrderAmt, CreatedBy, CreatedDate, Status, StoreId)
			values(	1,	1,	@Who,	getdate(),	1	,@CompanyId)

			insert into AmountWiseRoyaltyPointMaster( RoyaltyPoint, Amount, CreatedBy, CreatedDate, Status, MinOrderAmt, StoreId)
			values(1,1,@Who,GETDATE(),1,10,@CompanyId)

			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CompanyId'  

			declare @TempStoreId int
			set @TempStoreId=(select top 1 AutoId from CompanyProfile order by AutoId asc)

			insert into StoreWiseProductList( StoreId, ProductId, IsFavourite, ManageStock, InstockQty, AlertQty, CreatedBy, CreatedDate, IsDeleted, CreatedByStoreId,  Status1,  TaxId, WebAvailibilty,MasterInsertId)
			select  @CompanyId,ProductId, IsFavourite, ManageStock, 0, 0,@Who , GETDATE(), IsDeleted, @StoreId,  (case when (select ProductName from ProductMaster where AutoId=SPL.ProductId) like '%Lottery%' then 1 else 0 end),  TaxId, WebAvailibilty,MasterInsertId from StoreWiseProductList SPL where StoreId=@TempStoreId
			
			insert into VendorProductCodeList(ProductId,StoreId,ProductStoreId,VendorId,VendorProductCode,OtherVPC,CreatedBy,CreatedDate,CreatedByStoreId,Status,MasterInsertId)
			select ProductId,@CompanyId,(select AutoId from StoreWiseProductList where ProductId=t.ProductId and StoreId=@CompanyId),VendorId,VendorProductCode,
			OtherVPC,@Who,GETDATE(),@StoreId,Status,MasterInsertId from  VendorProductCodeList t where StoreId=@TempStoreId

			insert into ProductUnitDetail([ProductId], StoreProductId,[PackingName], [Barcode], [CostPrice], [SellingPrice], [TaxAutoId], [ManageStock], [AvailableQty], [AlertQty], [Status],NoOfPieces,SizeOfSinglePiece,IsShowOnWeb,SecondaryUnitPrice,ImageName,StoreId,CreatedByStoreId,IsDeleted,CreatedBy,CreatedDate,MasterInsertId)
			select [ProductId], (select AutoId from StoreWiseProductList where ProductId=t.ProductId and StoreId=@CompanyId),[PackingName], [Barcode], [CostPrice], [SellingPrice], [TaxAutoId], [ManageStock], 0, 0,  1 ,NoOfPieces,SizeOfSinglePiece,IsShowOnWeb,SecondaryUnitPrice,ImageName,@CompanyId,@StoreId,IsDeleted,@Who,
			getdate(),MasterInsertId from ProductUnitDetail t where StoreId=@TempStoreId

			declare @j int=1,@Count1 int=0,@SKUId varchar(10),@NewSKUAutoId int,@NewStoreProductId int;

			select ROW_NUMBER() over(order by SM.AutoId asc) RowNo,[SKUId],SM.StoreProductId, [SKUName],PackingName, [Description],
			SM.[Status], [SKUType], SM.[ProductId], [Favorite], [UpdatedBy],
			SM.[IsDeleted], [APIStatus],SKUImagePath,StoreId,
			(select AutoId from ProductUnitDetail where ProductId=SIM.ProductId and StoreId=@CompanyId and PackingName=SM.PackingName)[ProductUnitAutoId],
			--SIM.[ProductUnitAutoId], 
			SIM.[Quantity], SIM.[UnitPrice], SIM.[Discount],SM.MasterInsertId
			into #TempSKUList
			from SKUMaster SM
            inner join SKUItemMaster SIM on SIM.SKUAutoId=SM.AutoId and SIM.ProductId=SM.ProductId
            where StoreId=@TempStoreId and  SM.ProductId!=0
			order by SM.AutoId asc

			
			set @Count1=(select COunt(1) from #TempSKUList)

			while(@j<=@Count1)
			begin

			    Set @SKUId = (SELECT DBO.SequenceCodeGenerator('SKU'))  
				Set @NewStoreProductId=(select AutoId from StoreWiseProductList where ProductId=(select ProductId from #TempSKUList t where t.RowNo=@j) and StoreId=@CompanyId)
			    
				insert into [dbo].[SKUMaster]([SKUId],StoreProductId, [SKUName],PackingName, [Description], [Status], [SKUType], [ProductId], [Favorite], [UpdatedBy], [UpdatedDate], [CreatedBy], [CreatedDate], [IsDeleted], [APIStatus],SKUImagePath,StoreId,CreatedByStoreId,MasterInsertId)
			    select @SKUId,@NewStoreProductId , [SKUName],PackingName, [Description], t.Status, [SKUType], [ProductId], [Favorite], @Who, GETDATE(), @Who, GETDATE(), [IsDeleted], [APIStatus],SKUImagePath,
			    @CompanyId,@StoreId,MasterInsertId from #TempSKUList t where t.RowNo=@j

				set @NewSKUAutoId=(SELECT SCOPE_IDENTITY())

		        UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='SKU'
				
				insert into [SKUItemMaster]([SKUAutoId], StoreProductId,[ProductId], [ProductUnitAutoId], [Quantity], [UnitPrice], [Discount],CreatedBy,CreatedDate,CreatedByStoreId,Status,IsDeleted,MasterInsertId)
		        select @NewSKUAutoId, @NewStoreProductId, ProductId,ProductUnitAutoId, Quantity, UnitPrice, 0,@Who,GETDATE(),@StoreId,1,0,MasterInsertId from #TempSKUList t where t.RowNo=@j
		      
			    select distinct Barcode into #TempBarcode 
				from BarcodeMaster 
				where StoreProductId=(select AutoId from StoreWiseProductList where ProductId=(select productId from #TempSKUList t where t.RowNo=@j) and StoreId=@TempStoreId) and StoreId=@TempStoreId

				insert into BarcodeMaster([SKUId],StoreProductId,StoreId,ProductUnitId,Barcode, [IsDefault],CreatedBy,[CreatedDate],CreatedByStoreId,UpdatedBy, [UpdatedDate], IsDeleted,MasterInsertId )
		        select @NewSKUAutoId,@NewStoreProductId,@CompanyId,(select ProductUnitAutoId from #TempSKUList  t where t.RowNo=@j),Barcode, 1,@Who , getdate(),@StoreId ,0 ,getdate(), 0,( select MasterInsertId from #TempSKUList t where t.RowNo=@j) from #TempBarcode 
				
				drop table #TempBarcode

				set @j=@j+1;
			end

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
Set @exceptionMessage='Store Name already exists!' 
END
end
--else If @Opcode = 12
--begin
--BEGIN TRY
--BEGIN TRAN 

----------------------------------clean Database-----------------------------------------------
--truncate table [dbo].[AuthorizedBathList]

--truncate table [dbo].[BalanceMaster]

----truncate table [dbo].[BarcodeMaster]

--truncate table [dbo].[CouponMaster]

--truncate table [dbo].[CustomerMaster]

--truncate table [dbo].[DraftItemMaster]

--truncate table [dbo].[DraftMaster]

--truncate table [dbo].[DraftSKUMaster]

--truncate table [dbo].[InventoryMaster]

--truncate table [dbo].[InvoiceItemMaster]

--truncate table [dbo].[InvoiceMaster]

--truncate table [dbo].[InvoiceSKUMaster]

--truncate table [dbo].[InvoiceTransactionDetail]

--truncate table [dbo].[NoSale]

--truncate table [dbo].[PaxResponseMessage]

--truncate table [dbo].[PaxSetting]

--truncate table [dbo].[PaymentGatewayMaster]

--truncate table [dbo].[PaymentMethod]

--truncate table [dbo].[PaymentResponseMessage]

--truncate table [dbo].[PoItemMaster]

--truncate table [dbo].[PoMaster]

--truncate table [dbo].[PurchaseInvoiceMaster]

--truncate table [dbo].[PurchaseItemMaster]

--truncate table [dbo].[SchemeItemMaster]

--truncate table [dbo].[SchemeMaster]

----truncate table [dbo].[SKUItemMaster]

----truncate table [dbo].[TaxMaster]

--truncate table [dbo].[UserLogInLogMaster]

--truncate table [dbo].[VendorMaster]

----delete from [dbo].[SKUMaster]

----delete from  PackingTypeMaster

----delete from  ProductMaster

----delete from  CategoryMaster

----delete from  BrandMaster

----delete from CompanyProfile

--truncate table [dbo].[TermConditionMaster]

--truncate table [dbo].[UserDetailMaster]

--update SequenceCodeGeneratorMaster set currentSequence=0

----declare @TaxId varchar(50)= (SELECT DBO.SequenceCodeGenerator('TaxId'))  		 	
----insert into TaxMaster(TaxId,TaxName,TaxPer, Status)
----values (@TaxId, 'No Tax', 0 , 1)
----UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='TaxId'  

--declare @CustomerId varchar(50)= (SELECT DBO.SequenceCodeGenerator('CustomerNo'))  		 	
--insert into CustomerMaster(CustomerId, FirstName, LastName, DOB, MobileNo, PhoneNo, EmailId, Address, State, City, Country, ZipCode, Status)
--values (@CustomerId, 'Walk In', '', '', '', '', '', '', '', '', '', '', 1)
--UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CustomerNo'

---------------------------------------------------------------------------------------
--update CompanyProfile set CompanyId=@CompanyId, CompanyName=@CompanyName, BillingAddress=@BillingAddress, Country=@Country, State=@State, City=@City, ZipCode=@ZipCode


----insert into CompanyProfile(CompanyId, CompanyName, BillingAddress ,Country, State, City, ZipCode,
----SaleInvoice, CLogo, ClogoReport, Clogoprint, Inventory, Verification, 
----[SerialKey], [CompanyKey], [SubscriptionStartDate], [SubscriptionEndDate])
----values(@CompanyId, @CompanyName, @BillingAddress, @Country, @State, @City, @ZipCode,
----'Excluding Tax', 0, 0, 0, 0, 1,
----@SerialKey, @CompanyKey, GETDATE(), DATEADD(day,@SubscriptionDays ,GETDATE()))
----UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CompanyId'  

--declare @Userid varchar(20)=(select dbo.SequenceCodeGenerator('Employee'))
--insert into UserDetailMaster (Userid, [Password], LoginID, UserType, FirstName, LastName)
--values(@Userid, @Password, @UserName, 'Admin', @CompanyName, '');
--update SequenceCodeGeneratorMaster set currentSequence=currentSequence+1 where SequenceCode='Employee'

--insert into [dbo].[SerialKeyMaster]([SerialKey], [UsedDate], [SubscriptionDays])
--values(@SerialKey, GETDATE(), @SubscriptionDays)

--COMMIT TRANSACTION
--END TRY                                                                                                                                      
--BEGIN CATCH                                                                                                                                
--ROLLBACK TRAN                                                                                                                         
--Set @isException=1                                                                                                   
--Set @exceptionMessage='Oops! Something went wrong.Please try later.'                                                                      
--End Catch    
--end
else If @Opcode = 21
begin
	if not exists(select CompanyName from CompanyProfile where CompanyName=@CompanyName and AutoId!=@AutoId)
	BEGIN
		begin try
			update  CompanyProfile set CompanyName=@CompanyName, ContactName=@ContactName, BillingAddress=@BillingAddress,
			Country=@Country, State=@State, City=@City, ZipCode=@ZipCode, EmailId=@EmailId, Website=@Website, CLogo=@CLogo,CurrencyId=@CurrencyId,
			TeliPhoneNo=@TeliPhoneNo, PhoneNo=@PhoneNo, FaxNo=@FaxNo, VatNo=@VatNo,Status=@status,AllowLotterySale=@AllowLottoSale --CDiscription=@CDiscription, 
			--SaleInvoice=@SaleInvoice, ClogoReport=@ClogoReport, Clogoprint=@Clogoprint, 
			--Inventory=@Inventory, [Verification]=@Verification, UseCreditCard=@UseCreditCard, 
			--CardSettlement=@CardSettlement, SettlementTime=@SettlementTime, PrinterName=@PrinterName
			where AutoId=@AutoId
		end try
		begin catch						
			SET @isException=1
			SET @exceptionMessage= ERROR_MESSAGE()
		end catch
			select AutoId as StoreId,CompanyName from CompanyProfile where AutoId=@AutoId
		End
	ELSE
		BEGIN
			Set @isException=1                                                                                                   
			Set @exceptionMessage='Store Name already exists!' 
		END
end
else If @Opcode = 41
begin
   --select top(1) * from CompanyProfile
 select top(1) [AutoId], [CompanyId], [CompanyName], [ContactName], [BillingAddress],
 [Country], [State], [City], [ZipCode], [EmailId], [Website], [TeliPhoneNo], [PhoneNo],
 [FaxNo], [VatNo], [CDiscription], [SaleInvoice], [CLogo], [ClogoReport], [Clogoprint],
 [Inventory], [Verification], [PrinterName], [UseCreditCard], [CardSettlement], [SettlementTime],[CurrencyId] as Currency,
 [SerialKey], [CompanyKey], [SubscriptionStartDate], [SubscriptionEndDate],[Status],AllowLotterySale from CompanyProfile where AutoId=@AutoId
end
else If @Opcode = 42
begin
select top(1) CompanyName + ' '+ (Select TerminalName from TerminalMaster where AutoId=@TerminalId) as CompanyName, [PrinterName]
as PrinterName
from CompanyProfile
end
IF @Opcode=43
  BEGIN
   SELECT ROW_NUMBER() over(order by CompanyName asc) as RowNumber,CP.AutoId,
 CompanyName, ContactName, BillingAddress,Country,State, City,ZipCode,EmailId,Website,TeliPhoneNo,PhoneNo,FaxNo,VatNo,CP.Status,CM.CurrencyName + ' - ' + CM.CurrencySymbol as Currency
 into #temp   
 FROM CompanyProfile  CP Inner join CurrencySymbolMaster CM on CM.AutoId=CP.CurrencyId
--where emp.Status!=2 
--searching
 where(@CompanyName is null or @CompanyName='' or CompanyName like '%'+@CompanyName+'%')  
 and(@ContactName is null or @ContactName='' or ContactName like '%'+@ContactName+'%')
 and(@PhoneNo is null or @PhoneNo='' or PhoneNo=@PhoneNo)
 --and(@TeliPhoneNo is null or @TeliPhoneNo='' or TeliPhoneNo like '%'+@TeliPhoneNo+'%')
 and(@Website is null or @Website='' or Website like '%'+@Website+'%')
  and(@status is null or @status=2 or CP.Status=@status)
   order by CompanyName asc	
     
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, '#Sort By: Store Name asc' as SortByString 
   FROM #temp  
  
   Select  * from #temp t  
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))   
  order by  CompanyName asc  
  END
IF @Opcode=31
begin 
   if((select count(1) from EmployeeStoreList where CompanyId=@AutoId and Status=1)>0)
   begin
        set @isException=1
		set @exceptionMessage='Store can''t be deleted because It is assigned to some users!'
   end
   else
   begin
       delete from  CompanyProfile where AutoId=@AutoId
  end
end
IF @Opcode=32
begin 
   select AutoId,concat(CurrencyName, ' - ', CurrencySymbol) as CurrencyName from CurrencySymbolMaster where Status=1
end
END TRY	
BEGIN CATCH
--ROLLBACK TRAN
SET @isException=1
SET @exceptionMessage= ERROR_MESSAGE()
END CATCH
END
GO
