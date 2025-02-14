Alter    procedure [dbo].[ProcPayoutMaster]
@Opcode int= null,
@PayoutAutoId int=null,
@CompanyId int=null,
@Vendor int=null,
@Expense int=null,
@ShiftId int=null,
@PayoutType int=null,
@PayTo varchar(50)=null,
@TerminalAutoId int=null,
@TerminalId int=null,
@Remark varchar(200)=null,
@Amount decimal(18,2)=null,
@PayoutMode varchar(50)=null,
@TransactionId varchar(50)=null,
@CreatedDate datetime=null,
@ToDate datetime=null,
@FromDate datetime=null,
@PayoutId int=null,
@PayoutDate datetime=null,
@PayoutTime varchar(50)=null,
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
  BEGIN
	BEGIN TRY
	BEGIN TRAN  
	 --	if not exists(Select TransactionId from PayoutMaster where TransactionId=isnull(@TransactionId,'') and @PayoutMode=2)
		--Begin
				INSERT INTO PayoutMaster(PayTo,Remark,Amount,PayoutMode,TransactionId,CreatedBy,CreatedDate,CompanyId,Expense,Vendor,PayoutType,Terminal,PayoutDate,PayoutTime,ShiftId) 		   
				values(@PayTo,@Remark,@Amount,@PayoutMode,@TransactionId,@Who,GETDATE(),@CompanyId,@Expense,@Vendor,@PayoutType,@TerminalAutoId,@PayoutDate,@PayoutTime,@ShiftId)

				set @PayoutId=SCOPE_IDENTITY()

				INSERT INTO PayoutMasterLog(PayoutId,PayTo,Remark,Amount,PayoutMode,TransactionId,CreatedBy,CreatedDate,CompanyId,Expense,Vendor,PayoutType,Terminal,PayoutDate,PayoutTime,ShiftId) 		   
				values(@PayoutId,@PayTo,@Remark,@Amount,@PayoutMode,@TransactionId,@Who,GETDATE(),@CompanyId,@Expense,@Vendor,@PayoutType,@TerminalAutoId,@PayoutDate,@PayoutTime,@ShiftId)
		--End
		--else
		--Begin
		--  Set @isException=1
		--  Set @exceptionMessage='Transaction ID already exists.'
		--End
	  COMMIT TRANSACTION    
    END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
		ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                       
	End Catch                                                                                                                                      
END
if @Opcode=45
BEGIN 
	select AutoId,TerminalName from TerminalMaster where CompanyId=@CompanyId and Status=1
END
if @Opcode=42
 BEGIN   
   
   SELECT  ROW_NUMBER() over(order by pm.CreatedDate desc) as RowNumber,pm.AutoId,PayTo,Remark,Amount,cp.CompanyName,TM.TerminalName,
   PayoutMode,TransactionId, ud.FirstName+' '+ud.LastName as CreatedBy,EM.ExpenseName,VM.VendorName,PTM.PayoutType,format(pm.PayoutDate,'MM/dd/yyyy') as PayoutDate, pm.PayoutTime,
   format(pm.CreatedDate,'MM/dd/yyyy')CreatedDate,UTM.UserType      
   into #temp       
   FROM PayoutMaster pm
   inner join UserDetailMaster ud on ud.UserAutoId=pm.CreatedBy
   Inner JoIn UserTypeMaster UTM on UTM.AutoId=ud.UserType   
   Inner join TerminalMaster TM on TM.AutoId=pm.Terminal
    left join PayoutTypeMaster PTM on PTM.AutoId=pm.PayoutType
	left join ExpenseMaster EM on EM.AutoId=pm.Expense
	left join VendorMaster VM on VM.AutoId=pm.Vendor
   left join CompanyProfile cp on cp.AutoId=pm.CompanyId
   where (@PayTo is null or @PayTo='' or PayTo like @PayTo+'%') 
   and(@Amount is null or @Amount=0 or Amount=@Amount)
   and (@CompanyId is null or @CompanyId=0 or pm.CompanyId=@CompanyId)
   and (@PayoutType is null or @PayoutType=0 or PTM.AutoId=@PayoutType)
    and (@TerminalAutoId is null or @TerminalAutoId=0 or TM.AutoId=@TerminalAutoId)
   and (@Expense is null or @Expense=0 or  EM.AutoId=@Expense)
   and (@Vendor is null or @Vendor=0 or VM.AutoId=@Vendor)
   and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or ( convert(date,pm.CreatedDate) between convert(date,@FromDate) and convert(date,@ToDate)))
   order by CreatedDate desc 

       
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Created Date  desc' as SortByString FROM #temp      
      
   Select  * from #temp t      
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  CreatedDate desc 

   SELECT SUM(Amount) As TotalAmount FROM #temp;
   END
