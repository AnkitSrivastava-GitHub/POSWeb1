USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcGenerateInvoiceAPI]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create     proc [dbo].[ProcGenerateInvoiceAPI]
@Opcode int=Null,
@LoginId varchar(100)=null,
@AutoId int=null,
@OrderId int=null,
@InvoiceAutoId1 int=null,
@OrderNo varchar(20)=null,
@InvoiceNo1 varchar(20)=null,
@CustomerName varchar(50)=null,
@FromDate datetime=null,
@ToDate datetime=null,
@CoupanNo varchar(50)=null,
@CoupanAmt decimal(18,2)=null,
@CustomerId int=null,
@Discount decimal(18,2)=null,
@PaymentMethod varchar(50)=null,
@AccessToken varchar(50)=null,
@Hashkey varchar(50)=null,
@DeviceId varchar(100)=null,
@LatLong varchar(100)=null,
@AppVersion varchar(20)=null,
@RequestSource varchar(20)=null,
@URL varchar(200)=null,
@RecordCount INT =null,    
@PageIndex  INT =null,    
@PageSize INT =null,    
@isException bit out,  
@exceptionMessage varchar(max) out,
@responseCode varchar(10) out
as
begin
	BEGIN TRY  
	SET @isException=0  
	SET @exceptionMessage='Success'
	set @responseCode='200'
	if(@Opcode=11)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GenerateInvoiceAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  --if not exists(select * from [dbo].[API_LoginDetail] where [AutoId]=( Select SUBSTRING(@LoginId,0,CHARINDEX('@',@LoginId,0))))
	  --begin
		 --SET @isException=1  
         --SET @exceptionMessage='Invalid Login Id'
		 --SET @responseCode='301'
	  --end
	  else
	  begin

	     declare @InvoiceNo varchar(50),@InvoiceAutoId int,@TransactionId varchar(50)='',@TempInvoiceNo varchar(50)='',@AuthCode varchar(50)='',@BalanceAutoId int=null,@TerminalId int=null,@CardType varchar(50)=null,@CardNo varchar(50)=null,@PaidAmount decimal(18,2),
		 @SKUId int,@SchemeId int,@SKUAutoId int;

	     SET @InvoiceNo = (SELECT DBO.SequenceCodeGenerator('InvoiceNo'))  	
     	 insert into InvoiceMaster(InvoiceNo, InvoiceDate,[PaymentMethod], [TransactionId], [TempInvoiceNo],[AuthCode], [CustomerId],[Status],[UpdateDate],UpdateBy,[LogInId],[UserId], Discount, TerminalId, CardType, CardNo,CouponAmt,CreatedFrom,AppVersion)
     	 values (@InvoiceNo, GETDATE(), @PaymentMethod, @TransactionId, @TempInvoiceNo, @AuthCode,  @CustomerId, 1, GETDATE(),@AutoId, @BalanceAutoId, @AutoId, @Discount,@TerminalId, @CardType, @CardNo,@CoupanAmt,'App',@AppVersion)
     	 set @InvoiceAutoId=(SELECT SCOPE_IDENTITY())
    	 
     	 Insert into InvoiceTransactionDetail( InvoiceAutoId, TransactionId, AuthCode, PaymentMode, CreatedDate, CreatedBy, TempInvoiceNo, CardType, CardNo)
     	 values(@InvoiceAutoId, @TransactionId, @AuthCode, @PaymentMethod, GETDATE(), @AutoId, @TempInvoiceNo, @CardType, @CardNo) 
     	 
     	 if(@PaymentMethod='Cash')
     	 begin
     	     Update BalanceMaster set [ActualBalance]=ActualBalance+@PaidAmount where AutoId=@BalanceAutoId
     	 end	
     	  
     	 declare @i int=1, @row int=0;
     	 Select ROW_NUMBER() over (order by SKUId desc) as RowNumber, * into #temp1 from CartItemList where OrderNo=@OrderNo
     	 Set @row=(Select COUNT(1) from #temp1)
     	 
     	 While(@row>=@i)
     	 begin
     	      insert into InvoiceSKUMaster( InvoiceAutoId, SKUId, SchemeId, Quantity)
     	      Select @InvoiceAutoId, SKUId, SchemeId , Quantity from #temp1 where RowNumber=@i
     	      
     	      Set @SKUId=(Select SKUId from #temp1 where RowNumber=@i)
			  set @SchemeId=(Select SchemeId from #temp1 where RowNumber=@i)
     	      set @SKUAutoId=(SELECT SCOPE_IDENTITY())
     	      if(@SchemeId!=0)
			  begin
			      insert into InvoiceItemMaster(SKUAutoId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer)
     	          Select @SKUAutoId, dt.ProductAutoId, dt.PackingAutoId, dt.Quantity, dt.UnitPrice, dt.Tax, dt.Total, isnull(tm.TaxPer,0)
     	          from SchemeItemMaster as dt 
     	          inner join ProductUnitDetail as pm on (pm.AutoId=dt.PackingAutoId)
     	          left join TaxMaster as tm on (tm.AutoId=pm.TaxAutoId)
     	          where dt.SchemeAutoId=@SchemeId
			  end
			  else
			  begin
			      insert into InvoiceItemMaster(SKUAutoId, ProductId, PackingId, Quantity, UnitPrice, Tax, Total, TaxPer)
     	          Select @SKUAutoId, dt.ProductAutoId, dt.ProductUnitAutoId, dt.Quantity, dt.UnitPrice, dt.Tax, dt.SKUItemTotal, isnull(tm.TaxPer,0)
     	          from SKUItemMaster as dt 
     	          inner join ProductUnitDetail as pm on (pm.AutoId=dt.ProductUnitAutoId)
     	          left join TaxMaster as tm on (tm.AutoId=pm.TaxAutoId)
     	          where dt.SKUAutoId=@SKUId
			  end
     	      set @i=@i+1
     	 end
     	
     	 --Delete from DraftMaster where [AutoId]=@DraftAutoId
     	 --Delete from DraftSKUMaster where DraftAutoId=@DraftAutoId
     	 --Delete from DraftItemMaster where DraftAutoId=@DraftAutoId
     
     	 UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='InvoiceNo'  
		 
		 --Select @InvoiceAutoId as InvoiceAutoId

		 select isnull((Select InvoiceNo, format(InvoiceDate, 'MM/dd/yyyy hh:mm tt') as InvoiceDate, PaymentMethod,
		 convert(decimal(18,2),Tax)Tax, --TransactionId,
     	 cm.FirstName+' '+cm.LastName as CustomerName, 
		 case when IM.Status=1 then 'Active' when IM.Status=0 then 'Closed' else 'Closed' end Status,
		 format(im.UpdateDate, 'MM/dd/yyyy hh:mm tt') as UpdateDate, convert(decimal(18,2),(isnull((Total-Tax),0)))as SubTotal,
     	 udm.FirstName+' '+udm.LastName as SoldBy,
		 convert(decimal(18,2),isnull(im.Discount,0))Discount, convert(decimal(18,2),isnull(im.Total,0))Total, 
		 --convert(decimal(18,2),isnull(im.TerminalId,''))TerminalId,
		 --isnull(im.CardType,'')CardType, isnull(im.CardNo,'')CardNo,
		 isnull(Coupon,'')Coupon,
		 convert(decimal(18,2),isnull(CouponAmt,0))CouponAmt,
		 (select top 1 CompanyName from CompanyProfile)CompanyName,
		 (select top 1 BillingAddress from CompanyProfile)BillingAddress,
		 (select top 1 City+', '+State+' - '+ ZipCode from CompanyProfile)Address2
		 --,isnull((Select iim.AutoId, SKUAutoId, pm.ProductName as ProductName, 
         --ptm.PackingName, iim.Quantity, iim.UnitPrice, iim.Tax, iim.Total, iim.TaxPer
         --from InvoiceItemMaster iim 
         --inner join ProductMaster pm on pm.AutoId=iim.ProductId
         --inner join ProductUnitDetail ptm on ptm.AutoId=iim.PackingId
         --where iim.SKUAutoId in (Select AutoId from InvoiceSKUMaster 
		 --where InvoiceAutoId=im.AutoId)for json path,INCLUDE_NULL_VALUES),'[]')as InvoiceProductList
		 from InvoiceMaster IM
     	 left join CustomerMaster cm on cm.AutoId=IM.CustomerId
     	 left join UserDetailMaster udm on udm.UserAutoId=IM.UserId
     	 where im.AutoId=@InvoiceAutoId for json path,INCLUDE_NULL_VALUES),'[]') as InvoiceDetail,
		 isnull((select SM.SKUName, isnull(SCM.SchemeName,'')SchemeName,
		 cast((case when isnull(ism.SchemeId,0)!=0 then SCM.UnitPrice else SM.SKUSubTotal end) as decimal(18,2))as Price,
		 ISM.Quantity, convert(decimal(18,2),(isnull(ISM.Tax,0)))Tax, convert(decimal(18,2),isnull(Total,0)) Total
		 from InvoiceSKUMaster ISM 
		 inner join SKUMaster SM on sm.AutoId=ism.SKUId
		 left join SchemeMaster SCM on SCM.AutoId=ISM.SchemeId
		 where ISM.InvoiceAutoId=@InvoiceAutoId
		 for json path,INCLUDE_NULL_VALUES),'[]')as InvoiceItemList 
		 for json path, INCLUDE_NULL_VALUES
	  end
	end
	if(@Opcode=41)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('InvoiceListAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF not EXISTS(SELECT * from InvoiceMaster where (@InvoiceNo1 is null or @InvoiceNo1='' or InvoiceNo=@InvoiceNo1))  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'No Invoice Found!'	
		SET @responseCode='301'
	  END
	  --if not exists(select * from [dbo].[API_LoginDetail] where [AutoId]=( Select SUBSTRING(@LoginId,0,CHARINDEX('@',@LoginId,0))))
	  --begin
		 --SET @isException=1  
         --SET @exceptionMessage='Invalid Login Id'
		 --SET @responseCode='301'
	  --end
	  else
	  begin
	       select ROW_NUMBER() over(order by IM.AutoId desc)RowNumber,IM.AutoId as InvoiceAutoId, InvoiceNo, format(InvoiceDate,'MM/dd/yyyy hh:mm tt')InvoiceDate, PaymentMethod, cast(Tax as decimal(18,2))Tax, 
	       CM.FirstName+isnull(' '+CM.LastName,'')CustomerName, 
		   case when IM.Status=1 then 'Active' when IM.Status=0 then 'Closed' else 'Closed' end Status,
	       isnull(UM.FirstName,'')+isnull(' '+UM.LastName,'')UpdatedBy
		   ,format(UpdateDate,'MM/dd/yyyy hh:mm tt')UpdatedDate, 
	       cast(Discount as decimal(18,2))Discount, cast(Total as decimal(18,2))Total, isnull(Coupon,'')Coupon, cast(CouponAmt as decimal(18,2))CouponAmt
	       into #Temp11
	       from InvoiceMaster IM
	       left join CustomerMaster CM on CM.AutoId=IM.CustomerId
	       left join UserDetailMaster UM on Um.UserAutoId=IM.UpdateBy
	       where (@CustomerName is null or @CustomerName='' or CM.FirstName+isnull(' '+CM.LastName,'') like '%'+@CustomerName+'%')
	       and (@InvoiceNo is null or @InvoiceNo='' or InvoiceNo like '%'+@InvoiceNo+'%')
	       and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or ( convert(date,InvoiceDate) between convert(date,@FromDate) and convert(date,@ToDate)))
	       
	       --SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By:Created date Desc' as SortByString
	       --FROM #Temp11     
	       
           select isnull((Select  * from #Temp11
           WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
           order by InvoiceAutoId desc for json path, include_null_values),'[]')InvoiceList
		   for json path, include_null_values
	  end
	end
	if(@Opcode=42)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('InvoiceListAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF not EXISTS(SELECT * from InvoiceMaster where AutoId=@InvoiceAutoId1)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'No Invoice Details Found!'	
		SET @responseCode='301'
	  END
	  --if not exists(select * from [dbo].[API_LoginDetail] where [AutoId]=( Select SUBSTRING(@LoginId,0,CHARINDEX('@',@LoginId,0))))
	  --begin
		 --SET @isException=1  
         --SET @exceptionMessage='Invalid Login Id'
		 --SET @responseCode='301'
	  --end
	  else
	  begin
	     select isnull((select SM.SKUName, isnull(SCM.SchemeName,'')SchemeName,
		 convert(decimal(18,2),(case when isnull(ism.SchemeId,0)!=0 then SCM.UnitPrice else SM.SKUSubTotal end))as Price,
		 ISM.Quantity, cast(ISM.Tax as decimal(18,2))Tax, cast(Total as decimal(18,2))Total
		 from InvoiceSKUMaster ISM 
		 inner join SKUMaster SM on sm.AutoId=ism.SKUId
		 left join SchemeMaster SCM on SCM.AutoId=ISM.SchemeId
		 where ISM.InvoiceAutoId=@InvoiceAutoId1
		 for json path, include_null_values),'[]')as InvoiceProductList,
		 isnull((Select InvoiceNo, format(InvoiceDate, 'MM/dd/yyyy hh:mm tt') as InvoiceDate, 
		 PaymentMethod, convert(decimal(18,2),Tax)Tax, 
     	 cm.FirstName+' '+cm.LastName as CustomerName,
		 case when IM.Status=1 then 'Active' when IM.Status=0 then 'Closed' else 'Closed' end Status, 
		 format(im.UpdateDate, 'MM/dd/yyyy hh:mm tt') as UpdateDate, 
		 convert(decimal(18,2),isnull((Total-Tax),0))as SubTotal,
     	 isnull(udm.FirstName,'')+' '+isnull(udm.LastName,'') as SoldBY, convert(decimal(18,2),im.Discount)Discount,
		 convert(decimal(18,2),im.Total)Total,
		 isnull(Coupon,'')Coupon,
		 convert(decimal(18,2),isnull(CouponAmt,0))CouponAmt
		 ,(select Count(1) from InvoiceSKUMaster ISM where ISM.InvoiceAutoId=IM.AutoId) as ItemCount
		 from InvoiceMaster IM
     	 left join CustomerMaster cm on cm.AutoId=IM.CustomerId
     	 left join UserDetailMaster udm on udm.UserAutoId=IM.UserId
     	 where im.AutoId=@InvoiceAutoId1
		 for json path, include_null_values),'[]')as InvoiceDetail
		 for json path, include_null_values 
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
