-- On this query we select only Kaspersky Endpoint Security for Windows or Kaspersky Endpoint Agent

SELECT COUNT(*)
	From tblSoftware 
		Inner Join tblAssets On tblSoftware.AssetID = tblAssets.AssetID 
		Inner Join tblSoftwareUni On tblSoftware.softID = tblSoftwareUni.SoftID 
	
	WHERE tblSoftwareUni.SoftwarePublisher = 'AO Kaspersky Lab'
			AND (tblSoftwareUni.SoftwareName = 'Kaspersky Endpoint Security for Windows'
				OR tblSoftwareUni.SoftwareName LIKE 'Kaspersky Endpoint Agent%')
			AND tblAssets.scanserver = 'scannerToChange' 




-- If you want to show the all Kaspersky Publisher Software in your DB you can use this query directly.

-- SELECT	tblSoftwareUni.SoftwarePublisher,
--			tblSoftwareUni.SoftwareName
--	From tblSoftware 
--		Inner Join tblAssets On tblSoftware.AssetID = tblAssets.AssetID 
--		Inner Join tblSoftwareUni On tblSoftware.softID = tblSoftwareUni.SoftID		
--	WHERE tblSoftwareUni.SoftwarePublisher = 'AO Kaspersky Lab'