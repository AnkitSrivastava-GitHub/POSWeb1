Create or ALTER   procedure [dbo].[ProcComponentMaster] 
@Opcode int = null,
@ModuleId int = null,  
@SubModuleId int = null,
@ComponentId varchar(50) = null,
@ComponentName varchar(100) = null,
@ComponentAutoId int = null,
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
	If exists (select ComponentName from ComponentMaster where ComponentName=@ComponentName)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Component name already exists!'
    End  
	ELSE
	BEGIN
		BEGIN TRY
		BEGIN TRAN  
			SET @ComponentId = (SELECT DBO.SequenceCodeGenerator('ComponentId'))  	
			
			insert into ComponentMaster(ComponentId,ComponentName,ModuleAutoId,SubModuleAutoId,Status,StoreId,CreatedOn,CreatedBy)
			values (@ComponentId,@ComponentName,@ModuleId,@SubModuleId,@Status,@StoreId,GETDATE(),@Who)

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
   if exists(select  ComponentName from ComponentMaster where ComponentName=@ComponentName and AutoId!=@ComponentAutoId)     
   Begin      
      SET @exceptionMessage= 'Sub Module name already exists!'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
    UPDATE ComponentMaster SET ComponentName=@ComponentName,ModuleAutoId=@ModuleId,SubModuleAutoId=@SubModuleId,Status=@Status, [UpdatedBy]=@Who, UpdatedOn=getdate(),StoreId=@StoreId
	 WHERE AutoId = @ComponentAutoId
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
	select AutoId,ModuleName from ModuleMaster where Status=1
  END 
  If @Opcode = 61
BEGIN  
	select AutoId,PageName from PageMaster where Status=1 and ParentModuleAutoId=@ModuleId
  END 
If @Opcode = 31
BEGIN   
	Delete from ComponentMaster where AutoId=@ComponentAutoId	
  END    
If @Opcode = 41
begin
DECLARE @MId int= null
	select * from ComponentMaster where	AutoId=@ComponentAutoId order by ComponentName

	set @MId=(select ModuleAutoId from ComponentMaster where	AutoId=@ComponentAutoId)
	select AutoId,PageName from PageMaster where Status=1 and ParentModuleAutoId=@MId
end
If @Opcode = 42
begin
	
		select ROW_NUMBER() over(order by ComponentName asc) as RowNumber,CM.AutoId,CM.ComponentName,MM.ModuleName,PM.PageName,CM.Status,CM.StoreId,CM.CreatedOn,CM.CreatedBy,
		CM.UpdatedOn,CM.UpdatedBy,CM.ComponentId
		into #tempT
		from ComponentMaster CM
		INNER JOIN ModuleMaster MM on MM.AutoId=CM.ModuleAutoId
		INNER JOIN PageMaster PM on PM.AutoId=CM.SubModuleAutoId
		where    (@ComponentName is null or @ComponentName='' or ComponentName like '%'+@ComponentName+'%')
	  and (@Status is null or @Status=2 or CM.Status=@Status) 
		ORDER BY PageName asc

	 SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Compomnent Name asc' as SortByString FROM #tempT

	  Select  * from 
	  #tempT t
	  WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
	  order by  ComponentName asc
end
	
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
