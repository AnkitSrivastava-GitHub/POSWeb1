Create or alter procedure [dbo].[ProcProductListAPI]
@Opcode int=Null,
@AccessToken varchar(50)=null,
@Hashkey varchar(50)=null,
@DeviceId varchar(100)=null,
@LatLong varchar(100)=null,
@SearchString varchar(200)=null,
@AppVersion varchar(20)=null,
@RequestSource varchar(20)=null,
@LoginId varchar(100)=null,
@URL varchar(200)=null,
@CategoryId int=null,
@ProductName varchar(200)=null,
@Fav int=null,
@BrandId  int=null,
@AutoId int=null,
@Quantity int=null,
@FirstName varchar(200)=null,
@LastName varchar(200)=null,
@DOB datetime=null,
@Address varchar(200)=null,
@State varchar(200)=null,
@City varchar(200)=null,
@ZipCode varchar(200)=null,
@CustomerId varchar(20)=null,
@Barcode varchar(100)=null,
@ProductId int=null,
@SKUAutoId int=null,
@Name varchar(100)=null,
@MobileNo varchar(20)=null,
@EmailId varchar(50)=null,
@PageIndex INT =  1,  
@PageSize INT = null,  
@RecordCount INT =null,    
@isException bit out,  
@exceptionMessage varchar(max) out,
@responseCode varchar(10) out
as
begin
	BEGIN TRY  
	SET @isException=0  
	SET @exceptionMessage='Success'
	set @responseCode='200'
	if(@Opcode=41)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('ProductListAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	   --   select isnull((Select AutoId as ProductId, ProductName, ViewImage, ImagePath, SKUCount,
	   --   case when SKUCount=1 then (select Barcode from ProductUnitDetail where ProductAutoId=pm.AutoId) else '' end as Barcode,
	   --   case when SKUCount=1 then (Select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1) else 0 end as SKUAutoId
	   --   from ProductMaster pm
	   --   where Status=1
	   --   and (@ProductName is null or @ProductName='' or pm.ProductName like '%'+@ProductName+'%')
	   --   and (@CategoryId is null  or @CategoryId=0 or pm.CategoryId=@CategoryId)
	   --   and (@BrandId  is null or @BrandId=0 or pm.BrandId=@BrandId)
	   --   and (@Fav is null  or @Fav=0 or pm.Favorite=@Fav)
		  --order by ProductName
	   --   for json path, INCLUDE_NULL_VALUES),'[]') as [ProductList] for json path, INCLUDE_NULL_VALUES
		  Select AutoId as ProductId,
		   ProductName,
		   ViewImage , 
		   @URL+'/Images/ProductImages/'+ImagePath as ProductImagePath,
		   --SKUCount,
	       case when 1=1 then (select Barcode from ProductUnitDetail where ProductId=pm.AutoId) else '' end as Barcode
	      --,case when SKUCount=1 then (Select AutoId from SKUMaster where ProductId=pm.AutoId and SKUType=1) else 0 end as SKUAutoId
	       from ProductMaster pm
	       where Status=1
	      and (@ProductName is null or @ProductName='' or pm.ProductName like '%'+@ProductName+'%')
	      and (@CategoryId is null  or @CategoryId=0 or pm.CategoryId=@CategoryId)
	      and (@BrandId  is null or @BrandId=0 or pm.BrandId=@BrandId)
	      --and (@Fav is null  or @Fav=0 or pm.Favorite=@Fav)
		  order by ProductName
	      for json path, INCLUDE_NULL_VALUES
	  end
	end
	if(@Opcode=42)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetCategoryList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	    Select isnull((select AutoId  as CategoryId, CategoryName
		from CategoryMaster where isnull(status,0)=1
		and (@SearchString is null or @SearchString='' or (CategoryName like '%'+@SearchString+'%'))
		and AutoId in (select CategoryId from ProductMaster where isnull(Status,0)=1) for json path, INCLUDE_NULL_VALUES),'[]') as [CategoryList] for json path, INCLUDE_NULL_VALUES
	  end
	end
	if(@Opcode=43)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetBrandList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	    Select * from (select AutoId as BrandId, BrandName
		from BrandMaster where isnull(status,0)=1
		and (@SearchString is null or @SearchString='' or (BrandName like '%'+@SearchString+'%'))
		and AutoId in (select BrandId from ProductMaster where isnull(Status,0)=1)) as [BrandList] for json path, INCLUDE_NULL_VALUES
	  end
	end
	if(@Opcode=44)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetProductDetailAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF not EXISTS(Select [SKUId] from BarcodeMaster bm  where Barcode=@Barcode)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'Product detail not found'	
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
		 
		   Select @SKUAutoId=[SKUId] from BarcodeMaster bm  where Barcode=@Barcode
		   declare @SchemeAutoId int=0

	       set @SchemeAutoId=(Select AutoId from SchemeMaster where Status=1 and  SKUAutoId=@SKUAutoId and Quantity<=@Quantity and 
                      case when MaxQuantity=0 then @Quantity+1 else MaxQuantity end > @Quantity)

            if(isnull(@SchemeAutoId,0)!=0)
	        begin
			  Select 
			  SM.SKUAutoId as SKUId,
			  SKUM.SKUName,
			  --SM.AutoId as SchemeId,
			  @Quantity as Quantity, 
			  @Barcode as Barcode, 
			  @URL+'/Images/ProductImages/'+SKUImagePath as ProductImagePath,
	          --convert(decimal(10,2),SM.UnitPrice) as UnitPrice, 
			  --SKUM.SKUDiscountTotal as SKUDiscountTotal,
			  --convert(decimal(10,2),SM.UnitPrice) as SKUSubTotal, 
	          --SM.Tax as Tax, 
	          --convert(decimal(10,2),1*(SM.UnitPrice+SM.Tax)) as Amount,
			  --SIM.ProductAutoId as ProductId, 
			  --SIM.PackingAutoId as PackingId,
			  --SIM.Quantity,
	          convert(decimal(10,2),SIM.UnitPrice) as UnitPrice, 
			  SKUM.SKUDiscountTotal as Discount,
	          convert(decimal(10,2),SIM.Tax) as Tax,
	          --convert(decimal(10,2),SIM.Total) as Total
			  convert(decimal(10,2),@Quantity*(SM.UnitPrice+SM.Tax))Total
	          from SchemeMaster SM
	          inner join SKUMaster SKUM on SM.SKUAutoId=SKUM.AutoId
			  inner join SchemeItemMaster SIM on SIM.SchemeAutoId=SM.AutoId
	          where SM.AutoId=@SchemeAutoId
			  for json path,INCLUDE_NULL_VALUES 
	          --isnull((Select @SKUAutoId as SKUId, SIM.ProductAutoId as ProductId, SIM.PackingAutoId as PackingId, SIM.Quantity,
	          --convert(decimal(10,2),SIM.UnitPrice) as UnitPrice, 
	          --convert(decimal(10,2),SIM.Tax) as Tax,
	          --convert(decimal(10,2),SIM.Total) as Total
	          --from SchemeItemMaster SIM 
	          --where SIM.SchemeAutoId=@SchemeAutoId
			  --for json path,INCLUDE_NULL_VALUES ),'[]') as PriceDetails
	        end
	        else
	        begin
			  Select SM.AutoId as SKUId,
			  SM.SKUName,
			  --0 as SchemeId, 
			  @Quantity as Quantity,
			  @Barcode as Barcode, 
			  @URL+'/Images/ProductImages/'+SKUImagePath as ProductImagePath,
	          --SM.SKUUnitTotal as UnitPrice,
			  --SKUDiscountTotal as SKUDiscountTotal,
			  --SKUSubTotal as SKUSubTotal,
	          --SM.SKUTotalTax as Tax, 
	          --convert(decimal(10,2),@Quantity * SKUTotal) as Amount
		      --SIM.ProductAutoId as ProductId,
			  --SIM.ProductUnitAutoId as PackingId,
		      SIM.[UnitPrice],
			  SIM.[Discount],
			  --SIM.[SKUItemTotal],
			  SIM.Tax,
			  convert(decimal(10,2),@Quantity * SM.SKUTotal)Total
	          from SKUMaster SM
			  inner join SKUItemMaster SIM on SIM.SKUAutoId=SM.AutoId
	          where SM.AutoId=@SKUAutoId
			  for json path,INCLUDE_NULL_VALUES --),'[]') as ProductDetail for json path,INCLUDE_NULL_VALUES
	          --isnull((Select SKUAutoId as SKUId, SIM.ProductAutoId as ProductId, SIM.Quantity,
	          --SIM.[UnitPrice], SIM.[Discount], SIM.[SKUItemTotal], SIM.Tax,SIM.ProductUnitAutoId as PackingId
	          --from SKUItemMaster SIM
	          --where SIM.SKUAutoId=@SKUAutoId
			  --for json path,INCLUDE_NULL_VALUES ),'[]') as PriceDetails
			end
	   end
	end
	if(@Opcode=45)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetVarientsDetailAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF not EXISTS(SELECT * from SKUItemMaster SIM 
	       inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId where isnull(SM.Status,0)=1 and SIM.ProductId=@ProductId)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'No variant found for this product'	
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
		   Select 
		   --SIM.SKUAutoId as SKUAutoId,
		   PM.ProductName,
	       case when SM.ProductId=0 then SM.SKUName else PUD.PackingName end SKUName,
	       (select top 1 Barcode from BarcodeMaster where SKUId=SIM.SKUAutoId) as Barcode,
	       SM.SKUTotal,
	       --PUD.PackingName ,
		   @URL+'/Images/ProductImages/'+case when SM.SKUImagePath!='' then SM.SKUImagePath when SM.SKUImagePath!=null then SM.SKUImagePath else 'product.png' end as ProductImagePath
	       --,case when SM.ProductId!=0 then 1 else 0 end as skutype
	       from SKUItemMaster SIM 
	       inner join SKUMaster SM on SM.AutoId=SIM.SKUAutoId
	       left join ProductUnitDetail PUD on PUD.AutoId=SIM.ProductUnitAutoId
		   left join ProductMaster PM on PM.AutoId=SIM.ProductId
	       where SM.Status=1 and
	       sim.ProductId=@ProductId
		   order by SM.SKUName
	       for json path,INCLUDE_NULL_VALUES
	   end
	end

	if(@Opcode=46)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetCustomerListAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
		   select ROW_NUMBER() over(order by FirstName asc) as RowNumber,AutoId, CustomerId, 
			FirstName+' '+ isnull(LastName,'') as Name,  MobileNo, PhoneNo, EmailId 
			into #temp1  
			from CustomerMaster
			where Status=1 --and AutoId!=1
			and (@Name is null or @Name='' or FirstName+' '+ISNULL(LastName,'') like '%'+@Name+'%')
			and (@MobileNo is null or @MobileNo='' or isnull(MobileNo,'') like '%'+@MobileNo+'%')
			and (@EmailId is null or @EmailId='' or isnull(EmailId,'') like '%'+@EmailId+'%')
			order by FirstName asc
			
            Select  * from #temp1 t      
            WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
            order by Name asc 
	        for json path,INCLUDE_NULL_VALUES
	   end
	end

	if(@Opcode=47)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('CreateCustomerAPI', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF (@FirstName is null or @FirstName='')  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'First Name Required'	
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
		    declare @CustomerAutoId int=0 ;

            SET @CustomerId = (SELECT DBO.SequenceCodeGenerator('CustomerNo'))  
			
			insert into CustomerMaster(CustomerId, FirstName, LastName, DOB, MobileNo, PhoneNo, EmailId, Address, State, City, Country, ZipCode, Status)
			values (@CustomerId, @FirstName, @LastName, @DOB, @MobileNo, '', @EmailId, @Address, @State, @City, '', @ZipCode, 1)
			
			set @CustomerAutoId=SCOPE_IDENTITY();
			
			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CustomerNo'
			
			select AutoId,CustomerId,(FirstName+' '+isnull(LastName,''))Name from CustomerMaster where AutoId=@CustomerAutoId
	        for json path,INCLUDE_NULL_VALUES
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
