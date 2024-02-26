-- ACRL COLLECTION QUESTIONS - hc
-- Date: Feb 23, 2024 Time: 10:51:38 AM
-- 40B - digital.sql
select
	count(distinct it2.id) as "40B Books - digital (title count)",
		 ls.campus_code
from
	inventory.item__t it
left join inventory.material_type__t mtt on
	mtt.id = it.material_type_id
left join inventory.holdings_record__t hrt on
	hrt.id = it.holdings_record_id
left join inventory.instance__t it2 on
	it2.id = hrt.instance_id
left join public.locations_service_points as ls on
	ls.location_id = it.effective_location_id
where
	(
		ls.location_name in (
			'FC Chinamaxx E-resources', 'FC Depository%'
		)
			or ls.campus_code like 'HC'
	)
	and it.status__name in (
		'Awaiting pickup', 'In transit', 'Checked out', 'Available', 'Restricted', 'Paged'
	)
	and mtt.name in (
		'E-Book', 'E-Book Package', 'E-Score', 'E-Thesis/Dissertation'
	)
group by
	rollup(
		ls.campus_code
	);  

-- 40a - physical volume.sql
select
	count(distinct it.id) as "40a Books - physical (volume count)"
from
	inventory.item__t it
left join inventory.material_type__t mtt on
	mtt.id = it.material_type_id
left join inventory.holdings_record__t hrt on
	hrt.id = it.holdings_record_id
left join inventory.instance__t it2 on
	it2.id = hrt.instance_id
left join public.locations_service_points as ls on
	ls.location_id = it.effective_location_id
where
	(
		(
		ls.campus_code = 'RP'
		and mtt.name in ('Archival material', 'Book', 'Government Publication', 'Score', 'Thesis/Dissertation')
		)
		or (
		ls.campus_code = 'HC'
			and mtt.name in ('Archival material', 'Book', 'Government Publication', 'Journal', 'Serial', 'Score', 'Supplement', 'Thesis/Dissertation')
			)
	)
	and it.status__name in ('Available', 'Awaiting pickup', 'Checked out', 'In transit', 'Paged', 'Restricted')
	and it.METADATA__CREATED_DATE < '2023-07-01%';

-- 40A - physical.sql
select count(distinct it2.id) as "40A Books - physical (title count)"
from inventory.item__t it
    left join inventory.material_type__t mtt on mtt.id = it.material_type_id
    left join inventory.holdings_record__t hrt on hrt.id = it.holdings_record_id
    left join inventory.instance__t it2 on it2.id = hrt.instance_id
    left join public.locations_service_points AS ls on ls.location_id = it.effective_location_id
where ls.campus_code in ('HC','RP')
    and it.status__name in ('Available','Awaiting pickup','Checked out','In transit','Paged','Restricted')
    and mtt.name in ('Archival material', 'Book', 'Government Publication', 'Score', 'Thesis/Dissertation')
   and it.METADATA__CREATED_DATE < '2023-07-01%';
   
-- 42B- digital.sql
select count(distinct it2.id) as "42B Media - digital (title count)"
from inventory.item__t it
    left join inventory.material_type__t mtt on mtt.id = it.material_type_id
    left join inventory.holdings_record__t hrt on hrt.id = it.holdings_record_id
    left join inventory.instance__t it2 on it2.id = hrt.instance_id
    left join public.locations_service_points AS ls on ls.location_id = it.effective_location_id
where (ls.campus_code = 'HC' or ls.location_name in ('FC Annex','FC Depository Monographs','FC Depository Serials','FC Depository Thesis','FC Chinamaxx E-resources','FC ASP Classical Music Online','FC ASP Dance in Video (volume 1)','FC Cambridge Histories Online [ONLY for pub years X-2012]','FC E-Resources','FC Free E-Resources','FC JSTOR Purchased eBooks'))
    and it.status__name in ('Awaiting pickup', 'In transit', 'Checked out', 'Available', 'Restricted', 'Paged')
    and mtt.name in ('Data File', 'Streaming Audio', 'Streaming Video')
   and it.METADATA__CREATED_DATE < '2023-07-01%';
   
-- 42A - physical.sql
select
	count(distinct it2.id) as "42A Media - physical (title count)",
	mtt."name",
	ls.location_name 
from
	inventory.item__t it
left join inventory.material_type__t mtt on
	mtt.id = it.material_type_id
left join inventory.holdings_record__t hrt on
	hrt.id = it.holdings_record_id
	--left join inventory.HOLDINGS_RECORD__T__ELECTRONIC_ACCESS AS HRTEA using (id)
left join inventory.instance__t it2 on
	it2.id = hrt.instance_id
left join public.locations_service_points as ls on
	ls.location_id = it.effective_location_id
where
	(ls.campus_code = 'HC'
		or ls.location_name in ('FC Annex', 'FC Depository Monographs', 'FC Depository Serials', 'FC Depository Thesis'))
		--and it.status__name in ('Awaiting pickup', 'In transit', 'Checked out', 'Available', 'Restricted', 'Paged')
			and mtt.name not in ('Admin', 'Book', 'Journal', 'Serial', 'Newspaper', 'Score', 'Thesis/Dissertation', 'Archival Material', 'Government Publication',
    'Streaming Audio', 'E-Book', 'E-Book Package', 'E-Journal', 'E-Journal Package', 'E-Newspaper', 'E-Score', 'E-Thesis/Dissertation')
			--and (hrtea.electronic_access__relationship_id <> 'de99e40d-55cd-4048-a9d9-bd7d026ac683' or hrt.HOLDINGS_TYPE_ID <> '72f61732-b38c-49e9-8c6e-f4cd1139014c')
				and it.METADATA__CREATED_DATE < '2023-07-01%'
			group by
				rollup(ls.location_name,mtt."name");
   
