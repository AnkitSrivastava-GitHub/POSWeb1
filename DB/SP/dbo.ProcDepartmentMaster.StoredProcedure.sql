     
Create or alter proc [dbo].[ProcDepartmentMaster]      
@Opcode int=NULL,   
@DepartmentId varchar(50)=null,  
@DepartmentName varchar(200)=null, 
@AgeRestrictionId int=null,
@DepartmentAutoId int=null,
@Status int=null,            
@Who int=null,      
@PageIndex INT = 1,        
@PageSize INT = 10,        
@RecordCount INT =null,        
@isException bit out,        
@exceptionMessage varchar(max) out      
AS        
BEGIN        
 BEGIN TRY        
  SET @exceptionMessage= 'Success'        
  SET @isException=0        
   IF (@Opcode=11)
   if exists(select DepartmentName from DepartmentMaster where DepartmentName=trim(@DepartmentName) and Status!=2)     
   begin      
         SET @exceptionMessage= 'Department name already exists.'        
         SET @isException=1        
    end 
	else if ((select count(*) from AgeRestrictionMaster where AutoId=@AgeRestrictionId)=0)
	begin
	     SET @exceptionMessage= 'Age restriction does not exists.'        
         SET @isException=1
	end
    else
    BEGIN           
       BEGIN TRY
	   BEGIN TRAN	   
	   SET @DepartmentId = (SELECT DBO.SequenceCodeGenerator('DepartmentId')) 
	   insert into DepartmentMaster(DepartmentId,DepartmentName,AgeRestrictionId, CreatedBy, CreatedDate, Status,IsDeleted)      
       values(@DepartmentId,@DepartmentName,@AgeRestrictionId,@Who ,GETDATE(),@Status,0) 

	   	declare @AutoId int;
		set @AutoId=SCOPE_IDENTITY()

      insert into DepartmentMasterLog(ReferenceID,[DepartmentId], [DepartmentName], [AgeRestrictionId], [UpdatedBy],
	  [UpdatedDate], [Status], [IsDeleted])
      select AutoId, [DepartmentId], [DepartmentName], [AgeRestrictionId], @Who ,GETDATE(),[Status], [IsDeleted] 
	  from DepartmentMaster where AutoId=@AutoId  

	   UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='DepartmentId'  
	   
	   COMMIT TRANSACTION  
	   END TRY
	   BEGIN CATCH                                                                                                                                
			ROLLBACK TRAN                                                                                                                         
			Set @isException=1                                                                                                   
			Set @exceptionMessage=ERROR_MESSAGE()                                                                      
		End Catch         
   END 
   IF @Opcode=45
   BEGIN
     select AutoId,AgeRestrictionName from AgeRestrictionMaster where isnull(Status,0)=1 order by [Age] asc
   END
  IF @Opcode=42      
  BEGIN   
  
   SELECT  ROW_NUMBER() over(order by DepartmentName asc) as RowNumber,DM.AutoId,DepartmentName,AGM.AgeRestrictionName, CreatedBy, CreatedDate, DM.Status      
   into #temp       
   FROM DepartmentMaster DM
   inner join AgeRestrictionMaster AGM on AGM.AutoId=DM.AgeRestrictionId
   where DM.status!=2 and DepartmentName!='Other Department' and DM.AutoId!=1 --2 is for deleted brands  and 
   and (@DepartmentName is null or @DepartmentName='' or DepartmentName like '%'+@DepartmentName+'%')      
   and (@Status is null or @Status=2 or DM.Status=@Status)      
   order by DepartmentName asc        
         
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Department Name asc' as SortByString FROM #temp      
      
   Select  * from #temp t      
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  DepartmentName asc      
   END      
  IF @Opcode=21      
  BEGIN   
      if exists(select * from ProductMaster PM where DeptId=@DepartmentAutoId and AutoId in (select distinct ProductId from StoreWiseProductList where ProductId=PM.AutoId and Status=1))
      begin
	        Set @isException=1                                                                                                   
			Set @exceptionMessage='Department is in use.'  
	  end
	  else
	  begin
	  insert into DepartmentMasterLog(ReferenceID,[DepartmentId], [DepartmentName], [AgeRestrictionId], [UpdatedBy],
	  [UpdatedDate], [Status], [IsDeleted])
      select AutoId, [DepartmentId], [DepartmentName], [AgeRestrictionId], @Who ,GETDATE(),[Status], [IsDeleted] 
	  from DepartmentMaster where AutoId=@DepartmentAutoId  
      --delete from DepartmentMaster where AutoId=@DepartmentAutoId  

	  update DepartmentMaster set IsDeleted=1 , Status=2 where AutoId=@DepartmentAutoId
	  end
	

  END      
  IF @Opcode=41      
  begin
	select AutoId, DepartmentName,AgeRestrictionId,Status from DepartmentMaster where AutoId=@DepartmentAutoId
  end
  IF @Opcode=31      
  BEGIN
        
   BEGIN TRY	
   BEGIN TRAN
   if exists(select DepartmentName from DepartmentMaster where DepartmentName=trim(@DepartmentName) and AutoId!=@DepartmentAutoId and Status!=2)     
	   begin      
         SET @exceptionMessage= 'Department name already exists.'        
         SET @isException=1        
    end 
	else if not exists(select * from AgeRestrictionMaster where AutoId=@AgeRestrictionId)
	begin
	     SET @exceptionMessage= 'Age restriction does not exists.'        
         SET @isException=1
	end
    else
    BEGIN
         Update DepartmentMaster set DepartmentName=@DepartmentName, Status=@Status,AgeRestrictionId=@AgeRestrictionId  
	     where AutoId=@DepartmentAutoId

	     insert into DepartmentMasterLog(ReferenceID,[DepartmentId], [DepartmentName], [AgeRestrictionId], [UpdatedBy],
	     [UpdatedDate], [Status], [IsDeleted])
         select AutoId, [DepartmentId], [DepartmentName], [AgeRestrictionId], @Who ,GETDATE(),[Status], [IsDeleted] 
	     from DepartmentMaster where AutoId=@DepartmentAutoId
	 end
   COMMIT TRANSACTION  
   END TRY
   BEGIN CATCH                                                                                                                                
   	ROLLBACK TRAN                                                                                                                         
   	Set @isException=1                                                                                                   
   	Set @exceptionMessage=ERROR_MESSAGE()                                                                      
   End Catch  
   END      
 END TRY        
 BEGIN CATCH        
     SET @isException=1        
 SET @exceptionMessage= ERROR_MESSAGE()        
 END CATCH        
END        
GO
