truncate table StoreLoginLog
truncate table CartMaster
truncate table CartSKUMaster
truncate table CartItemMaster
truncate table CartItemList
truncate table PurchaseInvoiceMaster
truncate table CartMaster
truncate table SKUItemMaster
truncate table tbl_SecurityPinMaster
truncate table ProductUnitDetail
truncate table ProductVariantTypeMaster
truncate table API_ActivityLog
--truncate table API_CredentialDetail
truncate table TerminalLoginLog
truncate table BalanceMaster
truncate table PayoutMaster
truncate table BarcodeMaster
truncate table SchemeItemMaster
truncate table CustomerMaster
truncate table DraftItemMaster
truncate table DraftMaster
truncate table DraftSKUMaster
truncate table InventoryMaster
truncate table InvoiceItemMaster
truncate table InvoiceMaster
truncate table InvoiceSKUMaster
truncate table InvoiceTransactionDetail
truncate table NoSale
truncate table ProductMaster
truncate table PoItemMaster
truncate table PoMaster
truncate table PurchaseItemMaster
truncate table SchemeMaster
truncate table SecurityCode
truncate table ProductVariantMaster
truncate table UserLogInLogMaster
truncate table VendorMaster
truncate table SKUMaster
truncate table TerminalMaster
truncate table CategoryMaster
truncate table CompanyProfile
truncate table  UserDetailMaster
truncate table  TaxMaster
truncate table AgeRestrictionMaster
truncate table CompanyProfile
truncate table DepartmentMaster
truncate table StoreWiseProductList
truncate table EmployeeStoreList
truncate table CouponMaster
truncate table GroupMaster
truncate table ProductGroupMaster
truncate table ManageStockMaster
truncate table VendorProductCodeList
truncate table BrandMaster
truncate table UserCurrencyRecord 
truncate table ProductScreenMaster
truncate table ScreenMaster
truncate table GiftCardSale
truncate table SafeCash
truncate table ClockInOut
truncate table ClockInOutLog
truncate table RoyaltyMaster
truncate table AmountWiseRoyaltyPointMaster
truncate table CustomerRoyaltyPoints
truncate table InvoicePrintDetails
truncate table ExpenseMaster
truncate table ManageStockMasterLog

            
--set code generator to 0
update SequenceCodeGeneratorMaster set currentSequence=0

set Identity_insert CompanyProfile on
insert Into CompanyProfile(AutoId,	CompanyId,	CompanyName,	ContactName,	BillingAddress,	Country,	State,	City,	ZipCode,	EmailId,	PhoneNo,SaleInvoice,CLogo,Status,CurrencyId,AllowLotterySale)
values(1,'CMP100001','Demo - POS',	'Mr.Nilay Patel',	'66 Middlesex Ave Suite 205','USA','NJ','Iselin','85555',	'uneel913@gmail.com','9794045884','Excluding Tax',	'logo.ico',1,(select top 1 Autoid from CurrencySymbolMaster),1)
set Identity_insert CompanyProfile off
update SequenceCodeGeneratorMaster set currentSequence=2 where SequenceCode='CompanyId'

insert into InvoicePrintDetails (StoreName,ContactPersone,BillingAddress,City,State,Country,ZipCode,WebSite,EmailId,MobileNo,ShowHappyPoints,ShowFooter,Footer,StoreId,ShowLogo)
values('Demo - POS','Mr.Nilay Patel','66 Middlesex Ave Suite 205','Iselin','NJ','USA','85555','','uneel913@gmail.com','9794045884',1,1,'Thank You',1,1)

--Assign a store to Admin

insert into EmployeeStoreList(EmployeeId,CompanyId,CreatedBy,CreatedDate,Status)
values(1,1,1,GETDATE(),1)

--User Master
set Identity_insert UserDetailMaster on
Insert into UserDetailMaster(Userid,Password,LoginID,FirstName,LastName,EmailID,PhoneNo,UserAutoId,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,UserType,Status,IsAppAllowed)
values('EMP100001','123','Admin','Nilay','Patel','uneel913@gmail.com','',1,1,GETDATE(),1,getdate(),1,1,1)
set Identity_insert UserDetailMaster off
update SequenceCodeGeneratorMaster set currentSequence=1 where SequenceCode='Employee'

