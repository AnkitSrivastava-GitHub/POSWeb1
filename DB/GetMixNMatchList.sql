
--select * from MixNMatchItemList

--select SKUId,* from CartSKUMaster CSM where OrderAutoId=1628

--Select * from MixNMatchItemList where SKUAutoId=141767

--select * from CartMaster order by AutoId desc

--select * from CartItemMaster

drop table #TempMixId
;with cte as (Select mm.AutoId,mm.GroupName, mi.SKUAutoId, csm.SKUId, csm.Quantity
from MixNMatchMaster mm
inner join  MixNMatchItemList mi on mm.AutoId=mi.MixNMatchId
inner join CartSKUMaster csm on csm.SKUId=mi.SKUAutoId
where  csm.OrderAutoId=2357
)
select  AutoId,GroupName,sum(Quantity)SKUSum into #TempMixId
from cte
group by AutoId,GroupName
having sum(Quantity)>=(select MinQty from MixNMatchMaster t where t.AutoId=cte.AutoId)
select t.AutoId,t.GroupName,CSM.SKUName,ML.SKUAutoId,CSM.SKUId,CSM.Quantity CartQty,CSM.SKUUnitPrice,
MT.DiscountCriteria,[dbo].[fn_Cal_MixNmatchDiscountedPrice](ML.MixNMatchId,ML.SKUAutoId)DiscountPrice,CIM.TaxPer,
cast(([dbo].[fn_Cal_MixNmatchDiscountedPrice](ML.MixNMatchId,ML.SKUAutoId)*CIM.TaxPer)/100 as decimal(18,2)) Tax,
(cast([dbo].[fn_Cal_MixNmatchDiscountedPrice](ML.MixNMatchId,ML.SKUAutoId)as decimal(18,2))
+cast(([dbo].[fn_Cal_MixNmatchDiscountedPrice](ML.MixNMatchId,ML.SKUAutoId)*CIM.TaxPer)/100 as decimal(18,2))) Total
from MixNMatchItemList ML 
inner join MixNMatchMaster MM on MM.AutoId=ML.MixNMatchId
inner join MixNMatchDiscountCriteriaMaster MT on MT.AutoId=MM.DiscountCriteria
inner join CartSKUMaster CSM on CSM.SKUId=ML.SKUAutoId
inner join CartItemMaster CIM on CIM.CartItemId=CSM.AutoId
inner join #TempMixId t on t.AutoId=ML.MixNMatchId
where CSM.OrderAutoId=2357
order by CSM.SKUName asc
--where t.MixNMatchId in (select AutoId from #TempMixId)
