Create or ALTER   procedure [dbo].[ProcCurrencyMaster] 
@Opcode int = null,
@Amount decimal(18,2) = null,
@CurrencyAutoId int = null,
@StoreId int = null,
@Who int=null,
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
	If exists (select Amount from CurrencyMaster where Amount=@Amount)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Amount already exists!'
    End 
	ELSE
	BEGIN                   
		BEGIN TRY
		BEGIN TRAN 	
			
			insert into CurrencyMaster(Amount,Status,StoreId,CreatedOn,CreatedBy)
			values (@Amount,@Status,@StoreId,GETDATE(),@Who)
			  
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
   if exists(select Amount from CurrencyMaster where Amount=@Amount and AutoId!=@CurrencyAutoId)     
   Begin      
      SET @exceptionMessage= 'Amount already exists!'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
    UPDATE CurrencyMaster SET Amount=@Amount, Status=@Status, [CreatedBy]=@Who, CreatedOn=getdate(),StoreId=@StoreId
	 WHERE AutoId = @CurrencyAutoId
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
 
	select AutoId,Amount from CurrencyMaster 
	
  END 
If @Opcode = 31
BEGIN   
  --if not exists(select AutoId from SubCurrencyMaster where CategoryId=@CurrencyAutoId)
 -- begin
	Delete from CurrencyMaster where AutoId=@CurrencyAutoId
	--end
	--else
	--begin
	 -- SET @exceptionMessage= 'Currency is in use.'        
      --SET @isException=1   
	--end
  END    
If @Opcode = 41
begin
	select AutoId,Amount, Status,StoreId,CreatedOn,CreatedBy
     from CurrencyMaster 
	where
	AutoId=@CurrencyAutoId
	order by Amount
end
If @Opcode = 42
begin
	
		select ROW_NUMBER() over(order by Amount asc) as RowNumber,AutoId,Amount,Status,StoreId,CreatedOn,CreatedBy
		into #tempT
		from CurrencyMaster 
		where    (@Amount is null  or @Amount=0 or Amount=@Amount)
	  and (@Status is null or @Status=2 or Status=@Status) 
		ORDER BY Amount asc

	 SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Amount asc' as SortByString FROM #tempT

	  Select  * from 
	  #tempT t
	  WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
	  order by  Amount asc
end
	
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
