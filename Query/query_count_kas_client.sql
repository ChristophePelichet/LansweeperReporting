SELECT COUNT(*)
	From tblSoftware 
		Inner Join tblAssets On tblSoftware.AssetID = tblAssets.AssetID 
		Inner Join tblSoftwareUni On tblSoftware.softID = tblSoftwareUni.SoftID 
	
	WHERE tblSoftwareUni.SoftwarePublisher = 'AO Kaspersky Lab'
			AND tblSoftwareUni.SoftwareName = 'Kaspersky Endpoint Security for Windows'
			AND tblAssets.scanserver = 'scannerToChange' 



			
