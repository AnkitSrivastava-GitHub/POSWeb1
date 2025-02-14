ALTER PROCEDURE [dbo].[ProcUserDetail]
    @UserAutoId int=null,
	@Who int=NULL,
	@isException bit out,
	@StoreIdsList varchar(500)=null,
	@ComponentIdsList varchar(500)=null,
	@ComponentIds varchar(500)=null,
	@exceptionMessage nvarchar(500) out,
	@Userid nvarchar(25)=NULL out,
	@Password nvarchar(50)=NULL,
	@CompanyId nvarchar(50)=NULL,
	@ComponentId int=null,
	@HourlyRate decimal(18,2)=null,
	@FirstName nvarchar(50)=NULL,
	@LastName nvarchar(50)=NULL,
	@EmailID nvarchar(50)=NULL,
	@ModuleId int=Null,
	@AllowedApp int=null,
	@Phoneno nvarchar(12)=NULL,
	@UserType nvarchar(50)=NULL,
	@Status int=NULL,
	@LoginID nvarchar(50)=NULL,
	@opCode int=Null,
	@PageIndex INT=1,
	@PageSize INT=10,
	@Securitypin varchar(50)=NULL,
	@SecuritypinDisc varchar(50)=NULL, 
	@securityWithdraw varchar(50)=null,
	@RecordCount INT=null
