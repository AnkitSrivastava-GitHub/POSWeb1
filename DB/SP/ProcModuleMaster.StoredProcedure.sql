Create or ALTER   procedure [dbo].[ProcModuleMaster] 
@Opcode int = null,
@ModuleId varchar(50) = null,
@ModuleName varchar(100) = null,
@ModuleAutoId int = null,
@IsParent int = null,
@Parent int = null,
@SeqNo int = null,
@StoreId int = null,
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
	If exists (select ModuleName from ModuleMaster where ModuleName=@ModuleName)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Module name already exists!'
    End  
	Else If exists (select SequenceNo from ModuleMaster where SequenceNo=@SeqNo)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Sequence No already exists!'
    End 
	ELSE
	BEGIN
		BEGIN TRY
		BEGIN TRAN  
			SET @ModuleId = (SELECT DBO.SequenceCodeGenerator('ModuleId'))  	
			
			insert into ModuleMaster(ModuleId,ModuleName,Status,StoreId,CreatedOn,CreatedBy,SequenceNo)
			values (@ModuleId, @ModuleName,@Status,@StoreId,GETDATE(),@Who,@SeqNo)

			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='ModuleId'  
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
   if exists(select ModuleName from ModuleMaster where ModuleName=@ModuleName and AutoId!=@ModuleAutoId)     
   Begin      
      SET @exceptionMessage= 'Module name already exists!'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
    UPDATE ModuleMaster SET ModuleName=@ModuleName, Status=@Status, [UpdatedBy]=@Who, UpdatedOn=getdate(), SequenceNo=@SeqNo,StoreId=@StoreId
	 WHERE AutoId = @ModuleAutoId
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
 
	select AutoId,ModuleName from ModuleMaster 
	
  END 
If @Opcode = 31
BEGIN   
  --if not exists(select AutoId from SubModuleMaster where CategoryId=@ModuleAutoId)
 -- begin
	Delete from ModuleMaster where AutoId=@ModuleAutoId
	--end
	--else
	--begin
	 -- SET @exceptionMessage= 'Module is in use.'        
      --SET @isException=1   
	--end
  END    
If @Opcode = 41
begin
	select AutoId,ModuleId,ModuleName, Status,StoreId,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy,SequenceNo
     from ModuleMaster 
	where
	AutoId=@ModuleAutoId
	order by ModuleName
end
If @Opcode = 42
begin
	
		select ROW_NUMBER() over(order by ModuleName asc) as RowNumber,AutoId,ModuleId,ModuleName,Status,StoreId,CreatedOn,CreatedBy,UpdatedOn,UpdatedBy,SequenceNo
		into #tempT
		from ModuleMaster 
		where    (@ModuleName is null or @ModuleName='' or ModuleName like '%'+@ModuleName+'%')
	  and (@Status is null or @Status=2 or Status=@Status) 
		ORDER BY ModuleName asc

	 SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Module Name asc' as SortByString FROM #tempT

	  Select  * from 
	  #tempT t
	  WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
	  order by  ModuleName asc
end
	
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
