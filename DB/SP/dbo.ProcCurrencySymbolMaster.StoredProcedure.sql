Create or ALTER proc [dbo].[ProcCurrencySymbolMaster]      
@Opcode int=NULL,   
@CurrencyId varchar(50)=null,  
@CurrencyName varchar(200)=null,  
@CurrencySymbol nvarchar(10)=null,
@Status int=null,      
@CurrencyAutoId int=null,      
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
    if exists(select CurrencyName from CurrencySymbolMaster where CurrencyName=@CurrencyName and Status!=2)     
	   begin      
      SET @exceptionMessage= 'Currency name already exists.'        
         SET @isException=1        
   end 
    else 
   begin      
       BEGIN TRY
	   BEGIN TRAN	   

	   insert into CurrencySymbolMaster(CurrencyName,CurrencySymbol,Status,CreatedBy,CreatedDate)      
       values(@CurrencyName,@CurrencySymbol,@Status,@Who ,GETDATE())     
	   
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
   
   SELECT  ROW_NUMBER() over(order by CurrencyName asc) as RowNumber,AutoId,CurrencyName,CurrencySymbol, CreatedBy, CreatedDate, Status      
   into #temp       
   FROM CurrencySymbolMaster      
   where (@CurrencyName is null or @CurrencyName='' or CurrencyName like '%'+@CurrencyName+'%')
    and (@CurrencySymbol is null or @CurrencySymbol='' or CurrencySymbol like '%'+@CurrencySymbol+'%')
   and (@Status is null or @Status=2 or Status=@Status)      
   order by CurrencyName asc        
         
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Currency Name asc' as SortByString FROM #temp      
      
   Select  * from #temp t      
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  CurrencyName asc      
   END      
  IF @Opcode=21      
  BEGIN   
  if not exists(select AutoId from CompanyProfile where CurrencyId=@CurrencyAutoId)
  begin
	Delete from CurrencySymbolMaster where AutoId=@CurrencyAutoId
	end
	else
	begin
	  SET @exceptionMessage= 'Currency is in use.'        
      SET @isException=1   
	end      
  END      
  IF @Opcode=41      
  begin
	select AutoId, CurrencyName,CurrencySymbol,Status
	from CurrencySymbolMaster 
	where --[IsDeleted]=0
	AutoId=@CurrencyAutoId
	order by CurrencyName
  end
  IF @Opcode=31      
  BEGIN
   if exists(select CurrencyName from CurrencySymbolMaster where CurrencyName=@CurrencyName and Status!=2 and AutoId!=@CurrencyAutoId)     
   Begin      
      SET @exceptionMessage= 'Currency name already exists.'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
     Update CurrencySymbolMaster set CurrencyName=@CurrencyName,CurrencySymbol=@CurrencySymbol, Status=@Status 
	 where AutoId=@CurrencyAutoId
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