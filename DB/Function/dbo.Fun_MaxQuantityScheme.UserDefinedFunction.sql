USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_MaxQuantityScheme]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[Fun_MaxQuantityScheme]
(
@AutoId int
)
returns int 
as
begin
declare @result int
set @result=(
Select  isnull((Select top 1 Quantity from SchemeMaster where SKUAutoId=sm.SKUAutoId and Quantity>sm.Quantity order by Quantity asc),0) 
from SchemeMaster sm
where sm.AutoId=@AutoId 
)
return @result
end
GO
