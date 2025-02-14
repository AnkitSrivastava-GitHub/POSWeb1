USE [PW_POS]
GO
/****** Object:  UserDefinedFunction [dbo].[SequenceCodeGenerator]    Script Date: 6/16/2023 8:01:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[SequenceCodeGenerator](@SequenceCode nvarchar(50))
returns nvarchar(25)
as begin
 declare @NewSequence nvarchar(25)

 select 
@NewSequence=(
PreSample
+
substring(PostSample,1,(len(PostSample)-len(currentSequence+1)))
+
convert(nvarchar,currentSequence+1)
)
from SequenceCodeGeneratorMaster 
where SequenceCode=@SequenceCode
 return @NewSequence
end
GO
