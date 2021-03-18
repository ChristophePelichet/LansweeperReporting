-- In this query, we only count the assets that have the assetTypeName 'San'

Select COUNT(*)
   	From tblAssets Inner Join tblAssetCustom On tblAssets.AssetID =
          tblAssetCustom.AssetID Inner Join tsysAssetTypes On
          tsysAssetTypes.AssetType = tblAssets.Assettype Left Join tsysOS On
          tblAssets.OScode = tsysOS.OScode
	Where tsysAssetTypes.AssetTypename = 'San'
		AND tblAssets.scanserver = 'scannerToChange' 