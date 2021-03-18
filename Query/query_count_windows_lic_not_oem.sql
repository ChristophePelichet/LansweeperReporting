-- In this query, we count the not OEM Windows license.

Select COUNT(*)
       From tblAssets 
		Inner Join tblOperatingsystem On tblAssets.AssetID = tblOperatingsystem.AssetID 
		Inner Join tblAssetCustom ON	tblAssets.AssetID = tblAssetCustom.AssetID 
		Inner Join tsysOS	On tblAssets.OScode = tsysOS.OScode
	WHERE tblAssetCustom.State = 1
		AND (
		       tblOperatingsystem.SerialNumber NOT LIKE '%-OEM-%'
			OR  tblOperatingsystem.SerialNumber NOT LIKE '%OEM'
		)
		AND tblAssets.scanserver = 'scannerToChange' 