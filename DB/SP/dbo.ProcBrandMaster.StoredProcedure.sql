
      
ALTER proc [dbo].[ProcBrandMaster]      
@Opcode int=NULL,   
@BrandId varchar(50)=null,  
@BrandName varchar(200)=null,      
@Status int=null,      
@BrandAutoId int=null,      
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
  IF @Opcode=11        
  BEGIN      
    if exists(select BrandName from BrandMaster where BrandName=@BrandName and Status!=2)     
	   begin      
      SET @exceptionMessage= 'Brand name already exists.'        
         SET @isException=1        
   end 
    else 
   begin      
       BEGIN TRY
	   BEGIN TRAN
	   SET @BrandId = (SELECT DBO.SequenceCodeGenerator('BrandId')) 

	   insert into BrandMaster(BrandId,BrandName, CreatedBy, CreatedDate, Status,APIStatus,IsDeleted)      
       values(@BrandId,@BrandName,@Who ,GETDATE(),@Status,0,0)  

	   UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='BrandId'  
	   
	   COMMIT TRANSACTION  
	   END TRY
	   BEGIN CATCH                                                                                                                                
			ROLLBACK TRAN                                                                                                                         
			Set @isException=1                                                                                                   
			Set @exceptionMessage=ERROR_MESSAGE()                                                                      
		End Catch  
   end        
   END  
  IF @Opcode=42      
  BEGIN   
   
   SELECT  ROW_NUMBER() over(order by BrandName asc) as RowNumber,AutoId,BrandName, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate, Status      
   into #temp       
   FROM BrandMaster      
   where status!=2  --2 is for deleted brands 
   and AutoId!=1
   and (@BrandName is null or @BrandName='' or BrandName like '%'+@BrandName+'%')      
   and (@Status is null or @Status=2 or Status=@Status)      
   order by BrandName asc        
         
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Brand Name asc' as SortByString FROM #temp      
      
   Select  * from #temp t      
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  BrandName asc      
   END      
  IF @Opcode=21      
  BEGIN   
  if not exists(select AutoId from ProductMaster where BrandId=@BrandAutoId)
  begin
	Delete from BrandMaster where AutoId=@BrandAutoId
	end
	else
	begin
	  SET @exceptionMessage= 'Brand is in use.'        
      SET @isException=1   
	end
    --update BrandMaster set Status=2, UpdatedBy=@Who, UpdatedDate=GETDATE() where AutoId=@BrandAutoId      
  END      
  IF @Opcode=41      
  begin
	select AutoId, BrandName,Status
	from BrandMaster 
	where --[IsDeleted]=0
	AutoId=@BrandAutoId
	order by BrandName
  end
  IF @Opcode=31      
  BEGIN
   if exists(select BrandName from BrandMaster where BrandName=@BrandName and Status!=2 and AutoId!=@BrandAutoId)     
   Begin      
      SET @exceptionMessage= 'Brand name already exists.'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
     Update BrandMaster set BrandName=@BrandName, Status=@Status, UpdatedBy=@Who, UpdatedDate=GETDATE() 
	 where AutoId=@BrandAutoId
   COMMIT TRANSACTION  
   END TRY
   BEGIN CATCH                                                                                                                                
   	ROLLBACK TRAN                                                                                                                         
   	Set @isException=1                                                                                                   
   	Set @exceptionMessage=ERROR_MESSAGE()                                                                      
   End Catch  
   end 
   END      
 END TRY        
 BEGIN CATCH        
     SET @isException=1        
 SET @exceptionMessage= ERROR_MESSAGE()        
 END CATCH        
END        