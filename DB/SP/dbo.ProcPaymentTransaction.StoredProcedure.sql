USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcPaymentTransaction]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ProcPaymentTransaction]
@Opcode int= null,
@TempInvoiceNo varchar(50)=null,
@CreditCardNo varchar(50)=null,
@ResponseCode varchar(50)=null,
@ResponseMessage varchar(500)=null,
@TransactionId varchar(500)=null,
@Amount decimal(18,2)=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
begin
BEGIN TRY
SET @isException=0
SET @exceptionMessage='Success!!'
 if @Opcode=11
BEGIN
	Insert into PaymentResponseMessage(TempInvoiceNo, CreditCardNo, ResponseCode, ResponseMessage, Amount, EntryDate, Type, TransactionID)
	values(@TempInvoiceNo, @CreditCardNo, @ResponseCode, @ResponseMessage, @Amount, GETDATE(), 'Payment', @TransactionId)
END
End TRY
BEGIN CATCH
	SET @isException=1
	SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
