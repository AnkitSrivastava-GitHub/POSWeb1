
CREATE or alter PROCEDURE [dbo].[ProcTerminalLogInDetail]
   
	@TerminalId int=NULL,
	@TerminalName nvarchar(50)=NULL,
	@AutoId int=NULL,
	@CurrentUser nvarchar(50)=NULL,
	@opCode int=Null,
	@FromDate datetime=Null,
	@ToDate datetime=Null,
	@StoreId int=null,
	@PageIndex INT=1,
	@PageSize INT=10,
	@Who int=NULL,
	@isException bit out,
	@exceptionMessage nvarchar(500) out,
	@RecordCount INT=null
AS
BEGIN        
 BEGIN TRY        
  SET @exceptionMessage= 'Success'        
  SET @isException=0        
  if @opcode=41
BEGIN
    select TM.AutoId, (TM.TerminalName) as TerminalName
	from TerminalMaster TM Inner join CompanyProfile CP on TM.CompanyId=CP.AutoId
	where TM.CompanyId=@StoreId
END
  IF @Opcode=42      
 BEGIN   
   
   SELECT  ROW_NUMBER() over(order by tl.AutoId desc) as RowNumber,tm.AutoId,FirstName+' '+LastName as CurrentUser,
   tm.TerminalName,format(tl.LoginTime,'MM/dd/yyyy hh:mm tt')LoginTime
   into #temp       
   FROM TerminalLoginlog tl
   inner join TerminalMaster tm on tm.AutoId=tl.terminalid
   left join UserDetailMaster udm on udm.UserAutoId=tl.UserId
   where (@TerminalId is null or @TerminalId=0 or tm.AutoId=@TerminalId) 
   and (@StoreId is null or @StoreId=0 or tm.CompanyId=@StoreId)
   and (@FromDate is null or @ToDate is null or (convert(date,tl.LoginTime) between convert(date,@FromDate) and convert(date,@ToDate)))
   order by tl.AutoId desc 
         
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Login Date & Time desc' as SortByString FROM #temp      
      
   Select  * from #temp t      
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  RowNumber Asc      
   END     
 END TRY        
 BEGIN CATCH        
     SET @isException=1        
 SET @exceptionMessage= ERROR_MESSAGE()        
 END CATCH        
END  


GO
