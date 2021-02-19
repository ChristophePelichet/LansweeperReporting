SELECT COUNT(*)
From tblAssets
	Inner Join tsysAssetTypes On tsysAssetTypes.AssetType = tblAssets.Assettype

Where tsysAssetTypes.AssetTypename LIKE '%Tablet%' AND tblAssets.scanserver = 'scannerToChange'