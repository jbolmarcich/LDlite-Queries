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
	folio_source_record.srs_marctab sm
where
	sm.field like '245'
	sm.sf like 'h'
	sm."content" like_regex '.*\[electronic resource\].*|.*electronic book.*|^ebook.*';