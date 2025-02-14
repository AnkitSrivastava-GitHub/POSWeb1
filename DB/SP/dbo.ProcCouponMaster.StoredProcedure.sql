alter  procedure [dbo].[ProcCouponMaster]
@Opcode int= null,
@AutoId int=null,
@CouponName varchar(200)=null,
@CouponCode varchar(200)=null,
@CouponAmount decimal(18,3)=null,
@StoreIdString varchar(max)=null,
@CouponAutoId int=null,
@StoreId int=null,
@TermsAndDescription varchar(MAX)=null,
@CouponType int=null,
@Discount decimal(18,3)=null,
@StartDate datetime=null,
@EndDate datetime=null,
@Status int=null,
@UseStatus int=null,
@Who int=null,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as
BEGIN
BEGIN TRY
SET @isException=0
SET @exceptionMessage='Success!'
 if @Opcode=11
--If exists (select CouponName from CouponMaster where CouponName=@CouponName )  
--    Begin
--        Set @isException=1
--        SET @exceptionMessage='Coupon name already exists!'   and CAST(CouponCode AS VARBINARY(10)) = CAST(@CouponCode AS VARBINARY(10))
--    End  
--ELSE
If exists (select CouponCode from CouponMaster cm where CAST(CouponCode AS VARBINARY(100)) = CAST(trim(@CouponCode) AS VARBINARY(100)) and StoreId=@StoreId)  
Begin
    Set @isException=1
    SET @exceptionMessage='Coupon Code already exists!'
End  
ELSE
 BEGIN
      INSERT INTO CouponMaster(CouponName,CouponCode,CouponAmount,CreatedDate,TermsAndDescription,CouponType,Discount,StartDate,EndDate,Status,StoreId,CreatedBy,UpdatedBy)
      values(@CouponName,@CouponCode,@CouponAmount,GETDATE(),@TermsAndDescription,@CouponType,@Discount,@StartDate,@EndDate,@Status,@StoreId,@Who,@Who)
END

if @Opcode=21

 BEGIN
 BEGIN TRY
      If exists (select CouponCode from CouponMaster where CAST(CouponCode AS VARBINARY(100)) = CAST(trim(@CouponCode) AS VARBINARY(100)) and StoreId=@StoreId and AutoId!=@CouponAutoId)  
         Begin
             Set @isException=1
             SET @exceptionMessage='Coupon Code already exists!'
         End  
      ELSE
      BEGIN
          UPDATE CouponMaster set CouponName=@CouponName,CouponCode=@CouponCode,CouponAmount=@CouponAmount,UpdatedDate=GETDATE(),TermsAndDescription=@TermsAndDescription,
          CouponType=@CouponType,Discount=@Discount,StartDate=@StartDate,EndDate=@EndDate,Status=@Status,UpdatedBy=@Who  where AutoId=@CouponAutoId
	  end
    END TRY                                                                                                                                      
BEGIN CATCH                                                                                                                                
ROLLBACK TRAN                                                                                                                        
Set @isException=1                                                                                                  
Set @exceptionMessage='Oops! Something went wrong.Please try later.'                                                                      
End Catch                                                                                                                                      
END
if @Opcode=31
 BEGIN
     delete from  CouponMaster where AutoId=@CouponAutoId and StoreId=@StoreId
     Set @isException=0
 END
 if @Opcode=42
 BEGIN
     select AutoId, CouponName, CouponCode, TermsAndDescription, CouponType, 
     Discount, CouponAmount, CreatedDate, UpdatedDate, format(StartDate,'MM/dd/yyyy')StartDate, 
     format(EndDate,'MM/dd/yyyy')EndDate, Status,StoreId
     from CouponMaster where AutoId=@CouponAutoId
 END
 if @Opcode=43
 BEGIN
     select AutoId,CompanyName from CompanyProfile where AutoId in (select CompanyId from EmployeeStoreList where EmployeeId=@Who and Status=1) and Status=1 order by CompanyName
 END
if @Opcode=41
 BEGIN
	 select ROW_NUMBER() over(order by CM.UpdatedDate desc) as RowNumber,AutoId, CouponCode,CouponName,TermsAndDescription
	 ,CouponType,Discount,CouponAmount,format(StartDate,'MM/dd/yyyy')as StartDate,format(EndDate,'MM/dd/yyyy')as EndDate,
	 UDM.FirstName+ISNULL(' '+UDM.LastName,'')+'<br/>'+format(CM.CreatedDate , 'MM/dd/yyyy hh:mm tt')as CreationDetails,
	 UDM1.FirstName+ISNULL(' '+UDM1.LastName,'')+'<br/>'+format(CM.UpdatedDate , 'MM/dd/yyyy hh:mm tt') as UpdationDetails,CM.Status,CM.Applied
	 into #temp
	 from CouponMaster CM
	 left join UserDetailMaster UDM on UDM.UserAutoId=CM.CreatedBy
	 left join UserDetailMaster UDM1 on UDM1.UserAutoId=CM.UpdatedBy
	 where  (@CouponCode is null or @CouponCode='' or CAST(CouponCode AS VARBINARY(100)) = CAST(trim(@CouponCode) AS VARBINARY(100))) 
	 and StoreId=@StoreId
     and (@StartDate is null or @StartDate='' or  convert(date,StartDate)>=convert(date,@StartDate) )
	 and (@EndDate is null or @EndDate='' or convert(date,EndDate)<=convert(date,@EndDate))
	 and (@Status is null or @Status=2 or CM.Status=@Status)
	 and (@UseStatus is null or @UseStatus=2 or isnull(CM.Applied,0)=@UseStatus)
	 order by CM.UpdatedDate desc

	 SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, 'Sort By: Update date desc' as SortByString 
     FROM #temp  
  
   Select  * from #temp t  
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))   
   order by  RowNumber asc 

	SET @isException=0	
 END
End TRY
BEGIN CATCH
SET @isException=1
SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end

GO
