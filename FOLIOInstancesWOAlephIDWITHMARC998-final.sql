--Date: Jul 16, 2024 Time: 3:26:48 PM
with nonAlephID as (
	select
		distinct iti.id
	from
		inventory.instance__t__identifiers iti
	where
		iti.identifiers__identifier_type_id <> '11effde5-6bf4-49ac-b9a4-040ef765ed88'
),
aleph as (
	select
		distinct inventory.instance__t__identifiers.id
	from
		inventory.instance__t__identifiers
	where
		inventory.instance__t__identifiers.identifiers__identifier_type_id = '11effde5-6bf4-49ac-b9a4-040ef765ed88'
),
missingid as (
	select
		id
	from
		nonAlephID
except
	select
		id
	from
		aleph
order by
		id
),
mt998 as (
	select
		srs_id,
		instance_id,
		string_agg("content",
		'|'
		order by
		line) as "998aleph"
	from
	marctab.mt998
	group by
		srs_id,
		instance_id
)
	select
		 	mt998.srs_id as marctab998_srs,
			missingid.id as instance_noAlephId,
			rt.metadata__created_date::date as srs_record_created,
			ut.username as metadata_created_by_user,
			it.metadata__updated_date::date as instance_updated,
			ut2.username as metadata_updated_by_user,
			rt.external_ids_holder__instance_hrid as record_matchedinstanceHRID,
			mt998."998aleph" as MARC_Aleph_Identifiers
	from
		missingid
	inner join mt998 on
		mt998.instance_id::uuid = missingid.id::uuid
	inner join inventory.instance__t it on 
		it.id::uuid = mt998.instance_id::uuid
	inner join folio_source_record.records__t rt on
		rt.record_id::uuid = mt998.srs_id::uuid
	inner join users.users__t ut on
		ut.id = rt.metadata__created_by_user_id
	inner join users.users__t ut2 on
		ut2.id = it.metadata__updated_by_user_id
	order by it.metadata__updated_date