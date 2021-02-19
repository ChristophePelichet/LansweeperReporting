SELECT COUNT(*)
From tblAssets
	Inner Join tsysAssetTypes On tsysAssetTypes.AssetType = tblAssets.Assettype

Where tsysAssetTypes.AssetTypename LIKE '%Print%' AND tblAssets.scanserver = 'scannerToChange'