select
*
from
	folio_source_record.srs_marctab sm
left join folio_source_record.srs_marctab sm2 on
	sm2.instance_hrid = sm.instance_hrid
where
	sm.field like '245'
	and sm.sf like 'h'
	and sm."content" like '[electronic resource]%'
	and sm2.field not like '655'
	and sm2."content" not like 'Electronic book%';
	
	


	
