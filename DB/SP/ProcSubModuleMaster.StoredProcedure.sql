Create or ALTER   procedure [dbo].[ProcSubModuleMaster] 
@Opcode int = null,
@ModuleId int = null,  
@SubModuleAutoId int = null,
@SubModuleId varchar(50) = null,
@SubModuleName varchar(50) = null,
@ModuleAutoId int = null,  
@SubModuleURL varchar(200) = null,
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
	If exists (select PageName from PageMaster where PageName=@SubModuleName)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Sub Module name already exists!'
    End  
	ELSE
	BEGIN
		BEGIN TRY
		BEGIN TRAN  
			SET @SubModuleId = (SELECT DBO.SequenceCodeGenerator('SubModuleId'))  	
			
			insert into PageMaster(PageId,PageName,ParentModuleAutoId,PageUrl,Status,StoreId,CreatedOn,CreatedBy)
			values (@SubModuleId,@SubModuleName,@ModuleId,@SubModuleURL,@Status,@StoreId,GETDATE(),@Who)

			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='SubModuleId'  
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
   if exists(select PageName from PageMaster where PageName=@SubModuleName and AutoId!=@SubModuleAutoId)     
   Begin      
      SET @exceptionMessage= 'Sub Module name already exists!'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
     UPDATE PageMaster SET PageName=@SubModuleName,PageUrl=@SubModuleURL,ParentModuleAutoId=@ModuleId,Status=@Status, [UpdatedBy]=@Who, UpdatedOn=getdate(),StoreId=@StoreId
	 WHERE AutoId = @SubModuleAutoId
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
	Delete from PageMaster where AutoId=@SubModuleAutoId	
  END    
If @Opcode = 41
begin
	select *
     from PageMaster 
	where
	AutoId=@SubModuleAutoId
	order by PageName
end
If @Opcode = 42
begin
	
		select ROW_NUMBER() over(order by PageName asc) as RowNumber,PM.AutoId,PageId,PageName,MM.ModuleName,PageUrl,Description,PM.Status,PM.StoreId,PM.CreatedOn,PM.CreatedBy,PM.UpdatedOn,PM.UpdatedBy
		into #tempT
		from PageMaster PM
		INNER JOIN ModuleMaster MM on MM.AutoId=PM.ParentModuleAutoId
		where    (@SubModuleName is null or @SubModuleName='' or PageName like '%'+@SubModuleName+'%')
	  and (@Status is null or @Status=2 or PM.Status=@Status) 
		ORDER BY PageName asc

	 SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Module Name asc' as SortByString FROM #tempT

	  Select  * from 
	  #tempT t
	  WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
	  order by  PageName asc
end
	
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
