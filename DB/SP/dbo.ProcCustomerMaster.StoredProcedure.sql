USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcCustomerMaster]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   procedure [dbo].[ProcCustomerMaster] 
@Opcode int = null,
@AutoId int= null, 
@CustomerId varchar(20) = null, 
@FirstName varchar(200) = null, 
@LastName varchar(200) = null, 
@DOB varchar(20)=null, 
@MobileNo varchar(20) = null, 
--@PhoneNo varchar(20) = null, 
@EmailId varchar(100) = null, 
@Address varchar(200) = null, 
@State varchar(100) = null, 
@City varchar(100) = null, 
@Country varchar(100) = null, 
@ZipCode varchar(20) = null, 
@Status int= null,
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
	BEGIN
		BEGIN TRY
		BEGIN TRAN  
			SET @CustomerId = (SELECT DBO.SequenceCodeGenerator('CustomerNo'))  		 	
			insert into CustomerMaster(CustomerId, FirstName, LastName, DOB, MobileNo, EmailId, Address, State, City, Country, ZipCode)
			values (@CustomerId, @FirstName, @LastName, @DOB, @MobileNo, @EmailId, @Address, @State, @City, @Country, @ZipCode)
			UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='CustomerNo'
			Select @CustomerId as CustomerId
		COMMIT TRANSACTION    
		END TRY  
		BEGIN CATCH                                                                                                     
			ROLLBACK TRAN                                                                                               
			Set @isException=1                                                                                          
			Set @exceptionMessage='Oops! Something went wrong.Please try later.'                                        
		End Catch      
	END
If @Opcode = 21
	begin		
		Update CustomerMaster set FirstName=@FirstName, LastName=@LastName, DOB=@DOB, MobileNo=@MobileNo, EmailId=@EmailId, Address=@Address, State=@State, City=@City, ZipCode=@ZipCode where AutoId = @AutoId
	end
If @Opcode = 31
	begin		
		delete CustomerMaster where AutoId=@AutoId
	end
    If @Opcode = 41
	begin	
		select  ROW_NUMBER() over(order by FirstName asc) as RowNumber,
		cm.AutoId,cm.CustomerId , cm.FirstName + ' ' +LastName as FirstName, cm.MobileNo ,
		cm.EmailId ,(cm.Address+', '+(cm.City)+', '+(sm.state)+'-'+(cm.Zipcode))Address
		into #temp
		from CustomerMaster cm
		inner join StateMAster sm on cm.AutoId=sm.AutoId   

		where (@CustomerId is null or @CustomerId=''  or CustomerId = @CustomerId)
		and (@FirstName is null or @FirstName=''  or FirstName +' ' +LastName like'%'+ @FirstName +'%')
		and (@EmailId is null or @EmailId=''  or EmailId like'%'+ @EmailId +'%')
		and (@MobileNo is null or @MobileNo='' or MobileNo like '%'+@MobileNo+'%')
		and CustomerId!='C100001'
		order by FirstName 
		--+ ' ' +LastName 

		 SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, 'Sort By: CustomerName asc' as SortByString 
   FROM #temp  
  
   Select  * from #temp t  
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))   
  order by  FirstName asc  
	end
    If @Opcode = 42
	begin		
		select AutoId,FirstName,LastName,MobileNo,EmailId,Address,City,state,zipCode,DOB from CustomerMaster where AutoId=@AutoId
	end
	If @Opcode=51
	BEGIN
	 select AutoId,state from stateMAster
	END
	
	End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
