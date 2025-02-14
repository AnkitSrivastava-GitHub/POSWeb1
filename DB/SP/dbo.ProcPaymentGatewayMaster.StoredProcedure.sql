USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcPaymentGatewayMaster]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ProcPaymentGatewayMaster]

	@Who nvarchar(25)=NULL,
	@isException bit out,
	@exceptionMessage nvarchar(500) out,
	@TestMode bit =null,
	@AccessKey nvarchar(100)=NULL,
	@HashKey nvarchar(50)=NULL,
	@PaymentGatewayAutoId int = null,
	@Description varchar (500) = null,
	@DisplayName varchar (30) = null,

    @ResultCode varchar (100)= null, 
	@ResultTxt  varchar (100)= null, 
	@RefNum varchar (100)= null, 
	@AvsResponse varchar (100)= null, 
	@CvResponse varchar (100)= null, 
	@Timestamp varchar (100)= null, 
	@HostCode varchar (100)= null, 
	@RequestedAmount varchar (100)= null, 
	@ApprovedAmount varchar (100)= null, 
	@RemainingBalance varchar (100)= null,
	@ExtraBalance varchar (100)= null, 
	@HostResponse varchar (100)= null, 
	@BogusAccountNum varchar (100)= null, 
	@CardType varchar (100)= null, 
	@Message varchar (100)= null, 
	@AuthCode varchar (100)= null, 
	@SigFileName varchar (100)= null,
	@InvNum varchar (100)= null, 
	@VASCode varchar (100)= null, 
	@SignData varchar (100)= null,
	@TORResponseInfo varchar (100)= null, 
	@TranIntgClass varchar (100)= null, 
	@TransactionRemainingAmount varchar (100)= null, 
	@DebitAccountType varchar (100)= null,

    @PageIndex INT=1,
    @PageSize INT=10,
    @RecordCount INT=null,
	@opCode int=Null
AS
BEGIN
BEGIN TRY		
SET @isException=0
SET @exceptionMessage='Success!!'
if @opCode=11
	begin
		insert into PaymentGatewayMaster(DisplayName,Description, AccessKey,HashKey,TestMode,creationDate,UpdateDate)
		values (@DisplayName,@Description,@AccessKey,@HashKey,@TestMode,GETDATE(),GETDATE());
		SET @isException=0
	end
else if @opCode=12
	begin
	 insert into PaxResponseMessage(CreatedDate, CreatedBy, ResultCode, ResultTxt, RefNum, AvsResponse, CvResponse, Timestamp, HostCode, RequestedAmount, ApprovedAmount, RemainingBalance, ExtraBalance, HostResponse, BogusAccountNum, CardType, Message, AuthCode, SigFileName, InvNum, VASCode, SignData, TORResponseInfo, TranIntgClass, TransactionRemainingAmount, DebitAccountType)
	 values(getdate(), @Who, @ResultCode, @ResultTxt, @RefNum, @AvsResponse, @CvResponse, @Timestamp, @HostCode, @RequestedAmount, @ApprovedAmount, @RemainingBalance, @ExtraBalance, @HostResponse, @BogusAccountNum, @CardType, @Message, @AuthCode, @SigFileName, @InvNum, @VASCode, @SignData, @TORResponseInfo, @TranIntgClass, @TransactionRemainingAmount, @DebitAccountType)
	end
else if @opCode=21
	begin
		update PaymentGatewayMaster set AccessKey=@AccessKey, HashKey=@HashKey, Description=@Description,
		UpdateDate=GETDATE(), TestMode=@TestMode where AutoId = @PaymentGatewayAutoId;
		SET @isException=0
		end		
else if @opCode=41
	begin
		select * from PaymentGatewayMaster 
		SET @isException=0
		end
else if @opCode = 42
		begin
		select AutoId,DisplayName,Description, AccessKey,HashKey,TestMode from PaymentGatewayMaster where AutoId = @PaymentGatewayAutoId
		SET @isException=0
		end
else if @opCode = 43
		begin
		select *, (SELECT DBO.SequenceCodeGenerator('TempInvoice'))  as TempInvoice from [dbo].[PaxSetting]
		UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='TempInvoice'  
		SET @isException=0
		end
else if @opCode = 44
		begin
		select *, (SELECT DBO.SequenceCodeGenerator('TempInvoice'))  as TempInvoice from [dbo].[PaxSetting]
		select [TransactionId],[AuthCode],[Total] from InvoiceMaster where InvoiceNo=@InvNum
		UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='TempInvoice'  
		SET @isException=0
		end
END TRY
	BEGIN CATCH	
		SET @isException=1
		SET @exceptionMessage= ERROR_MESSAGE()
	END CATCH;
END


























GO
