
CREATE or Alter procedure [dbo].[ProcVendorMaster]
@Opcode int = null,
@AutoId int=null,
@Who int=null,
@VendorId varchar(50) = null,
@VendorCode varchar(50)=null,
@CompanyId int=null,
@VendorName varchar(50) = null,
@Address varchar(max) = null,
@Address2 varchar(max)=null,
@Country varchar(50) = null,
@City varchar(50) = null,
@State int = null,
@ZipCode varchar(10) = null,
--@PhoneNo varchar(15) = null,
@EmailId varchar(50) = null,
@MobileNo varchar(15) = null,
@FaxNo varchar(20)=null,
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
	BEGIN
		BEGIN TRY
		BEGIN TRAN  
			SET @VendorId = (SELECT DBO.SequenceCodeGenerator('VendorId'))
			 if exists(Select * from VendorMaster where VendorCode=@VendorCode)
			begin
			    Set @isException=1
				Set @exceptionMessage='Vendor code already exists.' 
			end
			else if exists(Select * from VendorMaster where VendorName=@VendorName)
			begin
				Set @isException=1
				Set @exceptionMessage='Vendor name already exists.'       
			end
			
			else if exists(select * from VendorMaster where isnull(MobileNo,'')=@MobileNo)     
            Begin      
               SET @exceptionMessage= 'Mobile No. already exists.'        
               SET @isException=1        
            end 
			else if exists(select * from VendorMaster where isnull(Emailid,'')=(case when isnull(@EmailId,'')='' then '0' else @EmailId end))     
            Begin      
               SET @exceptionMessage= 'Email ID already exists.'        
               SET @isException=1        
            end 
			else
			begin
			    insert into VendorMaster(VendorCode,CompanyId,[VendorId], [VendorName], [Address1], Country,[City], [State], [Zipcode], [Emailid], [MobileNo], Status,CreatedBy,CreatedDate)
			    values (@VendorCode,@CompanyId,@VendorId, @VendorName, @Address,'USA', @City, @State, @ZipCode, @EmailId, @MobileNo, @Status,@Who,GETDATE())
			    UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='VendorId'  
			end
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
    if not exists(select * from VendorMaster where AutoId=@AutoId)     
   Begin      
      SET @exceptionMessage= 'Vendor is not exists!'        
      SET @isException=1        
   end 
    else if exists(select * from VendorMaster where VendorCode=@VendorCode and AutoId!=@AutoId)     
   Begin      
      SET @exceptionMessage= 'Vendor Code already exists!'        
      SET @isException=1        
   end 
  else if exists(select VendorName from VendorMaster where VendorName=@VendorName and AutoId!=@AutoId)     
   Begin      
      SET @exceptionMessage= 'Vendor name already exists!'        
      SET @isException=1        
   end     
   else if exists(select * from VendorMaster where isnull(MobileNo,'')=@MobileNo and AutoId!=@AutoId)     
   Begin      
      SET @exceptionMessage= 'Contact No. already exists!'        
      SET @isException=1        
   end 
   else if exists(select * from VendorMaster where isnull(Emailid,'')=(case when isnull(@EmailId,'')='' then '0' else @EmailId end)  and AutoId!=@AutoId)     
   Begin      
      SET @exceptionMessage= 'Email ID already exists!'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
	     Update VendorMaster set VendorName=@VendorName, Address1=@Address, City=@City, State=@State, Zipcode=@ZipCode, 
	     VendorCode=@VendorCode,CompanyId=@CompanyId,
	     Emailid=@EmailId, MobileNo=@MobileNo, Status=@Status ,UpdatedBy=@Who,UpdatedDate=GETDATE() where AutoId=@AutoId
   COMMIT TRANSACTION  
   END TRY
   BEGIN CATCH                                                                                                                                
   	ROLLBACK TRAN                                                                                                                         
   	Set @isException=1                                                                                                   
   	Set @exceptionMessage=ERROR_MESSAGE()                                                                       
   End Catch  
   end 
   END 
    If @Opcode = 31
	begin
	if not exists(select * from VendorProductCodeList where VendorId=@AutoId)
	BEGIN
		if not exists(select * from PoMaster where VendorId=@AutoId)
		BEGIN
			if not exists(select * from [dbo].[PurchaseInvoiceMaster] where VendorAutoId=@AutoId)
			Begin
			   delete from VendorMaster where AutoId=@AutoId
			END
			ELSE
			BEGIN
				SET @exceptionMessage= 'Vendor is in use.'        
				SET @isException=1
			END
		END
		ELSE
		BEGIN
			SET @exceptionMessage= 'Vendor is in use.'        
			SET @isException=1    
		END
	END
	ELSE
		BEGIN
			SET @exceptionMessage= 'Vendor is in use.'        
			SET @isException=1    
		END
		--update VendorMaster set  where AutoId = @AutoId
		--update VendorMaster set Status=2,IsDeleted=1 where AutoId=@AutoId
		
	end
    If @Opcode = 41
	begin
		select  ROW_NUMBER() over(order by VendorName asc) as RowNumber,
		vm.[AutoId], vm.[VendorId], vm.[VendorName], 
		(case when isnull(vm.Address1,'')!='' then vm.Address1+', ' else '' end)
		+case when isnull(vm.City,'')!='' then (vm.City)+', ' else '' end
		+case when isnull(sm.state,'')!='' then (sm.state) else '' end
		+(case when vm.Zipcode!='' then '-'+(vm.Zipcode) else '' end )Address2,
		isnull(sm.State,'')State, vm.[Emailid], vm.[MobileNo], vm.Status,cp.CompanyName,VendorCode  
		into #temp
		from VendorMaster vm	
		left join StateMAster sm on vm.State=sm.AutoId 
		left join CompanyProfile cp on cp.AutoId=vm.CompanyId
		where vm.status!=2 and VendorName!='Other Vendor'

		and (@VendorName is null or @VendorName='' or VendorName like '%'+ @VendorName+'%')
		and (@VendorCode is null or @VendorCode='' or isnull(VendorCode,'')=@VendorCode)
		and (@CompanyId is null or @CompanyId=0 or isnull(vm.CompanyId,0)=@CompanyId)
		and(@EmailId is null or @EmailId='' or vm.Emailid like '%'+@EmailId+'%')
		and(@State is null or @State=0 or sm.State=@State)
		and(@MobileNo is null or @MobileNo='' or MobileNo like '%'+@MobileNo+'%')
		and   (@Status is null or @Status=2 or vm.Status=@Status)

		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, '#Sort By: Vendor Name asc' as SortByString 
        FROM #temp  
  
        Select  * from #temp t  
        WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))   
        order by  VendorName asc  
	end
    If @Opcode = 42
	begin		
		select VendorName,MobileNo,Address1,State,City,Zipcode,Emailid,Status,* from VendorMaster where AutoId = @AutoId
	end
	IF @Opcode=51
    BEGIN
       select AutoId,State from StateMAster where  Status=1 order by State Asc
	   
	   select AutoId,CompanyName from CompanyProfile order by CompanyName
    END
	End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
