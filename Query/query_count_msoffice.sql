-- On this query we select only Ms office Standard ans Pro (All Versions)

SELECT COUNT(*)
	From tblSoftware 
		Inner Join tblAssets On tblSoftware.AssetID = tblAssets.AssetID 
		Inner Join tblSoftwareUni On tblSoftware.softID = tblSoftwareUni.SoftID 
	WHERE tblSoftwareUni.SoftwarePublisher = 'Microsoft Corporation' 
			AND ( tblSoftwareUni.SoftwareName LIKE 'Microsoft Office Profession%' 
				OR tblSoftwareUni.SoftwareName LIKE 'Microsoft Office Stand%')
			AND tblAssets.scanserver = 'scannerToChange' 

-- If you want to show the all Micosoft Publisher Software in your DB you can use this query directly.

-- SELECT	tblSoftwareUni.SoftwareName,
--			tblSoftwareUni.SoftwarePublisher,
--			tblSoftware.softwareVersion
--	From tblSoftware 
--		Inner Join tblAssets On tblSoftware.AssetID = tblAssets.AssetID 
--		Inner Join tblSoftwareUni On tblSoftware.softID = tblSoftwareUni.SoftID 
--	WHERE tblSoftwareUni.SoftwarePublisher = 'Microsoft Corporation' 

			