--Tax Master
--select * from TaxMaster
set Identity_insert TaxMaster on
insert into TaxMaster	(AutoId,TaxId,	TaxName	,TaxPer,	Status,SeqNo)
values(1,'TAX100001','No Tax','0.000',1,1)
set Identity_insert TaxMaster off
update SequenceCodeGeneratorMaster set currentSequence=1 where SequenceCode='TaxId'

--Brand Master
--select * from BrandMaster
set Identity_insert BrandMaster on
insert into BrandMaster(AutoId,BrandId,BrandName,Status,APIStatus,UpdatedBy,UpdatedDate,CreatedBy,CreatedDate,IsDeleted,SeqNo)
values(1,'BRN100001', 'Other Brand',1,	1,	1,GETDATE(),1,GETDATE(),0,1)
set Identity_insert BrandMaster off
update SequenceCodeGeneratorMaster set currentSequence=1 where SequenceCode='BrandId'

--Category Master
--select * from CategoryMaster
set Identity_insert CategoryMaster on
insert into CategoryMaster(AutoId,Categoryid,CategoryName,Status,UpdatedBy,UpdatedDate,CreatedBy,CreatedDate,IsDeleted,APIStatus,SeqNo)
values(1,'CAT100001','Other Category',1,1,	GETDATE(),1,GETDATE(),0	,0,1)
set Identity_insert CategoryMaster off
update SequenceCodeGeneratorMaster set currentSequence=1 where SequenceCode='CategoryId'

--Customer Master
set Identity_insert CustomerMaster on
insert into CustomerMaster(AutoId,CustomerId,FirstName,LastName,DOB,MobileNo,PhoneNo,EmailId,Address,State,City,Country,ZipCode,Status,StoreId,TotalPurchase)
values(1,'C100001',	'Walk In','','','','','','','','','','',1,1,0)	
set Identity_insert CustomerMaster off
update SequenceCodeGeneratorMaster set currentSequence=1 where SequenceCode='CustomerNo'

--Age Restriction Master
--select * from AgeRestrictionMaster
set Identity_insert AgeRestrictionMaster on
insert into AgeRestrictionMaster(AutoId,	AgeRestrictionName,	Age,Status,SeqNo)
values(1,'No Age Restriction',0,1,1)
set Identity_insert AgeRestrictionMaster off

--clear vendor master 
--select * from VendorMaster
set Identity_Insert VendorMaster  on
insert into VendorMaster(AutoId,VendorId,VendorName,CreatedBy,CreatedDate,CompanyId,VendorCode,Status,SeqNo)
values(1,'VND100001','Other Vendor',1,GETDATE(),'','',1,1)
set Identity_Insert VendorMaster  off
update SequenceCodeGeneratorMaster set currentSequence=1 where SequenceCode='VendorId'

--Department Master
--select * from DepartmentMaster
set identity_insert DepartmentMaster on
insert into DepartmentMaster(AutoId, DepartmentId, DepartmentName, AgeRestrictionId, CreatedBy, CreatedDate, Status, IsDeleted,SeqNo)
values(1,'DPT100001','Other Department',1,1,GETDATE(),1,0,1)
set identity_insert DepartmentMaster off

--Reset Screen Master and Insert Default Screen
set Identity_insert ScreenMaster on
Insert into ScreenMaster(AutoId,Name,Status,DefaultScreen,StoreId)
values(1,'Home Screen',1,1,1),(2,'Lottery',1,1,1)
set Identity_insert ScreenMaster off

--Royalty Masters
insert into RoyaltyMaster( AmtPerRoyaltyPoint, MinOrderAmt, CreatedBy, CreatedDate, Status, StoreId)
values(	1,	1,	1,	getdate(),	1	,1)

insert into AmountWiseRoyaltyPointMaster( RoyaltyPoint, Amount, CreatedBy, CreatedDate, Status, MinOrderAmt, StoreId)
values(1,1,1,GETDATE(),1,10,1)