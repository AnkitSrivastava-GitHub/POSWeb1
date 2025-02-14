Alter   procedure [dbo].[ProcTerminalMaster]
@Opcode int= null,
@AutoId int=null,
@Terminalid varchar(50)=null,
@CompanyId int=null,
@TerminalName varchar(100)=null,
@TerminalAddress varchar(max)=null,
@CurrentUser varchar(50)=null,
@Status int=null,
@Who int=null,
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
If exists (select TerminalName from TerminalMaster where TerminalName=@TerminalName and CompanyId=@CompanyId)   
    Begin
        Set @isException=1
        SET @exceptionMessage='Terminal Name already exists!'
    End  
ELSE
 BEGIN
	BEGIN TRY
	BEGIN TRAN  	
	
		SET @TerminalId = (SELECT DBO.SequenceCodeGenerator('TerminalId'))  		 
		INSERT INTO TerminalMaster(CompanyId,TerminalName,TerminalAddress,Status,TerminalId,CreatedBy,CreatedDate,OccupyStatus,CurrentUser)
		values(@CompanyId,@TerminalName,@TerminalAddress,@Status,@Terminalid,@Who,GETDATE(),0,0)
		UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='TerminalId'  

	  COMMIT TRANSACTION    
    END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage='Oops! Something went wrong.Please try later.'                                                                      
	End Catch                                                                                                                                      
END
if @Opcode=42
BEGIN   
    
 SELECT  ROW_NUMBER() over(order by TerminalName asc) as RowNumber,tm.AutoId,tm.TerminalName, tm.CreatedBy,
   tm.CreatedDate, tm.UpdatedBy, tm.UpdatedDate, tm.Status ,cp.CompanyName as CompanyId,
   FirstName+' '+LastName as CurrentUser,
   case when tm.CurrentUser='' then 'Not In Use' else 'In Use' end as OccupyStatus    
   into #temp       
   FROM TerminalMaster tm
   left join UserDetailMaster ud on ud.UserAutoId=tm.CurrentUser
   left join CompanyProfile cp on cp.AutoId=tm.CompanyId
   where tm.status!=2  --2 is for deleted brands 
   --and AutoId!=1
   and (@TerminalName is null or @TerminalName='' or TerminalName like '%'+@TerminalName+'%')      
   and (@Status is null or @Status=2 or tm.Status=@Status)
   and (@CompanyId is null or @CompanyId=0 or tm.CompanyId=@CompanyId)
   and(@CurrentUser is null or @CurrentUser='' or ud.FirstName like '%'+@CurrentUser+'%')
   order by TerminalName asc        
         
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Terminal Name asc' as SortByString FROM #temp      
      
   Select  * from #temp     
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  TerminalName asc      
   END  
if @Opcode=21
if exists(select TerminalName from TerminalMaster where TerminalName=@TerminalName and Status!=2 and AutoId!=@AutoId and CompanyId=@CompanyId)     
   Begin      
      SET @exceptionMessage= 'Terminal name already exists!'        
      SET @isException=1        
   end 
   else 
 BEGIN
	BEGIN TRY
	if exists(select TerminalName from TerminalMaster where TerminalName=@TerminalName and OccupyStatus=1 and AutoId=@AutoId and CompanyId=@CompanyId)     
   Begin  
       if(@Status=0)
	    Begin
		  SET @exceptionMessage= 'Terminal is in use.'        
         SET @isException=1 
		END
		ELSE
	   BEGIN
	     UPDATE TerminalMaster set CompanyId=@CompanyId,TerminalName=@TerminalName,TerminalAddress=@TerminalAddress,Status=@Status
		,UpdatedBy=@Who,UpdatedDate=GETDATE() where AutoId=@AutoId
	   END
   END
   ELSE
   BEGIN
		UPDATE TerminalMaster set CompanyId=@CompanyId,TerminalName=@TerminalName,TerminalAddress=@TerminalAddress,Status=@Status
		,UpdatedBy=@Who,UpdatedDate=GETDATE() where AutoId=@AutoId
	END
    END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage='Oops! Something went wrong.Please try later.'                                                                      
	End Catch                                                                                                                                      
END
if @Opcode=31
 BEGIN
 if not exists(select AutoId from TerminalMaster where OccupyStatus=1 and AutoId=@AutoId)
  begin
	Delete from TerminalMaster where AutoId=@AutoId
	end
	else
	begin
	  SET @exceptionMessage= 'Terminal is in use.'        
      SET @isException=1   
	end
 --delete from  TerminalMaster where AutoId=@AutoId
 END
if @Opcode=41
 BEGIN
 select * from  TerminalMaster where AutoId=@AutoId

 select AutoId,CompanyName as CompanyId from  CompanyProfile 
 END
 if @Opcode=45
 BEGIN
   select CP.AutoId,CP.CompanyName as CompanyId from  CompanyProfile CP Inner join EmployeeStoreList ES on ES.CompanyId=CP.AutoId where ES.EmployeeId=@Who
 END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
