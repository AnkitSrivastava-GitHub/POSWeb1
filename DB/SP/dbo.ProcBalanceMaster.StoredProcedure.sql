USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcBalanceMaster]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ProcBalanceMaster]
	@isException bit out,
	@exceptionMessage nvarchar(500) out,
	@BalanceMasterAutoId int,
	@UserId nvarchar(100) =NULL,
	@TerminalAutoId int =NULL,
	@OpeningBalance decimal(18,2) =NULL,
	@ClosingBalance decimal(18,2) =NULL,
	@Mode nvarchar(25) =NULL,
	@Opcode int
AS
BEGIN
	SET @isException=0
	SET @exceptionMessage=''
	if @opCode=41
	begin
		BEGIN TRY
		if exists(select top 1 * from BalanceMaster where AutoId = @BalanceMasterAutoId)
		BEGIN
			Update BalanceMaster set Mode=@Mode,OpeningBalance=@OpeningBalance,CreatedDate=GETDATE() where AutoId = @BalanceMasterAutoId
		END
		Else
		BEGIN
		    if exists(select top 1 * from BalanceMaster where TerminalAutoId=@TerminalAutoId and isnull(Mode,'')!='LogOut')
			begin
			Select top 1 AutoId from BalanceMaster where TerminalAutoId=@TerminalAutoId and isnull(Mode,'')!='LogOut'
			end
			else
			begin
			Insert into BalanceMaster (UserId, TerminalAutoId, OpeningBalance, ActualBalance, Mode, CreatedDate) 
			values(@UserId, @TerminalAutoId, @OpeningBalance, 0, @Mode, GetDate())
			Select top 1 AutoId from BalanceMaster order by CreatedDate desc
			end
		END
		END TRY
		BEGIN CATCH
			SET @isException=1
			SET @exceptionMessage=ERROR_MESSAGE()
		END CATCH	
	End

	if @opCode=42
	begin
		BEGIN TRY
		Update BalanceMaster set Mode=@Mode,UpdatedDate=GETDATE() where AutoId = @BalanceMasterAutoId
		END TRY
		BEGIN CATCH
			SET @isException=1
			SET @exceptionMessage=ERROR_MESSAGE()
		END CATCH	
	End

	if @opCode=43
	begin
		BEGIN TRY
		Update BalanceMaster set Mode=@Mode,ClosingBalance=@ClosingBalance, UpdatedDate=GETDATE() 
		where AutoId = @BalanceMasterAutoId
		END TRY
		BEGIN CATCH
			SET @isException=1
			SET @exceptionMessage=ERROR_MESSAGE()
		END CATCH	
	End
	if @opCode=44
	begin
	 Select * from BalanceMaster where AutoId=@BalanceMasterAutoId
	end
	if @opCode=45
	begin
	 Select um.FirstName+' '+ um.LastName as UName, tm.TerminalName, tm.TerminalAddress , 
convert(varchar(10),bm.CreatedDate,101) as ODate, bm.OpeningBalance, bm.ActualBalance, isnull(bm.ClosingBalance,0.00) as ClosingBalance
from BalanceMaster bm
inner join UserDetailMaster um on um.Userid=bm.UserId
inner join TerminalMaster tm on tm.AutoId=bm.TerminalAutoId 
order by bm.AutoId desc
	end
END

GO
