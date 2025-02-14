alter proc [dbo].[ProcChangeStore]
@Opcode int= null,
@CompanyId int=null,
@EmployeeId  int=null,
@LogInAutoId int=null,
@Who int=null,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
begin
BEGIN TRY
SET @isException=0
SET @exceptionMessage='Success!'
if @Opcode=41
 BEGIN
   select CP.AutoId,CompanyName
   from EmployeeStoreList ESL
   inner join CompanyProfile CP on CP.AutoId=ESL.CompanyId and CP.Status=1
   where EmployeeId=@EmployeeId order by CompanyName
 END
 if @Opcode=42
 BEGIN
   if exists(select * from EmployeeStoreList where EmployeeId=@EmployeeId and CompanyId=@CompanyId and status=1)
   begin

        insert into StoreLoginLog(UserId,CompanyId,LoginTime,Status,LogInAutoId)
		values(@EmployeeId,@CompanyId,GETDATE(),'Success',@LogInAutoId)

		select CP.AutoId as StoreId,CP.CompanyName,'Success' as Message,CSM.CurrencySymbol as CurrencySymbol from CompanyProfile CP
		left join CurrencySymbolMaster CSM on CSM.AutoId=CP.CurrencyId
		where CP.AutoId=@CompanyId
		--select @CompanyId as StoreId,'Success' as Message
		SET @isException=0
        SET @exceptionMessage='true'
   end
   else
   begin
        insert into StoreLoginLog(UserId,CompanyId,LoginTime,Status,LogInAutoId)
		values(@EmployeeId,@CompanyId,GETDATE(),'Failed',@LogInAutoId)
		SET @isException=1
        SET @exceptionMessage='Store Login Failed'
   end
 END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
