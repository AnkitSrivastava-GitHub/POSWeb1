Create or ALTER   procedure [dbo].[ProcExpenseMaster] 
@Opcode int = null,
@ExpenseId varchar(50) = null,
@ExpenseName varchar(50) = null,
@ExpenseAutoId int = null,
@StoreId int = null,
@TerminalId int=null,
@FromDate datetime=null,
@ToDate datetime=null,
@Who varchar(50)=null,
@Userid varchar(50)=null,
@Status int=null,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
begin
BEGIN TRY
SET @isException=0
SET @exceptionMessage='Success!!'
If @Opcode = 11
Begin
	If exists (select ExpenseName from ExpenseMaster where ExpenseName=trim(@ExpenseName) and StoreId=@StoreId)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Expense name already exists.'
    End 
	ELSE
	BEGIN                   
		BEGIN TRY
		BEGIN TRAN  
			SET @ExpenseId = (SELECT DBO.SequenceCodeGenerator('ExpenseId'))  	
			
			insert into ExpenseMaster(ExpenseId,ExpenseName,Status,StoreId,CreatedOn,CreatedBy)
			values (@ExpenseId, @ExpenseName,@Status,@StoreId,GETDATE(),@Who)

			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='ExpenseId'  
			COMMIT TRANSACTION    
		END TRY                                                                                                                                      
		BEGIN CATCH                                                                                                                                
			ROLLBACK TRAN                                                                                                                         
			Set @isException=1                                                                                                   
			Set @exceptionMessage=ERROR_MESSAGE()                                                                       
		End Catch      
	END
End
If @Opcode = 21
  BEGIN
   if exists(select ExpenseName from ExpenseMaster where ExpenseName=trim(@ExpenseName) and AutoId!=@ExpenseAutoId and StoreId=@StoreId)     
   Begin      
      SET @exceptionMessage= 'Expense name already exists!'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
    UPDATE ExpenseMaster SET ExpenseName=@ExpenseName, Status=@Status, [UpdatedBy]=@Who, UpdatedOn=getdate(),StoreId=@StoreId
	 WHERE AutoId = @ExpenseAutoId
   COMMIT TRANSACTION  
   END TRY
   BEGIN CATCH                                                                                                                                
   	ROLLBACK TRAN                                                                                                                         
   	Set @isException=1                                                                                                   
   	Set @exceptionMessage=ERROR_MESSAGE()                                                                      
   End Catch  
   END  
END  
If @Opcode = 51
BEGIN   
 
	select AutoId,ExpenseName from ExpenseMaster 
	
  END 
If @Opcode = 31
BEGIN   
  if not exists(select Expense from PayoutMaster where CompanyId=@StoreId and Expense=@ExpenseAutoId)
  begin
	Delete from ExpenseMaster where AutoId=@ExpenseAutoId
	end
	else
	begin
	  SET @exceptionMessage= 'Expense is in use.'        
      SET @isException=1   
	end
  END    
If @Opcode = 41
begin
	select AutoId,ExpenseId,ExpenseName, Status,StoreId,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy
     from ExpenseMaster 
	where
	AutoId=@ExpenseAutoId
	order by ExpenseName
end
If @Opcode = 42
begin	
		select ROW_NUMBER() over(order by ExpenseName asc) as RowNumber,AutoId,ExpenseId,ExpenseName,Status,StoreId,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy
		into #tempT
		from ExpenseMaster 
		where  StoreId=@StoreId 
		and  (@ExpenseName is null or @ExpenseName='' or ExpenseName like '%'+@ExpenseName+'%')
		and (@Status is null or @Status=2 or Status=@Status) 
		ORDER BY ExpenseName asc

		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Expense Name asc' as SortByString FROM #tempT

		Select  * from 
		#tempT t
		WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
		order by  ExpenseName asc
end
If @Opcode = 22
begin
	select AutoId,ExpenseName from ExpenseMaster where Status=1 and StoreId=@StoreId	
	order by ExpenseName

	select AutoId,TerminalName from TerminalMaster where Status=1 and CompanyId=@StoreId	
	order by TerminalName
end
If @Opcode = 23
	begin

		select ROW_NUMBER() over(order by PM.AutoId asc) as RowNumber,PM.AutoId,PM.PayTo,PM.Remark,PM.Amount,PM.PayoutMode,PM.TransactionId,UM.FirstName+isnull(' '+UM.LastName,'')+'<br/>'+format(PM.CreatedDate, 'MM/dd/yyyy hh:mm tt') as CreationDetail,
		EM.ExpenseName as Expense,PT.PayoutType,TM.TerminalName,format(PM.PayoutDate, 'MM/dd/yyyy') as PayoutDate,PM.PayoutTime
		into #tempTE
		from PayoutMaster PM 
		Left join TerminalMaster TM on TM.AutoId=PM.Terminal
		Inner join UserDetailMaster UM on UM.UserAutoId=PM.CreatedBy
		Inner Join PayoutTypeMaster PT on PT.AutoId=PM.PayoutType
		Inner join ExpenseMaster EM on EM.AutoId=PM.Expense
		where PM.Expense is not null and PM.Expense!=0
		and PM.CompanyId=@StoreId
		and (@TerminalId is null or @TerminalId=0 or PM.Terminal=@TerminalId) 
		and (@ExpenseAutoId is null or @ExpenseAutoId=0 or PM.Expense=@ExpenseAutoId) 
		and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or (convert(date,PM.PayoutDate) between convert(date,@FromDate) and convert(date,@ToDate)))
		order by PM.AutoId asc

		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Date asc' as SortByString FROM #tempTE 

		Select  * from 
		#tempTE t
		WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
		order by AutoId asc
	end	
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
