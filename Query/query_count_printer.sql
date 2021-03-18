-- In this query, we only count the assets that have the assetTypeName 'Printer'

SELECT COUNT(*)
From tblAssets
	Inner Join tsysAssetTypes On tsysAssetTypes.AssetType = tblAssets.Assettype

Where tsysAssetTypes.AssetTypename = 'Printer' AND tblAssets.scanserver = 'scannerToChange'