-- 43B- digital.sql
select count(distinct it2.id) as "43B Serials - digital (title count)"
from inventory.item__t it
    join inventory.material_type__t mtt on mtt.id = it.material_type_id
    join inventory.holdings_record__t hrt on hrt.id = it.holdings_record_id
    join inventory.instance__t it2 on it2.id = hrt.instance_id
    join public.locations_service_points AS ls on ls.location_id = it.effective_location_id
where (ls.campus_code = 'HC' or ls.location_name in ('FC Annex','FC Depository Monographs','FC Depository Serials','FC Depository Thesis','FC Chinamaxx E-resources','FC ASP Classical Music Online','FC ASP Dance in Video (volume 1)','FC Cambridge Histories Online [ONLY for pub years X-2012]','FC E-Resources','FC Free E-Resources','FC JSTOR Purchased eBooks')
    and it.status__name in ('Awaiting pickup', 'In transit', 'Checked out', 'Available', 'Restricted', 'Paged')
    and mtt.name in ('E-Journal', 'E-Journal Package', 'E-Newspaper')
   and it.METADATA__CREATED_DATE < '2023-07-01%';
   
-- 43A - physical.sql
select count(distinct it2.id) as "43A Serials - physical (title count)"
from inventory.item__t it
    left join inventory.material_type__t mtt on mtt.id = it.material_type_id
    left join inventory.holdings_record__t hrt on hrt.id = it.holdings_record_id
    left join inventory.instance__t it2 on it2.id = hrt.instance_id
    left join public.locations_service_points AS ls on ls.location_id = it.effective_location_id
where (ls.campus_code = 'HC' or ls.location_name in ('FC Annex','FC Depository Monographs','FC Depository Serials','FC Depository Thesis'))
    and it.status__name in ('Awaiting pickup', 'In transit', 'Checked out', 'Available', 'Restricted', 'Paged')
    and mtt.name in ('Journal', 'Newspaper', 'Serial')
   and it.METADATA__CREATED_DATE < '2023-07-01%';
   
-- 60 - physical.sql
select
    count(distinct alt.id) as "60 Physical Circulation",
    lc.code as loan_effloc,
    lt3.code as loan_checkout_sp
from circulation.audit_loan__t alt
    left join inventory.LOCATION__T AS lt on lt.id = alt.LOAN__ITEM_EFFECTIVE_LOCATION_ID_AT_CHECK_OUT     
    left join inventory.LOCCAMPUS__T AS LC on lc.id = lt.campus_id
    left join inventory.LOCATION__T__SERVICE_POINT_IDS AS LTSPI on ltspi.service_point_ids = alt.LOAN__CHECKOUT_SERVICE_POINT_ID 
    left join inventory.LOCATION__T AS LT2 on lt2.id = ltspi.id
    left join inventory.LOCCAMPUS__T AS LT3 on lt3.id = lt2.campus_id
    left join users.users__t ut on ut.id = alt.loan__user_id
    left join inventory.item__t it on it.id = alt.loan__item_id
    left join inventory.material_type__t mtt on mtt.id = it.material_type_id
    where alt.loan__action in ('checkedout', 'checkedOutThroughOverride')
    and lc.code in ('HC','RP')
    and mtt.name <> 'Equipment'
    and alt.loan__loan_date between '2022-07-01' and '2023-06-30'
   group by (lc.code,lt3.code)
    --and ut.external_system_id like '%hampshire.edu';
   
-- 81 - consortia.sql
select
    count(distinct alt.id) as "81 Loans to FC"
from circulation.audit_loan__t alt
    left join public.locations_service_points AS ls on ls.location_id = alt.loan__item_effective_location_id_at_check_out
    left join users.users__t ut on ut.id = alt.loan__user_id
    left join inventory.item__t it on it.id = alt.loan__item_id
    left join inventory.material_type__t mtt on mtt.id = it.material_type_id
where alt.loan__action in ('checkedout', 'checkedOutThroughOverride')  
	 and ls.campus_code in ('HC','RP')
    and mtt.name <> 'Equipment'
    and alt.loan__loan_date between '2022-07-01' and '2023-06-30'
    and ut.external_system_id not like '%hampshire.edu';
   
-- 82- consortia.sql
select
    count(distinct alt.id) as "82 Loans from FC"
from circulation.audit_loan__t alt
    left join public.locations_service_points AS ls on ls.location_id = alt.loan__item_effective_location_id_at_check_out
    left join users.users__t ut on ut.id = alt.loan__user_id
    left join inventory.item__t it on it.id = alt.loan__item_id
    left join inventory.material_type__t mtt on mtt.id = it.material_type_id
where alt.loan__action in ('checkedout', 'checkedOutThroughOverride') 
	 and ls.campus_code not in ('HC', 'RP')
    and mtt.name <> 'Equipment'
    and alt.loan__loan_date between '2022-07-01' and '2023-06-30'
    and ut.external_system_id like '%hampshire.edu';