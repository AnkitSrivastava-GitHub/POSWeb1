USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_SKUTotal]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[Fun_SKUTotal]
(
@AutoId int
)
returns decimal(18,3) 
as
begin

declare @result decimal(18,3)
Set @result=(Select  SKUUnitTotal+SKUTotalTax from SKUMaster where AutoId=@AutoId)
return @result
end
GO
