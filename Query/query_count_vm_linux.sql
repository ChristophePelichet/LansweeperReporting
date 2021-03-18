-- On this query we count only the virtual machine with Linux OS defined in the assetTypeName

Select COUNT(*)
From tblAssets 
	Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID 
	Inner Join tsysAssetTypes ON tsysAssetTypes.AssetType = tblAssets.Assettype 
	Left Join tsysOS ON	tblAssets.OScode = tsysOS.OScode
WHERE tblAssetCustom.State = 1
	AND tsysAssetTypes.AssetTypename = 'Linux'
	AND ( tblAssetCustom.Model = 'Virtual machine'
		OR tblAssetCustom.Model = 'Vmware Virtual Plaform'
		OR tblAssetCustom.Model = 'AHV'
		OR tblAssetCustom.Manufacturer = 'VMware, Inc.'
		OR tblAssetCustom.Manufacturer = 'Nutanix'
	)
	AND tblAssets.scanserver = 'scannerToChange' 


	