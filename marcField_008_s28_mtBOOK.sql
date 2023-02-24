select
	it.hrid,
	hrt.hrid,
	sm.field,
	sm."content",
	substring(sm.CONTENT from 29 for 1) as pos28_008,
	sm2.field,
	sm2."content",
	mtt."name",
	llt."name",
	lt.code,
	itp.publication__publisher
from
	inventory.item__t it
left join inventory.holdings_record__t hrt on
	hrt.id::uuid = it.holdings_record_id::uuid
left join inventory.location__t lt on
	 lt.id::uuid = hrt.permanent_location_id::uuid
left join public.srs_marctab sm on
	sm.instance_id::uuid = hrt.instance_id::uuid
left join public.srs_marctab sm2 on
	sm2.instance_id::uuid = hrt.instance_id::uuid
left join inventory.material_type__t mtt on
	mtt.id::uuid = it.material_type_id::uuid
left join inventory.instance__t__publication itp on
	itp.id::uuid = hrt.instance_id::uuid
left join inventory.loclibrary__t llt on
	llt.id::uuid = lt.library_id::uuid
left join inventory.instance_format__t ift on
	ift.id::uuid = hrt.instance_id::uuid
where
	it.material_type_id = '2d72aa13-2451-41fe-afc7-b3dc7c131389'
	and sm.field = '008'
	and sm2.field = '300'
	and substring(sm.CONTENT from 29 for 1) = 's'
order by
	llt."name",
	itp.publication__publisher;