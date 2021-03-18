-- On this query we select only specific chassis type number if is NOT 8 9 10 and 31. 
-- Please show below the complet chassis type list.

SELECT COUNT(*)
From tblAssets
	Inner Join tblAssetCustom On tblAssets.AssetID = tblAssetCustom.AssetID
	Inner Join tblSystemEnclosure On tblAssets.AssetID = tblSystemEnclosure.AssetID
	Inner Join TsysChassisTypes On TsysChassisTypes.Chassistype = tblSystemEnclosure.ChassisTypes
	Inner Join tsysOS On tsysOS.OScode = tblAssets.OScode

Where tblAssetCustom.State = 1
		AND tsysOS.OSname NOT LIKE '%Win 20%'
		AND TsysChassisTypes.Chassistype NOT IN (8,9,10,31)
        AND tblAssets.scanserver = 'scannerToChange'


-- Chassis Types

-- 1 = Other
-- 2 = Unknown
-- 3 = Desktop
-- 4 = Low Profile Desktop
-- 5 = Pizza Box
-- 6 = Mini Tower
-- 7 = Tower
-- 8 = Portable
-- 9 = Laptop
-- 10 = Notebook
-- 11 = Hand Held
-- 12 = Docking Station
-- 13 = All in One
-- 14 = Sub Notebook
-- 15 = Space-Saving
-- 16 = Lunch Box
-- 17 = Main System Chassis
-- 18 = Expansion Chassis
-- 19 = SubChassis
-- 20 = Bus Expansion Chassis
-- 21 = Peripheral Chassis
-- 22 = Storage Chassis
-- 23 = Rack Mount Chassis
-- 24 = Sealed-Case PC