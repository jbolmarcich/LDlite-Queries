SELECT
    IT.barcode AS barcode,
    IT.hrid AS itemHRID,
    IT.effective_call_number_components__prefix AS effCallNo_Prefix,
    IT.effective_call_number_components__call_number AS effCallNo,
    IT.copy_number AS ""copy"",
    IT.volume AS vol,    
    IT2.title AS title,
    IT2.publication_period__start AS pubDate,
    MTT.""name"" AS materialType,
    IT.status__name AS itemStatus,
    IT.status__date AS itemStatusDate,
    SPT.""name"" AS destination,
    LT.""name"" AS locationName,
    IT2.hrid AS instanceHRID,
    IT2.id AS instanceUUID,
    HRT.HRID AS holdingsHRID,
    HRT.id AS holdingsUUID,
    IT.id AS itemUUID,
    IT.effective_shelving_order AS effShelving
FROM
    inventory.item__t IT
LEFT JOIN inventory.service_point__t SPT ON
    IT.in_transit_destination_service_point_id = SPT.id
LEFT JOIN inventory.material_type__t MTT ON
    IT.material_type_id = MTT.id
LEFT JOIN inventory.location__t LT ON
    IT.effective_location_id = LT.id
LEFT JOIN inventory.holdings_record__t HRT ON
    IT.holdings_record_id = HRT.id
INNER JOIN inventory.instance__t IT2 ON
    HRT.instance_id = IT2.id
WHERE
    LT.code = 'HSTAC'
    AND IT.effective_call_number_components__call_number LIKE 'HQ%'
ORDER BY
    IT.effective_shelving_order
