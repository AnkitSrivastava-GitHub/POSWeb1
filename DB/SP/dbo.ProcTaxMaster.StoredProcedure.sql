
ALTER  procedure [dbo].[ProcTaxMaster]  
@Opcode int=NULL,    
@TaxName varchar(200)=null,  
@Status int=null,  
@TaxPercentage decimal(18,3)=null,  
@TaxSPercentage decimal(18,3)=null,  
@TaxAutoId int=null,  
@TaxId varchar(20)=null,
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
      if exists(select TaxName from TaxMaster where TaxName=@TaxName) 
	   begin      
      SET @exceptionMessage= 'Tax Name already exists!'        
         SET @isException=1        
   end 
   else  
    BEGIN TRY
	   BEGIN TRAN
	   SET @TaxId = (SELECT DBO.SequenceCodeGenerator('TaxId')) 
	     insert into TaxMaster([TaxId], TaxName,TaxPer, Status)  
       values(@TaxId, @TaxName,@TaxPercentage,@Status) 
	      
	   UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='TaxId'  
			COMMIT TRANSACTION  
	   END TRY
	     BEGIN CATCH                                                                                                                                
			ROLLBACK TRAN                                                                                                                         
			Set @isException=1                                                                                                   
			Set @exceptionMessage=ERROR_MESSAGE()                                                               
		End Catch  
   END  
    
   IF @Opcode=42  
   BEGIN  
       SELECT  ROW_NUMBER() over(order by TaxName asc) as RowNumber,AutoId,TaxName,TaxPer,  Status  
       into #temp   
       FROM TaxMaster  
       where status!=2 and TaxName not like 'No Tax' and TaxPer!=0
       and (@TaxName is null or @TaxName='' or TaxName like '%'+@TaxName+'%')  
       and (@Status is null or @Status=2 or Status=@Status) 
       and (@TaxSPercentage is null or @TaxSPercentage=-1 or TaxPer=@TaxSPercentage)
       order by TaxName asc    
         
       SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: TaxName asc' as SortByString FROM #temp  
      
       Select  * from #temp t  
       WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))   
       order by  TaxName asc  
   END  
   IF @Opcode=21  
  BEGIN   
  if not exists(select AutoId from ProductUnitDetail where TaxAutoId=@TaxAutoId)
  begin
	Delete from TaxMaster where AutoId=@TaxAutoId
	end
	else
	begin
	  SET @exceptionMessage= 'Tax is in use.'        
      SET @isException=1   
	end
  END  
   IF @Opcode=41  
   BEGIN  
     select AutoId, TaxName,TaxPer, Status from TaxMaster where AutoId=@TaxAutoId  
   END  
   IF @Opcode=31  
    BEGIN
   if exists(select TaxName from TaxMaster where TaxName=@TaxName and AutoId!=@TaxAutoId)     
   Begin      
      SET @exceptionMessage= 'Tax already exists!'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
         Update TaxMaster set TaxName=@TaxName,TaxPer=@TaxPercentage,Status=@Status where AutoId=@TaxAutoId  

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
  
  