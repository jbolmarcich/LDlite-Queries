--meadb:table locations_libraries
-- Create derived table that combines institution, campus, library, and location information

DROP TABLE IF EXISTS public.locations_libraries;

CREATE TABLE public.locations_libraries AS
SELECT
    cmp.id AS campus_id,
    cmp.name AS campus_name,
    cmp.code AS campus_code,
    loc.id AS location_id,
    loc.name AS location_name,
    loc.code AS location_code,
    loc.discovery_display_name AS discovery_display_name,
    lib.id AS library_id,
    lib.name AS library_name,
    lib.code AS library_code,
    inst.id AS institution_id,
    inst.name AS institution_name,
    inst.code AS institution_code
FROM
    inventory.loccampus__t AS cmp
    LEFT JOIN inventory.location__t AS loc ON cmp.id::uuid = loc.campus_id::uuid
    LEFT JOIN inventory.locinstitution__t AS inst ON loc.institution_id::uuid = inst.id::uuid
    LEFT JOIN inventory.loclibrary__t AS lib ON loc.library_id::uuid = lib.id::uuid;
    
  
-- derived locations_service_points
-- Creates a derived table that extracts the service points array from 
-- locations and creates a direct connection between the locations and
-- all of their service points.
 
DROP TABLE IF EXISTS locations_service_points;

create table locations_service_points as
    select
	(service_points.data #>> '{}')::uuid as service_point_id,
	isp.discovery_display_name as service_point_discovery_display_name,
	isp.name as service_point_name,
	ll.location_id,
	ll.discovery_display_name as location_discovery_display_name,
	ll.location_name,
	ll.location_code,
	ll.library_id,
	ll.library_name,
	ll.library_code,
	ll.campus_id,
	ll.campus_name,
	ll.campus_code,
	ll.institution_id,
	ll.institution_name,
	ll.institution_code
from
	inventory.location as il
cross join lateral jsonb_array_elements(jsonb_extract_path(il.jsonb,
	'servicePointIds')) as service_points (data)
left join inventory.service_point__t as isp on
	(service_points.data #>> '{}')::uuid = isp.id::uuid
left join public.locations_libraries as ll on (il.jsonb->>'id')::uuid = ll.location_id::uuid;

-- Associate self checkout SPs with sc and um stacks for circ calculation
insert into public.LOCATIONS_SERVICE_POINTS VALUES
('6b6b9f00-aac7-4e20-a819-fb24386e48bb',
'SC Self Check',
'SC Self Check',
'272372df-cbc8-4980-98e4-47f580b5b3b0',
'Smith College Neilson Stacks',
'SC Neilson Stacks',
'd541a5ab-50d8-4822-83fc-8469ddfcbb57',
'SC Neilson Library',
'7d02e46d-3e60-4eaf-a986-5aa3550e8cb5',
'Smith College',
'58effc21-7273-4074-8da4-9972e49073e6',
'Five Colleges'),
('a89abfb8-44c0-4b82-9e64-b51e2fa8bcb0',
'UM Self Check',
'UM Self Check',
'4be64634-d515-4d92-8f5a-b9702d971d26',
'UMass Amherst Du Bois General Collection',
'UM W.E.B. Du Bois General Collections',
'f2ccdb19-6f46-4171-bd8e-be890ea67133',
'UM W. E. B. Du Bois library',
'1693a1d9-ef32-429a-86e2-55b483a594d1',
'University Of Massachusetts ',
'58effc21-7273-4074-8da4-9972e49073e6',
'Five Colleges')
