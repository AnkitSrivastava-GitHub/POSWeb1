USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcBackUp]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   procedure [dbo].[ProcBackUp]
@Opcode int = null,
@AutoId int = null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
begin
BEGIN TRY
	SET @isException=0
	SET @exceptionMessage='Success!!'
	If @Opcode = 21
	Begin
		Update BrandMaster set APIStatus=1 where AutoId=@AutoId
		Select count(1) from BrandMaster where isnull(APIStatus,0)=0 
	end
	else If @Opcode = 22
	Begin
		Update CategoryMaster set APIStatus=1 where AutoId=@AutoId
		Select count(1) from CategoryMaster where isnull(APIStatus,0)=0 
	end
	else If @Opcode = 23
	Begin
		Update ProductMaster set APIStatus=1 where AutoId=@AutoId
		Select count(1) from ProductMaster where isnull(APIStatus,0)=0 
	end
	else If @Opcode = 41
	Begin
		Select top 1 AutoId as BrandAutoId, (Select top 1 CompanyId from [CompanyProfile]) as CompanyId,
		BrandId, BrandName as Brand, Status, IsDeleted, [UpdatedBy] as Who,[UpdatedDate] as ActionDate 
		from BrandMaster 
		where isnull(APIStatus,0)=0 
		order by AutoId asc
		for json path, INCLUDE_NULL_VALUES

		Select top 1 AutoId from BrandMaster where isnull(APIStatus,0)=0 order by AutoId asc
	End
	else If @Opcode = 42
	Begin
		Select top 1 AutoId as CatergoryAutoId, (Select top 1 CompanyId from [CompanyProfile]) as CompanyId,
		Categoryid as CatergoryId, CategoryName as Catergory, ParentId ,Status, IsDeleted, [UpdatedBy] as Who,[UpdatedDate] as ActionDate 
		from CategoryMaster 
		where isnull(APIStatus,0)=0 
		order by AutoId asc
		for json path, INCLUDE_NULL_VALUES

		Select top 1 AutoId from CategoryMaster where isnull(APIStatus,0)=0 order by AutoId asc
	end
	else If @Opcode = 43
	Begin
		Select (Select top 1 CompanyId from [CompanyProfile]) as CompanyId,  pm.CategoryId,  pm.VendorId, pm.BrandId, pm.AgeRestrictionId, 
		pm.AutoId as ProductAutoId, pm.ProductId, pm.ProductName, pm.Status,
		ptm.AutoId as PackingAutoId, ptm.CostPrice, ptm.UnitPrice, ptm.TaxAutoId, pm.UpdatedBy as Who, pm.UpdatedDate as ActionDate, 
		   pm.IsDeleted, bm.Barcode
		from ProductMaster pm
		inner join PackingTypeMaster ptm on pm.AutoId=ptm.ProductAutoId
		inner join BarcodeMaster bm on ptm.AutoId=bm.Packingid and BarcodeType='Packing'
		where isnull(pm.APIStatus,0)=0 
		order by pm.AutoId asc
		for json path, INCLUDE_NULL_VALUES

		Select top 1 AutoId from ProductMaster where isnull(APIStatus,0)=0 order by AutoId asc
	end
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 

GO
