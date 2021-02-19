SELECT	tblAssetGroups.AssetGroup, 
        tsysAssetGroupFilter.CompareValue

FROM tblAssetGroups 

INNER JOIN tsysAssetGroupFilter On tblAssetGroups.AssetGroupID = tsysAssetGroupFilter.AssetGroupID 

ORDER BY tblAssetGroups.AssetGroup ASC;