if @Opcode=43
 BEGIN   
   SELECT  ROW_NUMBER() over(order by pm.CreatedDate desc) as RowNumber,pm.AutoId,PayTo,Remark,Amount,cp.CompanyName,
   PayoutMode,TransactionId, ud.FirstName+' '+ud.LastName as CreatedBy,pm.CreatedBy as EmpId,EM.ExpenseName,VM.VendorName,PTM.PayoutType, 
   format(pm.CreatedDate,'MM/dd/yyyy')CreatedDate, format(pm.PayoutDate,'MM/dd/yyyy') as PayoutDate,pm.PayoutTime      
   into #temp2       
   FROM PayoutMaster pm
   inner join UserDetailMaster ud on ud.UserAutoId=pm.CreatedBy
    left join PayoutTypeMaster PTM on PTM.AutoId=pm.PayoutType
	left join ExpenseMaster EM on EM.AutoId=pm.Expense
	left join VendorMaster VM on VM.AutoId=pm.Vendor
   left join CompanyProfile cp on cp.AutoId=pm.CompanyId
  where (@PayTo is null or @PayTo='' or PayTo like @PayTo+'%') 
   and(@Amount is null or @Amount=0 or Amount=@Amount)
   and (@CompanyId is null or @CompanyId=0 or pm.CompanyId=@CompanyId)
   and (@PayoutType is null or @PayoutType=0 or PTM.AutoId=@PayoutType)
   and (@Expense is null or @Expense=0 or  EM.AutoId=@Expense)
   and (@Vendor is null or @Vendor=0 or VM.AutoId=@Vendor)
   --and (@Who is null or @Who=1 or pm.CreatedBy=@Who)
   and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or ( convert(date,pm.CreatedDate) between convert(date,@FromDate) and convert(date,@ToDate)))
   order by CreatedDate desc 

       
   SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Created Date  desc' as SortByString FROM #temp2      
      
   Select  * from #temp2 t      
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
   order by  CreatedDate desc 

   SELECT SUM(Amount) As TotalAmount FROM #temp2;
   END
if @Opcode=21
BEGIN
--if not exists(Select TransactionId from PayoutMaster where TransactionId=@TransactionId and AutoId!=@PayoutAutoId and @PayoutMode='Online')
--		Begin
		     UPDATE PayoutMaster set PayTo=@PayTo,Remark=@Remark,Amount=@Amount,PayoutMode=@PayoutMode,CompanyId=@CompanyId,Expense=@Expense,Vendor=@Vendor,PayoutType=@PayoutType,
             TransactionId=@TransactionId,Terminal=@TerminalAutoId,PayoutDate=@PayoutDate,PayoutTime=@PayoutTime where AutoId=@PayoutAutoId

			 UPDATE PayoutMasterLog set PayTo=@PayTo,Remark=@Remark,Amount=@Amount,PayoutMode=@PayoutMode,CompanyId=@CompanyId,Expense=@Expense,Vendor=@Vendor,PayoutType=@PayoutType,
             TransactionId=@TransactionId,Terminal=@TerminalAutoId,PayoutDate=@PayoutDate,PayoutTime=@PayoutTime,UpdatedBy=@Who,UpdateDate=GETDATE() where PayoutId=@PayoutAutoId
		--End
		--else
		--Begin
		--  Set @isException=1
		--  Set @exceptionMessage='Transaction ID already exists.'
		--End
  
END
if @Opcode=31
 BEGIN
 delete from  PayoutMaster where AutoId=@PayoutAutoId
 END
if @Opcode=41
 BEGIN
 select AutoId,PayTo,Remark,Amount,PayoutMode,TransactionId,CreatedBy,CreatedDate,CompanyId,Expense,Vendor,PayoutType,isnull(Terminal,0) as Terminal,
 format(PayoutDate,'MM/dd/yyyy') as PayoutDate,PayoutTime from  PayoutMaster where AutoId=@PayoutAutoId
 END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
