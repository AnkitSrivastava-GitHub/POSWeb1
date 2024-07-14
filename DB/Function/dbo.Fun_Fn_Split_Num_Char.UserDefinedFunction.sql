Create or alter function Fn_Split_Num_Char(
@InputString varchar(max),
@OutPutpart varchar(10)
)
returns varchar(max) 
as
begin
declare @result varchar(max),@StringLen int,@CurrentIndex int=1,@NumPart varchar(max)='', @CharPart varchar(max)=''
   set @InputString=replace(@InputString,' ','')
   set @StringLen=len(isnull(@InputString,''))
   while(@CurrentIndex<=@StringLen)
   begin
     if(substring(@InputString,@CurrentIndex,1) like '%[0-9]%' or substring(@InputString,@CurrentIndex,1) like '.' )
     begin
          set @NumPart+=(substring(@InputString,@CurrentIndex,1))
     end
     else
     begin
        set @CharPart+=(substring(@InputString,@CurrentIndex,1))
     end
     set @CurrentIndex+=1
   end
   set @result=(select (case when isnull(@OutPutpart,'')='Number' then @NumPart 
   when isnull(@OutPutpart,'')='Character' then @CharPart 
   else 'please enter ''Number'' for Number part or ''Character'' for character part!' end))
   return @result
end