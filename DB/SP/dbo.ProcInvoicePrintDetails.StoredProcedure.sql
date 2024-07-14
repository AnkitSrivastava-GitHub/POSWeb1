
Create or Alter PROCEDURE [dbo].[ProcInvoicePrintDetails]
@Opcode int =NULL,
@AutoId int=NULL,
@SoterId varchar(50) =NULL,
@StoreName varchar(100)=NULL,
@ContactPerson  varchar(100)=NULL,
@ShowHappyPoints int=null,
@ShowFooter int=null,
@ShowLogo int=null,
@Footer varchar(500)=null,
@BillingAddress varchar(max)=NULL,
@Country varchar(100)=NULL,
@State varchaR(100)=NULL,
@City varchar(200)=NULL,
@ZipCode varchar(50) =NULL,
@EmailId varchar(100)=NULL,
@Website varchar(100)=NULL,
@MobileNo varchar(20) =NULL,
@CLogo varchar(200)=NULL,
@ClogoReport int =NULL,
@Clogoprint int =NULL,
@Who int=null,
@StoreId int=null,
@status int=null,
@UserName varchar(50) =NULL,
@Password varchar(250) =NULL,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
AS
BEGIN
BEGIN TRY
	 Set @isException=0                                      
  Set @exceptionMessage='Success'    

 If @Opcode = 21
begin
	if  exists(select * from InvoicePrintDetails where StoreId=@StoreId)
	BEGIN
		begin try
			update  InvoicePrintDetails set StoreName=@StoreName,ContactPersone=@ContactPerson,BillingAddress=@BillingAddress,City=@City,State=State,Country=@Country,
			ZipCode=@ZipCode,WebSite=@Website,EmailId=@EmailId,MobileNo=@MobileNo,ShowHappyPoints=@ShowHappyPoints,ShowFooter=@ShowFooter,Footer=@Footer,ShowLogo=@ShowLogo 
			where StoreId=@StoreId
		end try
		begin catch						
			SET @isException=1
			SET @exceptionMessage= ERROR_MESSAGE()
		end catch
		End
	ELSE
		BEGIN
			insert into InvoicePrintDetails (StoreName,ContactPersone,BillingAddress,City,State,Country,ZipCode,WebSite,EmailId,MobileNo,ShowHappyPoints,ShowFooter,Footer,StoreId,ShowLogo)
			values(@StoreName,@ContactPerson,@BillingAddress,@City,@State,@Country,@ZipCode,@Website,@EmailId,@MobileNo,@ShowHappyPoints,@ShowFooter,@Footer,@StoreId,@ShowLogo)
		END
end
	else If @Opcode = 41
	begin
		 select AutoId,StoreName,ContactPersone,BillingAddress,City,State,Country,ZipCode,WebSite,EmailId,MobileNo,ShowHappyPoints,ShowFooter,Footer,ShowLogo
		 from InvoicePrintDetails where StoreId=@StoreId
	end
END TRY	
BEGIN CATCH
--ROLLBACK TRAN
SET @isException=1
SET @exceptionMessage= ERROR_MESSAGE()
END CATCH
END
GO
