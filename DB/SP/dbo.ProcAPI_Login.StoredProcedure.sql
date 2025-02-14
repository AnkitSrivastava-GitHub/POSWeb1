CREATE or alter proc [dbo].[ProcAPI_Login]
@Opcode int=Null,
@AutoId int=Null,
@AccessToken varchar(50)=null,
@Hashkey varchar(50)=null,
@DeviceId varchar(100)=null,
@LatLong varchar(100)=null,
@AppVersion varchar(20)=null,
@RequestSource varchar(20)=null,
@LoginAutoId int=null,
@StoreId int=null,
@BalanceStatus varchar(25)=null,
@DT_CurrencyListChild DT_CurrencyTable readonly,
@Currency nvarchar(50)=null,
@OpeningBalance decimal(18,2)=null,
@CurrentBalStatus varchar(30)=null,
@CurrentBalance decimal(18,2)=null,
@TerminalId int=null,
@CompanyName varchar(200)=null,
@UserName varchar(100)=null,
@Password varchar(100)=null,
@NewPassword varchar(100)=null,
@UserAutoId int=null,
@ResponseStatus varchar(50)=null,
@DataType varchar(100)=null,
@EmpType varchar(50)=null,
@PageIndex INT = 1,  
@PageSize INT = null,  
@RecordCount INT =null,    
@isException bit out,  
@exceptionMessage varchar(max) out,
@responseCode varchar(10) out
as
begin
	BEGIN TRY  
	SET @isException=0  
	set @ResponseStatus='Success'
	SET @exceptionMessage='Success'
	SET @responseCode='200'
	if(@Opcode=41)
	begin
	insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate)
	values('Login', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate())
	   if not exists(select AutoId from [API_CredentialDetail] where AccessToken=@AccessToken and Hashkey=@Hashkey)
	   BEGIN
	     SET @isException=1  
		 set @ResponseStatus='Failed'
		 SET @exceptionMessage=' AccessToken or Hashkey are invalid'  
		 SET @responseCode='301'
	   END
	   else if not exists(select AutoId from [API_Version] where [Version]=@AppVersion AND [Status]=1)
	   BEGIN
	  	 SET @isException=1  
		 set @ResponseStatus='Failed'
		 SET @exceptionMessage='Please download the latest app version ('+ (select top 1 [Version] from [dbo].[API_Version] where [Status]=1 ORDER BY AutoId DESC )+') '
		 SET @responseCode='301'
	   END
	   else IF not EXISTS(SELECT LoginID from [UserDetailMaster] 
	   where LoginID=@UserName and [Password]=@Password)  
	   BEGIN
		 SET @isException=1  
		 set @ResponseStatus='Failed'
		 SET @exceptionMessage= 'User Name & Password are not correct'  
		 SET @responseCode='301'
	   END
	   else IF not EXISTS(SELECT LoginID from [UserDetailMaster]
	   where LoginID=@UserName and [Password]=@Password and Status=1 and [IsAppAllowed]=1)  
	   BEGIN
		 SET @isException=1  
		 set @ResponseStatus='Failed'
		 SET @exceptionMessage= 'User is Not Allowed'  
		 SET @responseCode='301'
	   END
	   else IF not EXISTS(SELECT TM.TerminalName from [UserDetailMaster] UM Inner join EmployeeStoreList EL on UM.UserAutoId=EL.EmployeeId
	   Inner Join TerminalMaster TM on TM.CompanyId=EL.CompanyId where LoginID=@UserName and [Password]=@Password and UM.Status=1 and [IsAppAllowed]=1)  
	   BEGIN
		 SET @isException=1  
		 set @ResponseStatus='Failed'
		 SET @exceptionMessage= 'No Terminal Found.'  
		 SET @responseCode='301'
	   END
	   else IF not EXISTS(SELECT TM.TerminalName from [UserDetailMaster] UM Inner join EmployeeStoreList EL on UM.UserAutoId=EL.EmployeeId
		Inner Join TerminalMaster TM on TM.CompanyId=EL.CompanyId where (UM.UserAutoId=TM.CurrentUser or TM.OccupyStatus=0)
		and LoginID=@UserName and [Password]=@Password and UM.Status=1 and [IsAppAllowed]=1)
	   BEGIN
		 SET @isException=1  
		 set @ResponseStatus='Failed'
		 SET @exceptionMessage= 'All Terminals Occupied.'  
		 SET @responseCode='301'
	   END
	   else
	   BEGIN
	   
			SELECT EM.UserAutoId, EM.UserType As EmpTypeNo, ETM.UserType AS [EmpType], ([FirstName]+' '+isnull([LastName],'')) AS Name, LoginID as UserName
			,(case when isnull((select top 1 Mode from BalanceMaster BM where BM.UserId= EM.UserAutoId order by AutoId desc),'')!='' 
			then (select top 1 Mode from BalanceMaster BM where BM.UserId= EM.UserAutoId order by AutoId desc) else 'Logout' end)BalanceStatus
			,case when EM.UserType=1 then '0' else (select Top 1 EL.CompanyId from EmployeeStoreList EL where EL.EmployeeId=EM.UserAutoId and EL.Status=1) end as StoreId
			into #templogin
			from [UserDetailMaster] as EM   
			inner JOIN [UserTypeMaster] AS ETM on EM.UserType=ETM.AutoId
			inner join EmployeeStoreList EL on EL.EmployeeId=EM.UserAutoId and EL.Status=1
			WHERE LoginID=@UserName and [Password]=@Password and em.Status=1 and [IsAppAllowed]=1

			Insert  into UserLogInLogMaster(UserId,LogInID,IPAddress,LogInDate,Status,type,CreatedFrom,DeviceId)
		    Select UserAutoId, @UserName,'', GETDATE(), 'Success', 'Login','App',@DeviceId from #templogin

			 SET @LoginAutoId = SCOPE_IDENTITY()			 
			
			set @StoreId=(SELECT StoreId from #templogin)
			set @CompanyName=(select CompanyName from CompanyProfile where AutoId=@StoreId)
			set @UserAutoId=(SELECT UserAutoId from #templogin)
			 set @Currency=(select CurrencySymbol from CurrencySymbolMaster CM INNER JOIN CompanyProfile CP on CP.CurrencyID=CM.AutoId where CP.AutoId=@StoreId)

			if exists(select * from TerminalMaster where CurrentUser=@UserAutoId and CompanyId=@StoreId and OccupyStatus=1)
			BEGIN
				select 
				isnull((select AutoId,CustomerId,FirstName,LastName from CustomerMaster where FirstName='Walk In' and Status=1 and StoreId=@StoreId for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerWalkIn],
				isnull((SELECT UserAutoId, EmpTypeNo,[EmpType], Name, UserName,@CompanyName CompanyName,BalanceStatus,StoreId,@LoginAutoId as LogInAutoId,@Currency as CurrencySymbol
				from #templogin for json path, INCLUDE_NULL_VALUES),'[]') as [LoginDetails],
				isnull((Select AutoId,TerminalName,OccupyStatus,CurrentUser from TerminalMaster where Status=1 and CompanyId=@StoreId
				and CurrentUser=@UserAutoId and OccupyStatus=1 for json path, INCLUDE_NULL_VALUES),'[]') as [TerminalList] for json path, INCLUDE_NULL_VALUES
			END
			ELSE
			BEGIN
				select isnull((select AutoId,CustomerId,FirstName,LastName from CustomerMaster where FirstName='Walk In' and Status=1 and StoreId=@StoreId for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerWalkIn],
				isnull((SELECT UserAutoId, EmpTypeNo,[EmpType], Name, UserName,@CompanyName CompanyName,BalanceStatus,StoreId,@LoginAutoId as LogInAutoId,@Currency as CurrencySymbol
				from #templogin for json path, INCLUDE_NULL_VALUES),'[]') as [LoginDetails],
				isnull((Select AutoId,TerminalName,OccupyStatus,CurrentUser from TerminalMaster where Status=1 and CompanyId=@StoreId
				and OccupyStatus=0  for json path, INCLUDE_NULL_VALUES),'[]') as [TerminalList] for json path, INCLUDE_NULL_VALUES
			END
	   END
	end
   if(@Opcode=42)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetTerminalList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else IF not EXISTS(SELECT * from TerminalMaster where Status=1 and CompanyId=@StoreId)  
	  BEGIN
		SET @isException=1  
	    SET @exceptionMessage= 'No Terminal Found'	
		SET @responseCode='301'
	  END	  
	  else
	  begin
			Select isnull((Select AutoId,TerminalId,TerminalName,OccupyStatus,CurrentUser from TerminalMaster where Status=1 and CompanyId=@StoreId 
			and (OccupyStatus=0 or CurrentUser=@AutoId) for json path, INCLUDE_NULL_VALUES),'[]') as [TerminalList] for json path, INCLUDE_NULL_VALUES
	  end
	end
	if(@Opcode=43)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('GetCurrencyList', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else
	  begin
			Declare @CAutoId int=null
			set @CAutoId=(select max(AutoId) from BalanceMaster where  StoreId=@StoreId and TerminalAutoId=@TerminalId and ClosingBalance is not null)
			if(isnull(@CAutoId,0)!=0)
			BEGIN	
				select isnull(B.ClosingBalance,0) as ClosingBalance, isnull(FORMAT(UpdatedDate,'MM/dd/yyyy'),'') as ClosingDate,
				isnull(( select CM.AutoId,QTY,CurrencyAutoId,Amount from UserCurrencyRecord UCR 
				Inner join CurrencyMaster CM on UCR.CurrencyAutoId=CM.AutoId 
				where BMAutoId=@CAutoId and Type='Closing' order by Amount asc for json path, INCLUDE_NULL_VALUES),'[]') as [CurrencyDetails]
				from BalanceMaster B where B.AutoId=@CAutoId and B.StoreId=@StoreId and B.TerminalAutoId=@TerminalId
				for json path, INCLUDE_NULL_VALUES
			END
			else
			BEGIN
				select  '0' as ClosingBalance, '' as ClosingDate,
				isnull(( select AutoId,0 as QTY,0 as CurrencyAutoId,Amount from CurrencyMaster where Status=1 order by Amount asc
				for json path, INCLUDE_NULL_VALUES),'[]') as [CurrencyDetails]				
				for json path, INCLUDE_NULL_VALUES
			END
	  end
	end
	if(@Opcode=44)
	begin
	  insert into API_ActivityLog(APIName, AccessToken, Hashkey, DeviceId, LatLong, AppVersion, RequestSource, CreatedDate,UserId)
	  values('ProceedCurrencyTerminal', @AccessToken, @Hashkey, @DeviceId, @LatLong, @AppVersion, @RequestSource, getdate(), @AutoId)
	   
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
	  else
	  begin
		if(@BalanceStatus='Logout')
		Begin
			if(exists(select top 1 Mode from BalanceMaster where UserId=@AutoId order by AutoId desc)and (select top 1 Mode from BalanceMaster where UserId=@AutoId order by AutoId desc)!='Logout')
			begin
				SET @responseCode='301'
				Set @isException=1                                                                                                   
				Set @exceptionMessage='Your previous closing balance is pending!'
			end
			else
			begin
				insert into TerminalLoginLog(TerminalId,UserId,LoginTime,LogInAutoId) values(@TerminalId,@AutoId,GETDATE(),@LogInAutoId)

				insert into StoreLoginLog(UserId,CompanyId,LoginTime,Status,LogInAutoId) values(@AutoId,@StoreId,GETDATE(),'Success',@LogInAutoId)

				update TerminalMaster set OccupyStatus=1,LoginTime=getdate(),CurrentUser=@AutoId where AutoId=@TerminalId

				DECLARE @BMId int
				insert into BalanceMaster(UserId, TerminalAutoId, OpeningBalance, Mode, CreatedDate,StoreId,CreatedBy,CurrentBalanceStatus,CurrentBalanceDiff) 
				values(@AutoId,@TerminalId,@OpeningBalance,'Break',getdate(),@StoreId,@AutoId,@CurrentBalStatus,@CurrentBalance)

				SET @BMId = SCOPE_IDENTITY()		

				select ROW_NUMBER() over(order by CAutoId asc)RowNo, CAutoId,QTY,@AutoId as UserId,@StoreId as StoreId,[Type]='Opening',[BMAutoId]=(@BMId)  into #TempCurrency from @DT_CurrencyListChild 
				insert into UserCurrencyRecord (CurrencyAutoId,QTY,UserId,StoreId,BMAutoId,Type) select CAutoId,QTY,UserId,StoreId,BMAutoId,Type from #TempCurrency
				
				Declare @Ono varchar(20)=null,@OrderNo varchar(30)
				set @Ono=isnull((select top 1 OrderNo from CartMaster where StoreId=@StoreId and TerminalId=@TerminalId and LiveCartforDraft=1 order by AutoId desc),'')
				if(@Ono='')
				Begin
				Set @Ono=(select top 1 OrderNo from CartMaster where StoreId=@StoreId and TerminalId=@TerminalId  order by AutoId desc)
				End
				set @OrderNo=(select OrderNo from CartMaster where OrderNo=@Ono and IsDeleted=0 and isnull(InvoiceId,0)=0)


				Select isnull(@OrderNo,'') as OrderNo, isnull((select top 1 @BMId as ShiftId,@TerminalId as TerminalAutoId,1 AlreadyAssignedStatus,TerminalName,'Break' as BalanceStatus from TerminalMaster where AutoId=@TerminalId 
				for json path, INCLUDE_NULL_VALUES),'[]') as [BalanceMaster] for json path, INCLUDE_NULL_VALUES	    
		    end
		End 
		Else if(@BalanceStatus='Break')
		Begin
			insert into TerminalLoginLog(TerminalId,UserId,LoginTime,LogInAutoId) values(@TerminalId,@AutoId,GETDATE(),@LogInAutoId)
			 
			insert into StoreLoginLog(UserId,CompanyId,LoginTime,Status,LogInAutoId) values(@AutoId,@StoreId,GETDATE(),'Success',@LogInAutoId)
			SET @BMId =(select top 1 AutoId from BalanceMaster BM where BM.UserId= @AutoId order by AutoId desc)

				Declare @Ono1 varchar(20)=null, @OrderNo1 varchar(30)
				set @Ono1=isnull((select top 1 OrderNo from CartMaster where StoreId=@StoreId and TerminalId=@TerminalId and LiveCartforDraft=1 order by AutoId desc),'')
				if(@Ono1='')
				Begin
				Set @Ono1=(select top 1 OrderNo from CartMaster where StoreId=@StoreId and TerminalId=@TerminalId  order by AutoId desc)
				End
				set @OrderNo1=(select OrderNo from CartMaster where OrderNo=@Ono1 and IsDeleted=0 and isnull(InvoiceId,0)=0)

			Select isnull(@OrderNo1,'') as OrderNo, isnull((select @BMId as ShiftId,AutoId as TerminalAutoId,1 AlreadyAssignedStatus,TerminalName,'Break' as BalanceStatus from TerminalMaster where CurrentUser=@AutoId and OccupyStatus=1
			for json path, INCLUDE_NULL_VALUES),'[]') as [BalanceMaster] for json path, INCLUDE_NULL_VALUES	    
		End
		else
		Begin
			SET @responseCode='301'
			Set @isException=1                                                                                                   
			Set @exceptionMessage='Some problem occured,Please try after sometime.'
		End
	  end
	end
	END TRY  
	BEGIN CATCH  
		SET @isException=1  
		SET @exceptionMessage=ERROR_MESSAGE()  
		SET @responseCode='300'
	END CATCH  
	insert into [API_LoginDetail](UserName, Password, EmpType, DataType, [CreatedDate],ResponseCode,ResponseMessage,ResponseStatus,isException,UserAutoId)
	select @UserName, @Password, @EmpType, @DataType, getdate(),@responseCode,@exceptionMessage,@ResponseStatus,@isException,@UserAutoId--  from  #templogin
 end
GO
