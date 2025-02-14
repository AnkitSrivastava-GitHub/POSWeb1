
Create or alter   Proc [dbo].[ProcRoyaltyMaster]
@Opcode int=null,
@RoyaltyAutoId int=null,
@AmtRoyaltyAutoId int=null,
@RoyaltyPoint  int=null,
@Amount  decimal(18,2)=null,
@AmtPerRoyaltyPoint decimal(18,2)=null,
@MinOrderAmt decimal(18,2)=null,
@Status int=null,
@AmtStatus  int=null,
@MinOrderAmtForRoyalty decimal(18,2)=null,
@StoreId int=null,
@Who varchar(50)=null,
@PageIndex INT=1,
@PageSize INT=10,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as
begin
begin try
      SET @isException=0
      SET @exceptionMessage='Success!'
If @Opcode = 21
Begin
	BEGIN TRY
	BEGIN TRAN
			 update RoyaltyMaster set AmtPerRoyaltyPoint=@AmtPerRoyaltyPoint ,MinOrderAmt=@MinOrderAmt,CreatedBy=@Who ,CreatedDate=GETDATE(),Status=@Status where AutoId=@RoyaltyAutoId
	COMMIT TRANSACTION 
	end try
	begin catch
	 rollback tran
	       SET @isException=1
           SET @exceptionMessage=ERROR_MESSAGE()
	 end catch
end
If @Opcode = 22
Begin
	BEGIN TRY
	BEGIN TRAN
			 update AmountWiseRoyaltyPointMaster set RoyaltyPoint=@RoyaltyPoint ,Amount=@Amount,MinOrderAmt=@MinOrderAmtForRoyalty,CreatedBy=@Who ,CreatedDate=GETDATE(),Status=@AmtStatus where AutoId=@AmtRoyaltyAutoId
	COMMIT TRANSACTION 
	end try
	begin catch
	 rollback tran
	       SET @isException=1
           SET @exceptionMessage=ERROR_MESSAGE()
	 end catch
end
If @Opcode = 41
begin
	select AutoId,AmtPerRoyaltyPoint ,MinOrderAmt,Status from RoyaltyMaster RM where StoreId=@StoreId

	select AutoId,RoyaltyPoint,Amount,Status,MinOrderAmt from AmountWiseRoyaltyPointMaster where StoreId=@StoreId

	--SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: CreatedDate desc' as SortByString FROM #temp

	--Select  * from  #temp t
	--WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
	
end
end try
begin catch
   SET @isException=1
   SET @exceptionMessage=ERROR_MESSAGE()
end catch
end
	
GO