AS
BEGIN
	BEGIN TRY
			SET @isException=0
			SET @exceptionMessage='Success'
			if(@opCode=11)
			begin
			if exists(Select * from UserDetailMaster where isnull(@EmailID,'')!='' and  isnull(EmailID,'')=replace(@EmailID,' ',''))
			begin
				Set @isException=1
				Set @exceptionMessage='Email ID already exists!'       
			end
			else if exists(Select * from UserDetailMaster  where isnull(@Phoneno,'')!='' and PhoneNo=replace(@Phoneno,' ',''))
			begin
				Set @isException=1
				Set @exceptionMessage='Mobile No already exists!'       
			end
			else if ((select count(LoginID) from UserDetailMaster where LoginID=@LoginID)=0)
					begin
					 
						set @Userid=(select dbo.SequenceCodeGenerator('Employee'))
						insert into UserDetailMaster (Userid ,Password,LoginID,CompanyId,FirstName,LastName,EmailID,PhoneNo,UserType,Status,CreatedBy,CreatedDate,HourlyRate,IsAppAllowed)
						values(@Userid ,@Password,@LoginID,@CompanyId,@FirstName,@LastName,@EmailID,@Phoneno,@UserType,@Status,@Who,GETDATE(),@HourlyRate,@AllowedApp);
						
						set @UserAutoId=Scope_identity();
						insert into tbl_SecurityPinMaster (UserId,SecurityPin,Status,Type) 
						values(@UserAutoId,@Securitypin,@Status,'Admin');

						insert into tbl_SecurityPinMaster (UserId,SecurityPin,Status,Type) 
						values(@UserAutoId,@SecuritypinDisc,@Status,'Discount');

						insert into tbl_SecurityPinMaster (UserId,SecurityPin,Status,Type) 
						values(@UserAutoId,@securityWithdraw,@Status,'Withdraw');

						Insert into EmployeeStoreList(EmployeeId,CompanyId,CreatedBy,CreatedDate,Status)
						select @UserAutoId,convert(int,splitdata),@Who,GETDATE(),1 from fnSplitString(@StoreIdsList,',')

						Insert into EmployeeStoreListLog(EmployeeId,CompanyId,UpdatedBy,UpdatedDate,Status)
						select @UserAutoId,convert(int,splitdata),@Who,GETDATE(),1 from fnSplitString(@StoreIdsList,',')

						update SequenceCodeGeneratorMaster set currentSequence=currentSequence+1 where SequenceCode='Employee'

					SET @isException=0
					end
					else
					begin
						SET @isException=1
						SET @exceptionMessage='Login ID already exists!'
					end
				end

			else if(@opCode=21)
			begin				
				   if not exists(select LoginID from UserDetailMaster where LoginID=@LoginID and UserAutoId!=@UserAutoId)     
					begin
				    update UserDetailMaster set Status=@Status,FirstName=@FirstName,LastName=@LastName,EmailID=@EmailID,CompanyId=@CompanyId,
			   	    PhoneNo=@Phoneno,UserType=@UserType, [Password]=@Password,[LoginID]=@LoginID,UpdatedBy=@Who,UpdatedDate=GETDATE(),HourlyRate=@HourlyRate,IsAppAllowed=@AllowedApp
					where UserAutoId=@UserAutoId;

					delete EmployeeStoreList where EmployeeId=@UserAutoId

					Insert into EmployeeStoreList(EmployeeId,CompanyId,CreatedBy,CreatedDate,Status)
					select @UserAutoId,convert(int,splitdata),@Who,GETDATE(),1 from fnSplitString(@StoreIdsList,',')

				    Insert into EmployeeStoreListLog(EmployeeId,CompanyId,UpdatedBy,UpdatedDate,Status)
				    select @UserAutoId,convert(int,splitdata),@Who,GETDATE(),1 from fnSplitString(@StoreIdsList,',')

					if(@UserType=(select AutoId from UserTypeMaster where usertype='Cashier'))
					begin
					   if(exists(select * from tbl_SecurityPinMaster where userid=@UserAutoId and Type='Admin'))
					   begin
					     update tbl_SecurityPinMaster set SecurityPin=@Securitypin,Status=@Status,Type='Admin' where UserId=@UserAutoId and Type='Admin'
					  end
					  else
					  begin
					       insert into tbl_SecurityPinMaster(SecurityPin,Status,UserId,Type)
					       values(@Securitypin,1,@UserAutoId,'Admin')
					  end
					  if(exists(select * from tbl_SecurityPinMaster where userid=@UserAutoId and Type='Discount'))
					   begin
					     update tbl_SecurityPinMaster set SecurityPin=@SecuritypinDisc,Status=@Status,Type='Discount' where UserId=@UserAutoId and Type='Discount'
					  end
					  else
					  begin
					       insert into tbl_SecurityPinMaster(SecurityPin,Status,UserId,Type)
					       values(@SecuritypinDisc,1,@UserAutoId,'Discount')
					  end
					  if(exists(select * from tbl_SecurityPinMaster where userid=@UserAutoId and Type='Withdraw'))
					   begin
					     update tbl_SecurityPinMaster set SecurityPin=@securityWithdraw,Status=@Status,Type='Withdraw' where UserId=@UserAutoId and Type='Withdraw'
					  end
					  else
					  begin
					       insert into tbl_SecurityPinMaster(SecurityPin,Status,UserId,Type)
					       values(@securityWithdraw,1,@UserAutoId,'Withdraw')
					  end
					end
					else
					begin
					   delete from tbl_SecurityPinMaster where UserId=@UserAutoId
					end



					SET @isException=0
					end
					else
					begin
						SET @isException=1
						SET @exceptionMessage='Login ID already exists!'
					end
				end
				else if(@opCode=22)
			    begin				
				   if not exists(select LoginID from UserDetailMaster where LoginID=@LoginID and UserAutoId!=@UserAutoId)     
					begin
				    update UserDetailMaster set Status=@Status,FirstName=@FirstName,LastName=@LastName,EmailID=@EmailID,
			   	    PhoneNo=@Phoneno,UserType=@UserType, [Password]=@Password,[LoginID]=@LoginID,UpdatedBy=@Who,UpdatedDate=GETDATE(),HourlyRate=@HourlyRate
					where UserAutoId=@UserAutoId;
					if(@UserType=(select AutoId from UserTypeMaster where usertype='Cashier'))
					begin
					   if(exists(select * from tbl_SecurityPinMaster where userid=@UserAutoId))
					   begin
					     update tbl_SecurityPinMaster set SecurityPin=@Securitypin,Status=@Status where UserId=@UserAutoId
					  end
					  else
					  begin
					       insert into tbl_SecurityPinMaster(SecurityPin,Status,UserId)
					       values(@Securitypin,1,@UserAutoId)
					  end
					end
					else
					begin
					   delete from tbl_SecurityPinMaster where UserId=@UserAutoId
					end
					 select [Userid],Password,UserAutoId, [LoginID], [UserType], [FirstName], [LastName], [EmailID], ([PhoneNo]) as [Contact], 
				     (select top 1 SecurityPin from tbl_SecurityPinMaster where UserId=UM.UserAutoId)SecurityPin, Status
				     from UserDetailMaster UM
				     where UserAutoId=@UserAutoId

					 select AutoId,UserType from [dbo].UserTypeMaster where Status=1
					SET @isException=0
					end
					else
					begin
						SET @isException=1
						SET @exceptionMessage='Login ID already exists!'
					end
				end
			else if(@opCode=31)
			begin
				set @Userid=(Select UserAutoId from UserDetailMaster where UserAutoId=@UserAutoId)
				 if not exists(select AutoId from UserLogInLogMaster where UserId=@Userid and Status='Success')
                   begin
	                   Delete from UserDetailMaster where UserAutoId=@UserAutoId


					   --select * from UserDetailMaster

					   --Select * from UserLogInLogMaster order by AutoId desc
	               end
	               else
	               begin
	                   SET @exceptionMessage= 'User is in use.'        
                       SET @isException=1   
	               end
				--delete from UserDetailMaster where UserAutoId=@UserAutoId
			end
			else if(@opCode=41)
			begin
				select [Userid],Password,UserAutoId, [LoginID],CompanyId ,[UserType], [FirstName], [LastName], [EmailID], ([PhoneNo]) as [Contact],HourlyRate, isnull(IsAppAllowed,'2') IsAppAllowed,
				isnull((select top 1 SecurityPin from tbl_SecurityPinMaster where UserId=UM.UserAutoId and Type='Admin'),'') SecurityPin,
				isnull((select top 1 SecurityPin from tbl_SecurityPinMaster where UserId=UM.UserAutoId and Type='Discount'),'') SecurityPinDisc,
				isnull((select top 1 SecurityPin from tbl_SecurityPinMaster where UserId=UM.UserAutoId and Type='Withdraw'),'') SecurityPinWith,
				Status
				from UserDetailMaster UM
				where UserAutoId=@UserAutoId   

				select AutoId,UserType from [dbo].UserTypeMaster where Status=1
				---select SecurityPin from tbl_SecurityPinMaster where UserId=@UserAutoId;

				select EmployeeId,CompanyId from EmployeeStoreList
				where EmployeeId=@UserAutoId and Status=1

				SET @isException=0
			end	
  else IF @opCode=45
  BEGIN
    select AutoId,UserType from [dbo].UserTypeMaster where Status=1
    select AutoId,CompanyName as CompanyId from CompanyProfile 
  END

  else IF @opCode=46
  BEGIN
    select AutoId,ModuleId,ModuleName  from ModuleMaster where Status=1 
  END

  else IF @opCode=47
  BEGIN
    select AutoId,PageName,PageId  from PageMaster where Status=1 and  ParentModuleAutoId=@ModuleId

	select distinct PM.AutoId,PM.PageName from UserWiseComponent UC 
	Inner Join ComponentMaster CM on CM.AutoId=UC.ComponentAutoId
	Inner Join PageMaster PM on PM.AutoId=CM.SubModuleAutoId
	where UC.UserAutoId=@UserAutoId
  END
  else IF @opCode=48
  BEGIN
    select AutoId,ComponentName,ComponentId,isnull((select '1' as c from UserWiseComponent where UserAutoId=@UserAutoId and ComponentAutoId=CM.AutoId),'0') as [Checked]   
   from ComponentMaster CM where Status=1 and  SubModuleAutoId=@ModuleId

	
  END
  else IF @opCode=49
  BEGIN
          delete from UserWiseComponent where UserAutoId=@UserAutoId and ComponentAutoId in (select convert(int,splitdata) from fnSplitString(@ComponentIdsList,','))
		  Insert into UserWiseComponent(UserAutoId,ComponentAutoId)
						select @UserAutoId,convert(int,splitdata) from fnSplitString(@ComponentIds,',')
  END
   else IF @opCode=50
  BEGIN
		select distinct MM.AutoId,MM.ModuleName from UserWiseComponent UC 
		Inner Join ComponentMaster CM on CM.AutoId=UC.ComponentAutoId
		Inner Join PageMaster PM on PM.AutoId=CM.SubModuleAutoId
		Inner Join ModuleMaster MM on MM.AutoId=PM.ParentModuleAutoId where UC.UserAutoId=@UserAutoId
  END
   else IF @opCode=51
  BEGIN
		select AutoId,CompanyName from CompanyProfile where Status=1
  END
