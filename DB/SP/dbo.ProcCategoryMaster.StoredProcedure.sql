

ALTER   procedure [dbo].[ProcCategoryMaster] 
@Opcode int = null,
@CategoryId varchar(50) = null,
@CategoryName varchar(50) = null,
@CategoryAutoId int = null,
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
	If exists (select CategoryName from CategoryMaster where CategoryName=@CategoryName)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Category name already exists.'
    End  
	ELSE
	BEGIN
		BEGIN TRY
		BEGIN TRAN  
			SET @CategoryId = (SELECT DBO.SequenceCodeGenerator('CategoryId'))  	
			
			insert into CategoryMaster(Categoryid, CategoryName,  Status, [CreatedBy], [CreatedDate], [IsDeleted],[APIStatus])
			values (@CategoryId, @CategoryName, @Status, @Who, GETDATE(), 0, 0)

			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CategoryId'  
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
   if exists(select CategoryName from CategoryMaster where CategoryName=@CategoryName and AutoId!=@CategoryAutoId)     
   Begin      
      SET @exceptionMessage= 'Category name already exists.'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
    UPDATE CategoryMaster SET CategoryName=@CategoryName, Status=@Status, [UpdatedBy]=@Who, [UpdatedDate]=getdate(), [APIStatus]=0 
	WHERE AutoId = @CategoryAutoId
   COMMIT TRANSACTION  
   END TRY
   BEGIN CATCH                                                                                                                                
   	ROLLBACK TRAN                                                                                                                         
   	Set @isException=1                                                                                                   
   	Set @exceptionMessage=ERROR_MESSAGE()                                                                      
   End Catch  
   END  
END  
If @Opcode = 31
BEGIN   
  if not exists(select AutoId from ProductMaster where CategoryId=@CategoryAutoId)
  begin
	Delete from CategoryMaster where AutoId=@CategoryAutoId
	end
	else
	begin
	  SET @exceptionMessage= 'Category is in use.'        
      SET @isException=1   
	end
  END    
If @Opcode = 41
begin
	select AutoId, CategoryName,Status
	--case when Status=1 then 'Active' else 'Inactive' end as Status 
	from CategoryMaster 
	where
	--[IsDeleted]=0
	AutoId=@CategoryAutoId
	order by CategoryName
end
If @Opcode = 42
begin
	
		select ROW_NUMBER() over(order by CategoryName asc) as RowNumber, AutoId, CategoryName as CategoryName,
		Status
		into #temp
		from CategoryMaster 
		where  [IsDeleted]=0 and AutoId!=1
	 
	  and (@CategoryName is null or @CategoryName='' or CategoryName like '%'+@CategoryName+'%')
	  and (@Status is null or @Status=2 or Status=@Status) 
		ORDER BY CategoryName asc

		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Category Name asc' as SortByString FROM #temp

	  Select  * from 
	  #temp t
	  WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
	  order by  CategoryName asc
end
	
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
