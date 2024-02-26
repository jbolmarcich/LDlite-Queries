select 
   locations."name" as "Location",
    material."name" as "MaterialType",
    COALESCE(count(items.id),0) as "Item Count"
from inventory.location__t as locations
left join
    inventory.item__t as items on
    locations.id = items.effective_location_id
left join
	inventory.MATERIAL_TYPE__T as material on
    items.MATERIAL_TYPE_ID = material.id
where locations."name" like 'HC Division%'
group by rollup (material."name",locations."name")
order by "MaterialType"