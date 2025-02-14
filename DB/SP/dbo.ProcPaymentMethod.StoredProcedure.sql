USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcPaymentMethod]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[ProcPaymentMethod]
@Opcode int = null,
@AutoId int=null,
@PaymentCode varchar(10)=null,
@PaymentType varchar(50)=null,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
begin
BEGIN TRY
If @Opcode = 11
	BEGIN
		
     insert into PaymentMethod(PaymentType,PaymentCode)
	 values (@PaymentType,@PaymentCode)			
     SET @isException=0
	END
If @Opcode = 21
	begin		
		update PaymentMethod set PaymentType=@PaymentType,PaymentCode=@PaymentCode where  AutoId=@AutoId	
		SET @isException=0
	end
If @Opcode = 31
	begin		
		delete PaymentMethod where AutoId=@AutoId
		SET @isException=0
	end
If @Opcode = 41
begin		
	select * from PaymentMethod 
	SET @isException=0
end

	
	End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
