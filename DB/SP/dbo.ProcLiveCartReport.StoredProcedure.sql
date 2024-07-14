
Create or ALTER procedure [dbo].[ProcLiveCartReport]
@Opcode int= null,
@StoreId int=null,
@EmpId int=null,
@Who int=null,
@UserName varchar(100)=null,
@OrderId int=null,
@DiscType varchar(50)=null,
@Type varchar(50)=null,
@Disc decimal(18,2)=null,
@OrderNo varchar(30)=null,
@TerminalId int=null,
@PageIndex INT=1,
@PageSize INT=10,
@Discount decimal(18,2)=null,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
begin
BEGIN TRY
SET @isException=0
SET @exceptionMessage='Success!!'
 if @Opcode=11
    Begin
		Select  AutoId as [A], CompanyName as [P]
		from CompanyProfile  SM
		where SM.Status=1 
		order by CompanyName Asc  
    END

if @Opcode=12
 BEGIN
	Select  AutoId as [A], TerminalName as [P]
		from TerminalMaster  SM
		where SM.Status=1 and SM.CompanyId=@StoreId
		order by TerminalName Asc                                                                                                                                  
 END
 if @Opcode=13
 BEGIN
 Declare @Ono varchar(20)=null,@Cnt int=null
 
        set @Ono=isnull((select top 1 OrderNo from CartMaster where StoreId=@StoreId and TerminalId=@TerminalId and LiveCartforDraft=1 order by AutoId desc),'')
		if(@Ono='')
		Begin
			Set @Ono=(select top 1 OrderNo from CartMaster where StoreId=@StoreId and TerminalId=@TerminalId  order by AutoId desc)
		End
		set @UserName=(select isnull((UD.FirstName +isnull(( ' '+UD.LastName),'')),'') from TerminalMaster CM left Join UserDetailMaster UD on UD.UserAutoId=CM.CurrentUser where CM.CompanyId=@StoreId and CM.AutoId=@TerminalId)
		set @Cnt=(select count(*) from CartSKUMaster where OrderAutoId=(select AutoId from CartMaster where OrderNo=@Ono))
		set @OrderId=(select AutoId from CartMaster where OrderNo=@Ono and IsDeleted=0 and isnull(InvoiceId,0)=0 and isnull(@Cnt,0)>0)
		if(isnull(@OrderId,0)!=0)
		Begin
			set @UserName=(select UD.FirstName + ' '+ UD.LastName from CartMaster CM Inner Join UserDetailMaster UD on UD.UserAutoId=CM.CreatedBy where OrderNo=@Ono)
			select @Discount=Discount, @Type=DiscType from CartMaster where AutoId=@OrderId and StoreId=@StoreId

			if(@Type='Per')
			Begin
				set @Disc=isnull((select cast(sum(Total) as decimal(18,2))from CartSKUMaster where OrderAutoId=@OrderId and  SKUName not like '%Lottery%'),0) / 100 * @Discount
			End
			Else
			Begin
				set @Disc=isnull(@Discount,0)
			End 
			set @DiscType=(case when (ISNULL(@Type,'')='Per' and @Disc>0) then 'Percentage' when (ISNULL(@Type,'')='Fixed' and @Disc>0) then 'Fixed' else '' end)

			select isnull((select AutoId, FirstName +isnull(' '+LastName,'') as [Name] from CustomerMaster where AutoId=(select CustomerId from CartMaster where AutoId=@OrderId) for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
			isnull((
			Select csm.AutoId as CartItemId,csm.SKUId ,csm.SKUName, csm.SchemeId, csm.Quantity,isnull(MinAge,0)MinAge,
			'/Images/ProductImages/'+(case when isnull(SM.SKUImagePath,'')!='' then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
			then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
			, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice
			from CartSKUMaster csm
			left join SKUMaster sm on sm.AutoId=csm.SKUId
			where OrderAutoId=@OrderId order by csm.AutoId Desc 
			for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
			isnull((
			select @OrderId OrderId, @Ono OrderNo, isnull(@Disc,0) Discount,@DiscType DiscType,@UserName as UserName,@Discount DiscountPer,
			isnull((select Count(*) from CartSKUMaster where OrderAutoId=@OrderId),0)ItemCount,
			isnull((select sum(Quantity) from CartSKUMaster where OrderAutoId=@OrderId),0)TotalQuantity,
			isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName='Lottery Payout' ),0) [LotteryPayout],
			isnull((Select sum(total) from CartSKUMaster where OrderAutoId=@OrderId and SKUName like '%Lottery%' ),0) [LotteryTotal],
			isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=@OrderId and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
			isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=@OrderId),0) [TotalTax],
			isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=@OrderId),0) [OrderTotal]
			for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
			for json path, INCLUDE_NULL_VALUES
		
		End
		else
		begin
		    select isnull((select AutoId, 
			--(case when isnull(@UserName,'')='' then '' else FirstName +isnull(' '+LastName,'') end) 
			'' as [Name] from CustomerMaster where StoreId=@StoreId and FirstName like 'Walk In' for json path, INCLUDE_NULL_VALUES),'[]') as [CustomerDetail],
			isnull((
			Select csm.AutoId as CartItemId,csm.SKUId ,csm.SKUName, csm.SchemeId, csm.Quantity,isnull(MinAge,0)MinAge,
			'/Images/ProductImages/'+(case when isnull(SM.SKUImagePath,'')!='' then SM.SKUImagePath  when (csm.SKUName='Lottery Payout' OR csm.SKUName='Lottery Sale')
			then 'LottoImg.png' when csm.SKUName like '%Gift Card%' then 'GiftCardImage.png' Else 'product.png' end) as ProductImagePath, csm.Tax, csm.Total,csm.SKUUnitPrice UnitPrice
			, isnull(sm.SKUUnitTotal,csm.SKUUnitPrice)OrgUnitPrice
			from CartSKUMaster csm
			left join SKUMaster sm on sm.AutoId=csm.SKUId
			where OrderAutoId=isnull(@OrderId,0) order by csm.AutoId Desc 
			for json path, INCLUDE_NULL_VALUES),'[]') as ProductList,
			isnull((
			select isnull(@OrderId,0) OrderId, '' OrderNo, isnull(@Disc,0) Discount,'' DiscType,@UserName as UserName,0 DiscountPer,
			isnull((select Count(*) from CartSKUMaster where OrderAutoId=isnull(@OrderId,0)),0)ItemCount,
			isnull((select sum(Quantity) from CartSKUMaster where OrderAutoId=isnull(@OrderId,0)),0)TotalQuantity,
			isnull((Select sum(total) from CartSKUMaster where OrderAutoId=isnull(@OrderId,0) and SKUName='Lottery Payout' ),0) [LotteryPayout],
			isnull((Select sum(total) from CartSKUMaster where OrderAutoId=isnull(@OrderId,0) and SKUName like '%Lottery%' ),0) [LotteryTotal],
			isnull((Select sum(SKUUnitPrice*Quantity) from CartSKUMaster where OrderAutoId=isnull(@OrderId,0) and SKUName!='Lottery Payout' and SKUName  not like '%Lottery%'  ),0) [Subtotal],
			isnull((Select sum(tax) from CartSKUMaster where OrderAutoId=isnull(@OrderId,0)),0) [TotalTax],
			isnull((select sum(Total)-isnull(@Disc,0) from CartSKUMaster where OrderAutoId=isnull(@OrderId,0)),0) [OrderTotal]
			for json path, INCLUDE_NULL_VALUES),'[]')as OrderDetail
			for json path, INCLUDE_NULL_VALUES
		end
 End
  else if @Opcode=14
 begin
      select ROW_NUMBER() over(order by IM.AutoId desc)RowNumber,IM.AutoId, InvoiceNo, format(InvoiceDate,'MM/dd/yyyy hh:mm tt')InvoiceDate, PaymentMethod
	  , cast(Tax as decimal(18,2))Tax, IM.CustomerId,CM.FirstName+isnull(' '+CM.LastName,'')CustomerName, IM.Status,IM.UserId,
	  isnull(UM.FirstName,'')+isnull(' '+UM.LastName,'')+'<br/>'+format(UpdateDate,'MM/dd/yyyy hh:mm tt')UpdationDetails, 
	  cast(Discount as decimal(18,2))Discount, cast(Total as decimal(18,2))Total, IM.TerminalId, Coupon,TM.TerminalName,
	  cast(CouponAmt as decimal(18,2))CouponAmt,CreatedFrom
	  into #Temp
	  from InvoiceMaster IM
	  left join CustomerMaster CM on CM.AutoId=IM.CustomerId
	  left join TerminalMaster TM on TM.AutoId=IM.TerminalId
	  left join UserDetailMaster UM on Um.UserAutoId=IM.UpdateBy
	  where IM.StoreId=@StoreId 
	  and convert(date,InvoiceDate)= convert(date,getdate()) 
	  and (IM.TerminalId=@TerminalId)

	  SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By:Created date Desc' as SortByString
	  FROM #Temp      
	  
      Select  * from #Temp t
      WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))       
      order by AutoId desc

 end
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
