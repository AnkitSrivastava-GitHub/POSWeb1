Create or ALTER proc [dbo].[ProcPrintBarcode]      
@Opcode int=NULL,   
@ProductId int=null,
@StoreId int=null,
@Who int=null,
@BarcodeCnt int=null,
@PageIndex INT = 1,        
@PageSize INT = 10,        
@RecordCount INT =null,        
@isException bit out,        
@exceptionMessage varchar(max) out      
AS        
BEGIN        
 BEGIN TRY        
  SET @exceptionMessage= 'Success'        
  SET @isException=0        
  IF @Opcode=11        
  BEGIN 
  set @BarcodeCnt=(select count(*) from BarcodeMaster where SKUId=@ProductId and StoreId=@StoreId)

  Select BM.AutoId,@BarcodeCnt BarcodeCNT,SM.AutoId as ProductId,BM.Barcode,SM.SKUName as ProductName,SM.SKUTotal as Price from BarcodeMaster BM 
  Inner Join SKUMaster SM on SM.AutoId=BM.SKUId
  where SM.AutoId=@ProductId and BM.StoreId=@StoreId 

  Select distinct  SM.AutoId as ProductId,@BarcodeCnt BarcodeCNT,SM.SKUName as ProductName from BarcodeMaster BM 
  Inner Join SKUMaster SM on SM.AutoId=BM.SKUId
  where SM.AutoId=@ProductId and BM.StoreId=@StoreId
  END  
  IF @Opcode=12      
  BEGIN   
	   Select BM.AutoId,@BarcodeCnt BarcodeCNT,SM.AutoId as ProductId,BM.Barcode,SM.SKUName as ProductName,SM.SKUTotal as Price from BarcodeMaster BM 
	  Inner Join SKUMaster SM on SM.AutoId=BM.SKUId
	  where BM.AutoId=@ProductId and BM.StoreId=@StoreId
   END      
    
 END TRY        
 BEGIN CATCH        
     SET @isException=1        
 SET @exceptionMessage= ERROR_MESSAGE()        
 END CATCH        
END        