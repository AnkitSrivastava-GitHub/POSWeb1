create or alter proc [dbo].[ProcDropdownList]
@Opcode int=Null,
@AccessToken varchar(50)=null,
@Hashkey varchar(50)=null,
@DeviceId varchar(100)=null,
@LatLong varchar(100)=null,
@AppVersion varchar(20)=null,
@RequestSource varchar(20)=null,
@LoginId varchar(100)=null,
@URL varchar(200)=null,
@Status int=null,
@TerminalId int=null,
@SearchString varchar(100)=null,
@StoreId int=null,
@Remark varchar(300)=null,
@AutoId int=null,
@Action int=null,
@DDLString varchar(50)=null,
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
	  values('DropdownList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  Begin
			if not exists(select * from DepartmentMaster where Status=1)
			begin		   
				SET @exceptionMessage='No Department Found.'
				SET @isException=1
			end
			else if not exists(SELECT * from ScreenMaster where StoreId=@StoreId)
			begin		   
				SET @exceptionMessage='No Screen Found.'
				SET @isException=1
			end
			else
			begin
				select isnull((select AutoId,DepartmentName from DepartmentMaster 
				where Status=1
				ORDER BY DepartmentName asc 
				for json path, INCLUDE_NULL_VALUES),'[]')as DepartmentDDLList,
				isnull((select SM.AutoId,SM.Name,SM.Status from ScreenMaster SM
				where Status=1 and StoreId=@StoreId
				ORDER BY Name asc 
				for json path, INCLUDE_NULL_VALUES),'[]')as ScreenDDLList
				for json path, INCLUDE_NULL_VALUES
			end
		end
	  if(@DDLString='Screen')
	  Begin
			if not exists(SELECT * from ScreenMaster where StoreId=@StoreId)
			begin		   
				SET @exceptionMessage='No Screen Found.'
				SET @isException=1
			end
			else
			begin
				select isnull((select SM.AutoId,SM.Name,SM.Status from ScreenMaster SM
				where Status=1 and StoreId=@StoreId
				ORDER BY Name asc 
				for json path, INCLUDE_NULL_VALUES),'[]')as ScreenDDLList
				for json path, INCLUDE_NULL_VALUES
			end
		end
	end
	if(@Opcode=42)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('StatusList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  Begin
			DECLARE @StatusList TABLE (Name varchar(50), AutoId int)
			insert into @StatusList (Name,AutoId) values ('Active',1) insert into @StatusList (Name,AutoId) values ('Inactive',0)

			select isnull((select Name,AutoId from @StatusList
			ORDER BY Name asc 
			for json path, INCLUDE_NULL_VALUES),'[]')as StatusList
			for json path, INCLUDE_NULL_VALUES

		end
	end
	if(@Opcode=43)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('PayoutDropdownList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  Begin
			DECLARE @PayoutTypeList TABLE (Name varchar(50), AutoId int)
			insert into @PayoutTypeList (Name,AutoId) values ('Purchase',1) insert into @PayoutTypeList (Name,AutoId) values ('Expense',2)

			select 
			isnull((select Name,AutoId from @PayoutTypeList ORDER BY Name asc for json path, INCLUDE_NULL_VALUES),'[]')as PayoutTypeList,

			isnull((select AutoId,ExpenseName as Name from ExpenseMaster where Status=1 and StoreId=@StoreId ORDER BY Name asc for json path, INCLUDE_NULL_VALUES),'[]')as ExpenseList,

			isnull((select AutoId,VendorName as Name from VendorMaster where Status=1 and CompanyId=@StoreId ORDER BY Name asc for json path, INCLUDE_NULL_VALUES),'[]')as VendorList
			for json path, INCLUDE_NULL_VALUES
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
