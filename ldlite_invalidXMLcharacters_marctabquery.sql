-- New script in ldplite.
-- Date: Feb 19, 2024 Time: 11:05:49 AM
select
	srs_id,
	instance_id,
	field as marc_field,
	"content" as subfield_content,
	substring(
		"content"
	from
		'.u0...'
	) as character_found,
	concat(
		'https://edge-fivecolleges-test.folio.ebsco.com/oai/records?verb=GetRecord&apikey=eyJzIjoiNjdrR1p5MzlTMCIsInQiOiJmczAwMDAxMDA2IiwidSI6ImZzMDAwMDEwMDYifQ==&metadataPrefix=marc21_withholdings&identifier=oai:edge-fivecolleges-test.folio.ebsco.com:fs00001006/',
		instance_id
	) as "EDGE_OAI-PMH_URL"
from
	FOLIO_SOURCE_RECORD.marctab
where
		(
		field not like '0%'
		)
	and (
		"content" not like '%iu00%'
	)
	and  
(
		(
			"content" like '%{u0%'
		)
			or 
(
				"content" like '%\u0___%'
			)
				or 
(
					"content" like '%u0___%'
				)
	);