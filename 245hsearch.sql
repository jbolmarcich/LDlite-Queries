select
	sm.instance_hrid,
	sm.srs_id,
	sm.matched_id, 
	sm.field,
	sm.ind1,
	sm.ind2,
	sm.sf,
	sm."content"
from
	public.srs_marctab sm
inner join public.srs_marctab sm2 on
	sm2.instance_hrid = sm.instance_hrid
where
	sm.field like '245'
	and sm.sf like 'h'
	and sm."content" like '[electronic resource]%'
	and sm2.field like '655'
	and sm2."content" like 'Electronic books.'
order by
	sm.instance_hrid; 

	
	


	