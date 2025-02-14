
ALTER procedure [dbo].[ProcAgeRestriction]
@Opcode int= null,
@AgeRestrictionAutoId int=notnull,
@AgeRestrictionName varchar(100)=null,
@Age int=null,
@SAge varchar(20)=null,
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
 if @Opcode=11
If exists (select AgeRestrictionName from AgeRestrictionMaster where AgeRestrictionName=@AgeRestrictionName)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Age Restriction name already exists!'
    End 
ELSE If exists (select * from AgeRestrictionMaster where Age=@Age)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Age already exists!'
    End
ELSE
 BEGIN
	BEGIN TRY
	BEGIN TRAN  			 
		INSERT INTO AgeRestrictionMaster(AgeRestrictionName,Age,Status)values(@AgeRestrictionName,@Age,1)

	  COMMIT TRANSACTION    
    END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                       
	End Catch                                                                                                                                      
END

if @Opcode=21

-- BEGIN
--	BEGIN TRY

--		UPDATE AgeRestrictionMaster set AgeRestrictionName=@AgeRestrictionName,Age=@Age where AutoId=@AgeRestrictionAutoId
	
--    END TRY                                                                                                                                      
--	BEGIN CATCH                                                                                                                                
--		ROLLBACK TRAN                                                                                                                         
--		Set @isException=1                                                                                                   
--		Set @exceptionMessage='Oops! Something went wrong.Please try later.'                                                                      
--	End Catch                                                                                                                                      
--END

 BEGIN
   if exists(select AgeRestrictionName from AgeRestrictionMaster where AgeRestrictionName=@AgeRestrictionName and AutoId!=@AgeRestrictionAutoId)     
   Begin      
      SET @exceptionMessage= 'Age Restriction already exists!'        
      SET @isException=1        
   end 
	ELSE If exists (select * from AgeRestrictionMaster where Age=@Age and AutoId!=@AgeRestrictionAutoId)   
	Begin
		Set @isException=1
		SET @exceptionMessage='Age already exists!'
   End
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
   UPDATE AgeRestrictionMaster set AgeRestrictionName=@AgeRestrictionName,Age=@Age where AutoId=@AgeRestrictionAutoId

   COMMIT TRANSACTION  
   END TRY
   BEGIN CATCH                                                                                                                                
   	ROLLBACK TRAN                                                                                                                         
   	Set @isException=1                                                                                                   
   	Set @exceptionMessage=ERROR_MESSAGE()                                                                       
   End Catch  
   end 
   END 

if @Opcode=31
 BEGIN   
  if ((not exists(select AutoId from ProductMaster where AgeRestrictionId=@AgeRestrictionAutoId)) and (not exists(select AutoId from DepartmentMaster where AgeRestrictionId=@AgeRestrictionAutoId and IsDeleted=0)))
  begin
	   Delete from AgeRestrictionMaster where AutoId=@AgeRestrictionAutoId
	end
	else
	begin
	  SET @exceptionMessage= 'Age is in use.'        
      SET @isException=1   
	end
  END  
 if @Opcode=41
 begin
	select AutoId, AgeRestrictionName,Age
	from AgeRestrictionMaster 
	where
	--[IsDeleted]=0
	AutoId=@AgeRestrictionAutoId
	order by AgeRestrictionName
end
if @Opcode=42
 BEGIN
 select  ROW_NUMBER() over(order by Age asc) as RowNumber,AutoId,AgeRestrictionName,Age
  into #temp
 from  AgeRestrictionMaster 
 where AgeRestrictionName not like 'No Age Restriction' and 
 (@AgeRestrictionName is null or @AgeRestrictionName='' or AgeRestrictionName like '%'+@AgeRestrictionName+'%')      
   and (@SAge is null or @SAge='' or Age like '%'+@SAge+'%')      
   order by Age asc  
   
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Age asc' as SortByString FROM #temp  
  
   Select  * from #temp t  
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))   
   order by  Age asc  
 END
 
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
