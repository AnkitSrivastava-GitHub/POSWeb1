create or alter PROCEDURE [dbo].[ProcLogInLogDetail]
	@Userid int=NULL,
	@UserName nvarchar(50)=NULL,
	@Status int=NULL,
	@Store int=NULL,
	@StoreId  int=NULL,
	@UStatus varchar(30)=NULL,
	@LoginID nvarchar(50)=NULL,
	@opCode int=Null,
	@FromDate datetime=Null,
	@ToDate datetime=Null,
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
select UserAutoId, FirstName +' '+ISNULL(LastName,'') UserName
	from UserDetailMaster 
END
  IF @Opcode=42      
 BEGIN

   select ROW_NUMBER() over(order by LogInDate desc) as RowNumber,ULM.AutoId, 
   isnull(UDM.FirstName+isnull(' '+UDM.LastName,''),ULM.LogInID )UserName,
   UTM.UserType, IPAddress,  format(LogInDate,'MM/dd/yyyy hh:mm tt')LogInDate, ULM.Status   
   into #temp1
   from UserLogInLogMaster ULM
   left join UserDetailMaster UDM on UDM.UserAutoId=isnull(ULM.UserId,'')
   left join UserTypeMaster UTM on UTM.AutoId=UDM.UserType
   where  (@UStatus is null or @UStatus='2' or ULM.Status=@UStatus)
   --and (@Store is null or @Store=0 or SL.CompanyId=@Store)
   and (@UserName is null or @UserName='0' or ULM.UserId like '%'+@UserName+'%')  
   and (@FromDate is null or @ToDate is null or (convert(date,LogInDate) between convert(date,@FromDate) and convert(date,@ToDate)))
   order by ULM.AutoId desc 
       
         
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Login Date desc' as SortByString FROM #temp1      
      
   Select  * from #temp1 t      
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  AutoId desc      
   END  
    IF @Opcode=43      
 BEGIN

    SELECT  ROW_NUMBER() over(order by LogInDate desc) as RowNumber,ulm.AutoId,udm.FirstName +' '+ISNULL(LastName,'') UserName,IPAddress,CP.CompanyName as Store,TM.TerminalName,
   format(LogInDate,'MM/dd/yyyy hh:mm tt')LogInDate, ulm.Status     
   into #temp       
   FROM UserLogInLogMaster ulm
   left join UserDetailMaster udm on udm.UserAutoId=ulm.UserId
   left Join StoreLoginLog SL on SL.LogInAutoId=ulm.AutoId
   left Join CompanyProfile CP on CP.AutoId=SL.CompanyId
   left join TerminalLoginLog TL on TL.LogInAutoId=ulm.AutoId
   left Join TerminalMaster TM on TM.AutoId=TL.TerminalId
   where (@UStatus is null or @UStatus='2' or ulm.Status=@UStatus)
   and (@Store is null or @Store=0 or SL.CompanyId=@Store)
    and (@UserName is null or @UserName='0' or ulm.UserId like '%'+@UserName+'%')  
   and (@FromDate is null or @ToDate is null or (convert(date,LogInDate) between convert(date,@FromDate) and convert(date,@ToDate)))
   order by AutoId desc 
       
         
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Login Date desc' as SortByString FROM #temp      
      
   Select  * from #temp t      
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  AutoId desc      
   END 
   
   if @opcode=421
   BEGIN
        select UserAutoId, FirstName +' '+ISNULL(LastName,'') UserName
	    from UserDetailMaster 
		where UserAutoId in (select distinct EmployeeId from EmployeeStoreList where CompanyId=@StoreId)
END
if @opcode=422
   BEGIN
        select ROW_NUMBER() over(order by SLL.AutoId desc)RowNumber, SLL.AutoId,SLL.CompanyId,CP.CompanyName, UDM.FirstName+isnull(' '+UDM.LastName,'') UserName,
        format(SLL.LoginTime,'MM/dd/yyyy hh:mm tt')LoginTime,SLL.Status,UTM.UserType,
		(select top 1 IPAddress from UserLogInLogMaster where AutoId=SLL.LogInAutoId)IPAddress
		into #StoreLogtemp
        from StoreLoginLog SLL
        inner join CompanyProfile CP on CP.AutoId=SLL.CompanyId
        inner join UserDetailMaster UDM on UDM.UserAutoId=SLL.UserId
		left join UserTypeMaster UTM on UTM.AutoId=UDM.UserType 
		where (@UStatus is null or @UStatus='2' or SLL.Status=@UStatus)
        and (@StoreId is null or @StoreId=0 or SLL.CompanyId=@StoreId)
        and (@UserName is null or @UserName='0' or  UDM.FirstName+isnull(' '+UDM.LastName,'') like '%'+@UserName+'%')  
        and (@FromDate is null or @ToDate is null or (convert(date,LoginTime) between convert(date,@FromDate) and convert(date,@ToDate)))
        order by SLL.AutoId desc 

		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Login Date desc' as SortByString FROM #StoreLogtemp      
      
        Select  * from #StoreLogtemp t      
        WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
        order by  AutoId desc    
END
 END TRY        
 BEGIN CATCH        
     SET @isException=1        
     SET @exceptionMessage= ERROR_MESSAGE()        
 END CATCH        
END  


GO