IF @Opcode=42
  BEGIN
     SELECT ROW_NUMBER() over(order by FirstName asc) as RowNumber,cp.CompanyName as CompanyId,
     emp.UserAutoId, emp.FirstName+' '+isnull(emp.LastName,'')FirstName, emp.Status,emp.EmailId,emp.PhoneNo, empt.UserType,emp.LoginID,HourlyRate,IsAppAllowed  
     into #temp   
     FROM UserDetailMaster emp
    inner join UserTypeMaster empt on emp.UserType=empt.AutoId
    left join CompanyProfile cp on cp.AutoId=emp.CompanyId
    where emp.Status!=2 
--searching
   and (@CompanyId is null or @CompanyId=0 or emp.CompanyId=@CompanyId)
   and (@FirstName is null or @FirstName='' or  concat(FirstName,' ',LastName) like '%'+@FirstName+'%')
   and (@UserType is null or @UserType=0 or emp.UserType=@UserType)
   and (@Status is null or @Status=2 or emp.Status=@Status) 
   and(@EmailId is null or @EmailId='' or emp.EmailId  like '%'+@EmailId+'%')
   and(@Phoneno is null or @Phoneno='' or emp.PhoneNo like '%'+@Phoneno+'%')
    and(@LoginID is null or @LoginID='' or emp.LoginID like '%'+@LoginID+'%')
   order by FirstName asc	
     
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, '#Sort By: UserName asc' as SortByString 
   FROM #temp  
  
   Select  * from #temp t  
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))   
  order by  FirstName asc  
  END
	END TRY
	BEGIN CATCH
		
		SET @isException=1
		SET @exceptionMessage= ERROR_MESSAGE()
	END CATCH;
END