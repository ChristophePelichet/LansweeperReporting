SELECT COUNT(*)
From tblAssets
	Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID
	Inner Join tblSystemEnclosure On tblAssets.AssetID = tblSystemEnclosure.AssetID
	Inner Join TsysChassisTypes On TsysChassisTypes.Chassistype = tblSystemEnclosure.ChassisTypes
	Inner Join tsysOS On tsysOS.OScode = tblAssets.OScode

Where tblAssetCustom.State = 1
		AND tsysOS.OSname NOT LIKE '%Win 20%'
		AND TsysChassisTypes.Chassistype IN (8,9,10,31)
        AND tblAssets.scanserver = 'scannerToChange' 