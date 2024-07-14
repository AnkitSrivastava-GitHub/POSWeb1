Create or ALTER   procedure [dbo].[ProcSafeCash] 
@Opcode int = null,
@SafeCashAutoId int = null,  
@Mode int = null,
@Terminal int=null,
@FromDate datetime=null,
@ToDate  datetime=null,
@Remark varchar(250) = null,
@Amount decimal(18,2) = null,
@StoreId int = null,
@Who varchar(50)=null,
@Userid varchar(50)=null,
@Status int=null,
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
If @Opcode = 11
Begin
	BEGIN TRY
	BEGIN TRAN 
	Declare @Total decimal(18,2)=null
	set @Total=(select top 1 isnull((isnull((select Sum(Amount) from Safecash where Mode=1 and Store=@StoreId),0)-isnull((select Sum(Amount) from Safecash where Mode=2 and Store=@StoreId),0)),0) as Total FROM Safecash where Store=@StoreId )
	if(@Mode=2 and isnull(@Total,0)<@Amount)
	Begin
		Set @isException=1                                                                                                   
		Set @exceptionMessage='Insufficient Safe Cash Amount!'
	End
	Else
	Begin
	declare @SafeAutoId int=null
		insert into Safecash(Mode,Amount,Remark,Store,CreatedDate,CreatedBy,Terminal,Status)
		values (@Mode,@Amount,@Remark,@StoreId,GETDATE(),@Who,@Terminal,@Status)

		 set @SafeAutoId = SCOPE_IDENTITY()

        select top 1 @SafeAutoId as AutoId from Safecash
	End
	COMMIT TRANSACTION    
	END TRY                                                                                                                                      
	BEGIN CATCH                                                                                                                                
	ROLLBACK TRAN                                                                                                                         
		Set @isException=1                                                                                                   
		Set @exceptionMessage=ERROR_MESSAGE()                                                                       
	End Catch      
	END

If @Opcode = 21
  BEGIN       
   BEGIN TRY
   BEGIN TRAN
   Declare @Total1 decimal(18,2)=null,@WTotal decimal(18,2)=null
   set @WTotal=(SELECT Amount FROM SafeCash WHERE AutoId = @SafeCashAutoId)
	set @Total1=(select top 1 isnull((isnull((select Sum(Amount) from Safecash where Mode=1 and Store=@StoreId),0)-isnull((select Sum(Amount) from Safecash where Mode=2 and Store=@StoreId),0)),0) as Total FROM Safecash where Store=@StoreId)
	if(@Mode=2 and isnull(@Total1,0)<@Amount)
	Begin		
		if((@WTotal+@Total1)>=@Amount)
		begin
			UPDATE Safecash SET Mode=@Mode,Amount=@Amount,Terminal=@Terminal,Remark=@Remark,Store=@StoreId,Status=@Status
			WHERE AutoId = @SafeCashAutoId
		END
		ELSE
		BEGIN
			Set @isException=1                                                                                                   
			Set @exceptionMessage='Insufficient Safe Cash Amount!'
		END
	End
	Else
		Begin
		set @Mode=(select Mode from Safecash where AutoId = @SafeCashAutoId)
		if(@Mode=1 and isnull(@WTotal,0)<=@Amount)
		Begin
			UPDATE Safecash SET Mode=@Mode,Amount=@Amount,Terminal=@Terminal,Remark=@Remark,Store=@StoreId,Status=@Status
			WHERE AutoId = @SafeCashAutoId
		End
		Else if(@Mode=2)
		Begin
			UPDATE Safecash SET Mode=@Mode,Amount=@Amount,Terminal=@Terminal,Remark=@Remark,Store=@StoreId,Status=@Status
			WHERE AutoId = @SafeCashAutoId
		End
		ELSE
		BEGIN
			Set @isException=1                                                                                                   
			Set @exceptionMessage='Insufficient Safe Cash Amount!'
		END
	End
   COMMIT TRANSACTION  
   END TRY
   BEGIN CATCH                                                                                                                                
   	ROLLBACK TRAN                                                                                                                         
   	Set @isException=1                                                                                                   
   	Set @exceptionMessage=ERROR_MESSAGE()                                                                      
   End Catch  
   END 
If @Opcode = 31
BEGIN   
set @Total1=(select top 1 isnull((isnull((select Sum(Amount) from Safecash where Mode=1 and Store=@StoreId),0)-isnull((select Sum(Amount) from Safecash where Mode=2 and Store=@StoreId),0)),0) as Total FROM Safecash where Store=@StoreId)
set @Mode=(select Mode from Safecash where AutoId = @SafeCashAutoId)
set @Amount=(select Amount from Safecash where AutoId = @SafeCashAutoId)
	if(@Mode=1 and isnull(@Total1,0)>=@Amount)
	Begin
		Delete from Safecash where AutoId = @SafeCashAutoId	
	END
	else if(@Mode=2)
	Begin
		Delete from Safecash where AutoId = @SafeCashAutoId	
	END
	ELSE
	BEGIN
		Set @isException=1                                                                                                   
		Set @exceptionMessage='Insufficient Safe Cash Amount!'
	END
  END    
If @Opcode = 41
begin
	select *
     from Safecash 
	where
	AutoId = @SafeCashAutoId
	order by AutoId 
end
If @Opcode = 42
begin
	
		select ROW_NUMBER() over(order by Amount asc) as RowNumber,SC.AutoId,Mode,Amount,Remark,SC.Status,Store,concat(MM.FirstName,' ',MM.LastName) as CreatedBy,SC.CreatedBy as Emp,format(SC.CreatedDate,'MM/dd/yyyy hh:mm tt') CreatedDate,TM.TerminalName
		into #tempT
		from SafeCash SC
		INNER JOIN UserDetailMaster MM on MM.UserAutoId=SC.CreatedBy
		left join TerminalMaster TM on TM.AutoId=SC.Terminal
		where (@Mode is null or @Mode='' or Mode=@Mode)
		And (@StoreId is null or @StoreId=0 or Store=@StoreId)
		And (@Terminal is null or @Terminal=0 or TM.AutoId=@Terminal)
	  and (@Amount is null or @Amount=0 or Amount=@Amount) 
	   and (@FromDate is null or @ToDate is null or (convert(date,SC.CreatedDate) between convert(date,@FromDate) and convert(date,@ToDate)))
		ORDER BY AutoId desc

		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Date desc' as SortByString FROM #tempT

		Select  * from 
		#tempT t
		WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
		order by  AutoId desc
		Declare @OTotal decimal(18,2)=null,@TotalSafe decimal(18,2)=null
		--set @OTotal=(select top 1 isnull((isnull((select Sum(Amount) from Safecash where Mode=1 and CreatedDate<=DATEADD(day,-1,GETDATE())),0)-isnull((select Sum(Amount) from Safecash where Mode=2 and CreatedDate<=DATEADD(day,-1,GETDATE())),0)),0) as Total FROM Safecash )
		set @OTotal=(select top 1 isnull((isnull((select Sum(Amount) from Safecash where Mode=1 and Store=@StoreId),0)-isnull((select Sum(Amount) from Safecash where Mode=2 and Store=@StoreId),0)),0) as Total FROM Safecash)
		 
		select top 1 @OTotal as Total,isnull(@TotalSafe,0) as TotalSafe from SafeCash
end
	
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
