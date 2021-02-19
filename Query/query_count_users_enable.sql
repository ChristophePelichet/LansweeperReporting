SELECT COUNT(*)
	FROM	tblADusers
	WHERE  tblADusers.Userdomain IN (
                SELECT Domain FROM tblAssets WHERE tblAssets.scanserver = 'scannerToChange' 
			    AND tblAssets.Domain <> ''
                AND tblAssets.Domain <> 'WORKGROUP'
                )
            AND tblADusers.IsEnabled = 'True'
 