-- In this query, we count the OEM Windows license.

Select COUNT(*)
       From tblAssets 
		Inner Join tblOperatingsystem On tblAssets.AssetID = tblOperatingsystem.AssetID 
		Inner Join tblAssetCustom ON	tblAssets.AssetID = tblAssetCustom.AssetID 
		Inner Join tsysOS	On tblAssets.OScode = tsysOS.OScode
	WHERE tblAssetCustom.State = 1
		AND (
		       tblOperatingsystem.SerialNumber LIKE '%-OEM-%'
			OR  tblOperatingsystem.SerialNumber LIKE '%OEM'
		)
		AND tblAssets.scanserver = 'scannerToChange' 