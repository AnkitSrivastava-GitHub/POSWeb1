create or alter PROCEDURE [dbo].[ProcGiftCardReport]
	@Status int=NULL,
	@Store int=NULL,
	@opCode int=Null,
	@Mobile varchar(15)=Null,
	@GiftCode varchar(30)=Null,
	@CustomerName varchar(80)=null,
	@Terminal int=Null,
	@InvoiceAutoId int=Null,
	@Email varchar(100)=null,
	@FromDate datetime=Null,
	@ToDate datetime=Null,
	@PageIndex INT=1,
	@PageSize INT=10,
	@Who int=NULL,
	@isException bit out,
	@exceptionMessage nvarchar(500) out,
	@RecordCount INT=null
AS
BEGIN        
 BEGIN TRY        
  SET @exceptionMessage= 'Success'        
  SET @isException=0        
  
  IF @Opcode=42      
 BEGIN
 --if(@Status=4)
	-- BEGIN
	--	select ROW_NUMBER() over(order by GCS.AutoId desc) as RowNumber,GCS.AutoId,GCS.GiftCardName,GCS.GiftCardCode,GCS.TotalAmt,GCS.LeftAmt,IM.InvoiceNo as GiftCardPurchaseInvoice,format(GCS.SoldDate,'MM/dd/yyyy') as SoldDate,
	--	Concat(CM.FirstName,' ',CM.LastName) as Customer,GCS.SoldStatus as Status,CM.MobileNo,CM.EmailId 
	--	,CP.CompanyName,TM.TerminalName,Concat(UD.FirstName,' ',UD.LastName) as SoldBy into #temp
	--	from GiftCardSale GCS INNER JOIN CustomerMaster CM on CM.AutoId=GCS.CustomerAutoId 
	--	Inner join UserDetailMaster UD on UD.UserAutoId=GCS.SoldBy 
	--	Inner join TerminalMaster TM on TM.AutoId=GCS.TerminalId
	--	Inner join InvoiceMaster IM on IM.AutoId=GCS.GiftCardPurchaseInvoice 
	--	Inner join CompanyProfile CP on CP.AutoId=GCS.StoreId and CP.AutoId=@Store
	--	where  GCS.StoreId=@Store
	--	and (@Mobile is null or @Mobile='' or CM.MobileNo=@Mobile)
	--	and (@Terminal is null or @Terminal=0 or GCS.TerminalId=@Terminal)
	--	and (GCS.LeftAmt < GCS.TotalAmt and GCS.LeftAmt > 0)
	--	and (@InvoiceAutoId is null or @InvoiceAutoId=0 or IM.InvoiceNo=@InvoiceAutoId)
	--	and (@Email is null or @Email='' or CM.EmailID=@Email)
	--	and (@CustomerName is null or @CustomerName='' or (CM.FirstName + ' ' + CM.LastName) like '%'+@CustomerName+'%')
	--	and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or (convert(date,GCS.SoldDate) between convert(date,@FromDate) and convert(date,@ToDate)))
	--	and SoldStatus!=0
	--	order by AutoId desc 

	--	SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Sold Date desc' as SortByString FROM #temp      
      
	--	Select  * from #temp t      
	--	WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
	--	order by  AutoId desc
	-- END
 --ELSE
	-- BEGIN
		select ROW_NUMBER() over(order by GCS.AutoId desc) as RowNumber,GCS.AutoId,GCS.GiftCardName,GCS.GiftCardCode,GCS.TotalAmt,GCS.LeftAmt,IM.InvoiceNo as GiftCardPurchaseInvoice,format(GCS.SoldDate,'MM/dd/yyyy') as SoldDate,
		Concat(CM.FirstName,' ',CM.LastName) as Customer,GCS.SoldStatus as Status,CM.MobileNo,CM.EmailId
		,CP.CompanyName,TM.TerminalName,Concat(UD.FirstName,' ',UD.LastName) as SoldBy into #temp3
		from GiftCardSale GCS INNER JOIN CustomerMaster CM on CM.AutoId=GCS.CustomerAutoId 
		Inner join UserDetailMaster UD on UD.UserAutoId=GCS.SoldBy 
		Inner join TerminalMaster TM on TM.AutoId=GCS.TerminalId 
		Inner join InvoiceMaster IM on IM.AutoId=GCS.GiftCardPurchaseInvoice 
		Inner join CompanyProfile CP on CP.AutoId=GCS.StoreId and CP.AutoId=@Store
		where GCS.StoreId=@Store  
		and (@Mobile is null or @Mobile='' or CM.MobileNo=@Mobile)
		and (@Terminal is null or @Terminal=0 or GCS.TerminalId=@Terminal)
		and (@Status is null or @Status=5 or (@Status=4 and (GCS.LeftAmt < GCS.TotalAmt and GCS.LeftAmt > 0)) or (@Status=2 and GCS.SoldStatus=2) or (@Status=1 and (isnull(GCS.LeftAmt,0) = isnull(GCS.TotalAmt,0) and GCS.LeftAmt > 0 and isnull(GCS.TotalAmt,0) > 0))) 
		and (@InvoiceAutoId is null or @InvoiceAutoId=0 or IM.InvoiceNo=@InvoiceAutoId)
		and (@Email is null or @Email='' or CM.EmailID=@Email)
		and (@CustomerName is null or @CustomerName='' or (CM.FirstName + ' ' + CM.LastName) like '%'+@CustomerName +'%')
		and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or (convert(date,GCS.SoldDate) between convert(date,@FromDate) and convert(date,@ToDate)))
		and SoldStatus!=0
		order by AutoId desc 

		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Sold Date desc' as SortByString FROM #temp3      
      
		Select  * from #temp3 t      
		WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
		order by  AutoId desc
	  --END
  END    
  IF @Opcode=43     
	 BEGIN
		select ROW_NUMBER() over(order by GCS.AutoId desc) as RowNumber,GCS.AutoId,GCS.GiftCardName,GCS.GiftCardCode,GCS.TotalAmt,GCS.LeftAmt,IM.InvoiceNo as GiftCardPurchaseInvoice,format(GCS.SoldDate,'MM/dd/yyyy') as SoldDate,
		Concat(CM.FirstName,' ',CM.LastName) as Customer,GCS.SoldStatus as Status,CM.MobileNo,CM.EmailId 
		,CP.CompanyName,TM.TerminalName,Concat(UD.FirstName,' ',UD.LastName) as SoldBy into #temp2
		from GiftCardSale GCS INNER JOIN CustomerMaster CM on CM.AutoId=GCS.CustomerAutoId 
		Inner join UserDetailMaster UD on UD.UserAutoId=GCS.SoldBy 
		Inner join TerminalMaster TM on TM.AutoId=GCS.TerminalId 
		Inner join InvoiceMaster IM on IM.AutoId=GCS.GiftCardPurchaseInvoice 
		Inner join CompanyProfile CP on CP.AutoId=GCS.StoreId and CP.AutoId=@Store
		where GCS.StoreId=@Store and GCS.SoldStatus!=0 
		and (@Mobile is null or @Mobile='' or CM.MobileNo=@Mobile)
		and  (@GiftCode is null or @GiftCode='' or CAST(GCS.GiftCardCode AS VARBINARY(100))= CAST(trim(@GiftCode) AS VARBINARY(100)))
		and (@InvoiceAutoId is null or @InvoiceAutoId=0 or IM.InvoiceNo=@InvoiceAutoId)
		and (@Email is null or @Email='' or CM.EmailID=@Email)   
		order by AutoId desc 
      
		SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: Sold Date desc' as SortByString FROM #temp2      
      
		Select  * from #temp2 t      
		WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
		order by  AutoId desc      
	 END  
 END TRY        
 BEGIN CATCH        
     SET @isException=1        
     SET @exceptionMessage= ERROR_MESSAGE()        
 END CATCH        
END  


GO
