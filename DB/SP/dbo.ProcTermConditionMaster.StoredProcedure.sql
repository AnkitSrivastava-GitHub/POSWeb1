USE [pos101.priorpos.com]
GO
/****** Object:  StoredProcedure [dbo].[ProcTermConditionMaster]    Script Date: 9/23/2023 7:21:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE    procedure [dbo].[ProcTermConditionMaster]
@Opcode int= null,
@Term varchar(max)=null,
@Type varchar(20)=null,
@AutoId int=null,
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
 if @Opcode=11
   BEGIN      
    if exists(select Term from TermConditionMaster where Term=@Term )     
	   begin      
      SET @exceptionMessage= 'Terms already exists!'        
         SET @isException=1        
   end 
    else 
   begin      
       BEGIN TRY
	   BEGIN TRAN
	   SET @AutoId = (SELECT DBO.SequenceCodeGenerator('AutoId')) 

    Begin
	    insert into [dbo].[TermConditionMaster] ([Type],Term) values(@Type,@Term)
    End  
	 UPDATE SequenceCodeGeneratorMaster SET currentSequence = currentSequence + 1 WHERE SequenceCode='AutoId'  
			COMMIT TRANSACTION  
	   END TRY
	   BEGIN CATCH                                                                                                                                
			ROLLBACK TRAN                                                                                                                         
			Set @isException=1                                                                                                   
			Set @exceptionMessage='Oops! Something went wrong.Please try later.'                                                                      
		End Catch  
   end        
   END  
if @Opcode=21

 BEGIN
   if exists(select Term from TermConditionMaster where Term=@Term and AutoId!=@AutoId)     
   Begin      
      SET @exceptionMessage= 'Terms already exists!'        
      SET @isException=1        
   end 
   else 
   begin      
   BEGIN TRY
   BEGIN TRAN
    update [dbo].[TermConditionMaster] set Term=@Term, Type=@Type where AutoId=@AutoId
   COMMIT TRANSACTION  
   END TRY
   BEGIN CATCH                                                                                                                                
   	ROLLBACK TRAN                                                                                                                         
   	Set @isException=1                                                                                                   
   	Set @exceptionMessage='Oops! Something went wrong.Please try later.'                                                                      
   End Catch  
   end 
   END  
if @Opcode=41
 BEGIN
	select ROW_NUMBER() over(order by term asc) as RowNumber, tc.AutoId,tc.Term,
	ot.OrderType 
	into #temp
	from TermConditionMaster tc inner join OrderTypeMaster ot on
	tc.Type=ot.AutoId
	 and (@Term is null or @Term='' or Term like '%'+@Term+'%')
     and (@Type is null or @Type=0 or tc.Type=@Type)
	 SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex, 'Sort By: Term asc' as SortByString 
  FROM #temp  
  
   Select  * from #temp t  
   WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1))   
  order by  term asc 

	SET @isException=0	
 END
 IF @Opcode=42
 BEGIN
 delete from TermConditionMaster where AutoId=@AutoId
 SET @isException=0
 END
 IF @Opcode=31
 BEGIN
  select *from TermConditionMaster where AutoId=@AutoId
 END
 IF @Opcode=51
 BEGIN
 select AutoId,OrderType from  OrderTypeMaster 
 	SET @isException=0
 END
End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
end 
GO
