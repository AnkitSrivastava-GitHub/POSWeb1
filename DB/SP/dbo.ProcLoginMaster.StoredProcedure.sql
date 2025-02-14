

ALTER PROCEDURE [dbo].[ProcLoginMaster]
@isException bit out,
@exceptionMessage nvarchar(500) out,
@TerminalId int=NULL,
@Userid int=NULL,
@AutoId int=NULL,
@LogInAutoId int=null,
@LoginID nvarchar(50)=NULL,
@Password varchar(50)=NULL,
@FirstName varchar(50)=NULL,
@LastName varchar(50)=NULL,
@EmailID varchar(50)=NULL,
@Phoneno nvarchar(12)=NULL,
@UserType varchar(50)=NULL,
@Opcode int=Null,
@isActiveUser bit=NULL,    
@EmpAutoId int=Null,
@EmpType   int=Null,  
@Currency nvarchar(10)=null,
@NewPassword varchar(50)=NULL,
@IPAddress varchar(50)=NULL,  
@PageUrl varchar(200)=NULL  
AS
BEGIN
  set @isException=0
  set @exceptionMessage='Success'
if @opCode=41  --Login selection
begin

	select top 1 Userid, FirstName, LastName, EmailID, UDM.UserType , LoginID,UserAutoId,
	(select UserType from UserTypeMaster Um where Um.AutoId=UDM.UserType) AS [EmpType],	
	(case when isnull((select top 1 Mode from BalanceMaster BM where BM.UserId= udm.UserAutoId order by AutoId desc),'')!='' 
	then (select top 1 Mode from BalanceMaster BM where BM.UserId= udm.UserAutoId order by AutoId desc) else 'Logout' end)BalanceStatus,
	isnull((select top 1 AutoId from BalanceMaster BM where BM.UserId= udm.UserAutoId order by AutoId desc),'') as ShiftId, --AvlTerminalCount
	(select count(*) from EmployeeStoreList t inner join CompanyProfile c on c.AutoId=t.CompanyId where c.Status=1 and EmployeeId=UDM.UserAutoId)StoreStatusCnt
	into #templogin 
	from UserDetailMaster UDM
	where UDM.Status=1 and LoginID=@LoginID
	and Password=@Password COLLATE Latin1_General_CS_AS 
	if(isnull((select COUNT(*) from #templogin),0)>0 and isnull((select isnull(StoreStatusCnt,0) from #templogin),0)=0 and (select UserType from #templogin)!=1)
	begin
	      SET @isException=1
		  Set @exceptionMessage='Store not found!'
	end
	else if(isnull((select COUNT(*) from #templogin),0)>0)
	Begin
	      declare @ComName varchar(200)='',@StoreId int=0,@AssignedStorecnt int,@AssignedStoreId int;

		  if((select EmpType from #templogin)='Cashier')
		  begin
		     select top 1 @StoreId=CP.AutoId, @ComName=CP.CompanyName,@Currency=CP.CurrencyId
	         from UserDetailMaster UDM
	         inner join UserTypeMaster UTM on UTM.AutoId=UDM.UserType
	         inner join EmployeeStoreList EST on EST.EmployeeId=UDM.UserAutoId
	         left join CompanyProfile CP on CP.AutoId=EST.CompanyId and CP.Status=1
	         where UTM.UserType='Cashier' and UDM.UserAutoId=(select top 1 UserAutoId from #templogin)

			  --insert into StoreLoginLog(UserId,CompanyId,LoginTime,Status)
		   --   values((select UserAutoId from #templogin),@StoreId,GETDATE(),'Success')
		  end
		  
		  set @AssignedStorecnt=(select count(*) from EmployeeStoreList ES inner join CompanyProfile CP on CP.AutoId=ES.CompanyId where EmployeeId=(select UserAutoId from #templogin) and ES.Status=1 and CP.Status=1)
		  if(@AssignedStorecnt=1)
		  begin
		     set @AssignedStoreId=(select CompanyId from EmployeeStoreList where EmployeeId=(select UserAutoId from #templogin) and Status=1)
		  end
		  else
		  begin
		     set @AssignedStoreId=0
		  end
		  set @Currency=(select CurrencySymbol from CurrencySymbolMaster CM INNER JOIN CompanyProfile CP on CP.CurrencyID=CM.AutoId where CP.AutoId=@AssignedStoreId)

          SELECT 'success' as response,UserAutoId as AutoId,UserType As EmpTypeNo,(select Status from CompanyProfile where AutoId=@AssignedStoreId)  CompanyStatus,
		  [EmpType],  @ComName CompanyName , BalanceStatus,ShiftId, (select count(1)from  TerminalMaster where Status=1 and CompanyId=@StoreId and (CurrentUser=t.UserAutoId or OccupyStatus=0))AvlTerminalCount,
		  [FirstName]+isnull(' '+LastName,'') AS Name ,[FirstName] UserName,Userid [EmpId] ,EmailID Email,FirstName ProfileName,@StoreId StoreId,@Currency as CurrencySymbol,
		  @AssignedStorecnt EmpStoreCnt,@AssignedStoreId AssignedStoreId
		  from #templogin t

		  Insert  into UserLogInLogMaster(UserId,LogInID,IPAddress,LogInDate,Status,type,CreatedFrom,DeviceId)
		  Select UserAutoId, @LoginID,@IPAddress, GETDATE(), 'Success', 'Login','Web','' from #templogin

		  SET @AutoId = SCOPE_IDENTITY()
		  select '0' as SuccessCode,@AutoId as LogInAutoId,'Success' as SuccessMessage
		  
		  SET @isException=0
		  Set @exceptionMessage='Success'
	end
	else
	Begin
		Insert  into UserLogInLogMaster(UserId,LogInID,IPAddress,LogInDate,Status,type)
		values('',@LoginID,@IPAddress,getdate(),'Failed','Login')
		--Select 0 as AutoId, 'Failed' as Mode 
		--select '0' as SuccessCode,'Wrong User ID/Password!' as SuccessMessage
		SET @isException=1
		Set @exceptionMessage='Wrong User ID/Password!'
	End
    --SET @isException=0					
End
if @opCode=42
begin
Select udm.FirstName+' '+udm.LastName as UserName 
from BalanceMaster bm
inner join UserDetailMaster udm on udm.Userid=bm.UserId
where TerminalAutoId=@TerminalId and (Mode='Break' or Mode='Login')
SET @isException=0
end
else if @opCode=43  --Details from loginId 
begin
	select [Userid],[UserType],[FirstName],[LastName],[EmailID] from UserDetailMaster where Userid=@Userid 
	SET @isException=0
end
else if @Opcode=44  --For cancel & Void Security
begin
	Select top 1 * from SecurityCode where [SecurityCode]=@Password
	SET @isException=0
end
else if @Opcode=45  --For cancel & Void Security
begin
	Select AutoId,TerminalId,TerminalName from TerminalMaster where Status=1 and (OccupyStatus=0 or CurrentUser=@Userid) 
	and CompanyId=(select Top 1 CompanyId from EmployeeStoreList where EmployeeId=@Userid and Status=1)
	if exists(select * from TerminalMaster where CurrentUser=@Userid and OccupyStatus=1)
	begin
	    select AutoId as TerminalAutoId,1 AlreadyAssignedStatus from TerminalMaster where CurrentUser=@Userid and OccupyStatus=1
		SET @isException=0
	end
	else
	begin
	    select 0 as TerminalAutoId,0 AlreadyAssignedStatus
	    SET @isException=0
	end
end
else if @opCode=51  -- Sign Up Authentication
begin
	select * from UserDetailMaster Where Status='1' and Userid=@Userid and Password=@Password
	SET @isException=0
end
else if @opCode=52  -- Forget Password
begin
	declare @count int
	set @count=(select count(*) from UserDetailMaster Where [LoginID]=@LoginID)
	if @count>0
	begin
		select * from UserDetailMaster Where [LoginID]=@LoginID
		SET @isException=0
	end
	else 
	begin
		SET @isException=1
		SET @exceptionMessage='Invalid EmailID'
	end
end	
else if @Opcode=21 
begin

   if((select Password from UserDetailMaster where UserAutoId=@EmpAutoId and Status=1)=@Password)
   begin
        Update UserDetailMaster set Password=@NewPassword where UserAutoId=@EmpAutoId
        SET @isException=0
	end
	else
	begin
	    SET @isException=1
		SET @exceptionMessage='Old password has been entered incorrectly!'
	end
end
else if @Opcode=22 
begin
    if exists(select * from TerminalMaster where CurrentUser=@Userid and OccupyStatus=1)
	begin
	    insert into TerminalLoginLog(TerminalId,UserId,LoginTime,LogInAutoId)
        values(@TerminalId,@Userid,GETDATE(),@LogInAutoId)

		set @StoreId=(select top 1 CompanyId from EmployeeStoreList where EmployeeId=@Userid)

		insert into StoreLoginLog(UserId,CompanyId,LoginTime,Status,LogInAutoId)
		values(@Userid,@StoreId,GETDATE(),'Success',@LogInAutoId)

	    select AutoId as TerminalAutoId,1 AlreadyAssignedStatus,TerminalName from TerminalMaster where CurrentUser=@Userid and OccupyStatus=1
		SET @isException=0
	end
	else
	begin
        insert into TerminalLoginLog(TerminalId,UserId,LoginTime,LogInAutoId)
        values(@TerminalId,@Userid,GETDATE(),@LogInAutoId)
	    
		set @StoreId=(select top 1 CompanyId from EmployeeStoreList where EmployeeId=@Userid)

		insert into StoreLoginLog(UserId,CompanyId,LoginTime,Status,LogInAutoId)
		values(@Userid,@StoreId,GETDATE(),'Success',@LogInAutoId)

        update TerminalMaster set OccupyStatus=1,LoginTime=getdate(),CurrentUser=@Userid where AutoId=@TerminalId
	    
	    select @TerminalId as TerminalAutoId,0 AlreadyAssignedStatus,TerminalName from TerminalMaster where AutoId=@TerminalId
	    SET @isException=0
	end
end
END


