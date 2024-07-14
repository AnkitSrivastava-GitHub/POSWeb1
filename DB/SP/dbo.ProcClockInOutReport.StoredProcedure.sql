create or alter PROCEDURE [dbo].[ProcClockInOutReport]
@Opcode int= null,
@FromDate datetime=null,
@ToDate  datetime=null,
@EmpId int=null,
@StoreId int=null,
@Who varchar(50)=null,
@PageIndex INT=1,
@PageSize INT=10,
@RecordCount INT=null,
@isException BIT out,
@exceptionMessage VARCHAR(max) OUT
as 
BEGIN
BEGIN TRY
         SET @exceptionMessage='Success'
         SET @isException=0
      If @Opcode=11
      BEGIN
			select ROW_NUMBER() over(order by AutoId asc) as RowNumber,AutoId,concat(UDM.FirstName,' ',UDM.LastName) as EmpName,Remark,FORMAT(ClockIN, 'MM-dd-yyyy hh:mm:ss tt') as ClockIN,
			FORMAT(ClockOUT, 'MM-dd-yyyy hh:mm:ss tt') as ClockOUT,Concat(TotalTime,' Hour') as TotalTime,CloseRemark
			into #tempT
			from ClockInOut CIO Inner JOIN UserDetailMaster UDM on CIO.EmpId=UDM.UserAutoId
			where StoreId=@StoreId 
			and (@EmpId is null or @EmpId=0 or UDM.UserAutoId=@EmpId)
			and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or ( convert(date,ClockIN) between convert(date,@FromDate) and convert(date,@ToDate)))
			ORDER BY ClockIN desc

			SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: User Name asc' as SortByString FROM #tempT

			Select  * from 
			#tempT t
			WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
			order by ClockIN desc
	  END
	   If @Opcode=12
      BEGIN
			select UserAutoId,concat(FirstName,' ',LastName) as Name from UserDetailMaster UM 
			INNER JOIN EmployeeStoreList EL on EL.EmployeeId=UM.UserAutoId
			where UM.Status=1 and UserType=4 and EL.CompanyId=@StoreId
	  END
	   If @Opcode=13
      BEGIN	 
			select ROW_NUMBER() over(order by CT.EmpId asc) as RowNumber,max(CT.EmpId) as EmpId,SUM(CT.TotalTime) as TotalWorkingHour,(max(UM.FirstName) + max(UM.LastName)) as UserName,			
			(SUM(isnull(CT.TotalTime,0)) * isnull((max(CT.HourlyRate)),0)) as TotalHourlyAmt into #tempT2 from ClockINOUT CT 			
			Inner Join UserDetailMaster UM on UM.UserAutoId=CT.EmpId and UM.UserType=4
			where StoreId=@StoreId 
			and (@EmpId is null or @EmpId=0 or UM.UserAutoId=@EmpId)
			and (@FromDate is null or @FromDate='' or @ToDate is null or @ToDate='' or (convert(date,CT.ClockIN) between convert(date,@FromDate) and convert(date,@ToDate)))			
			group by CT.EmpId ORDER BY UserName asc			

			SELECT  COUNT(*) as RecordCount, @PageSize as PageSize, @PageIndex as PageIndex,'#Sort By: User Name asc' as SortByString FROM #tempT2

			Select * from 
			#tempT2 t
			WHERE (@PageSize=0 or (RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1)) 
			order by  UserName asc
	  END
	  End TRY
BEGIN CATCH
		SET @isException=1
		SET @exceptionMessage=ERROR_MESSAGE()
END CATCH
END
GO