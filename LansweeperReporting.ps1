<#

Ascii
https://www.patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something%20

Version 1.0                                                                                                                                                                                    

.SYNOPSIS 
xxxx.ps1 - Description

.DESCRIPTION


.INPUTS
N/A

.OUTPUTS
N/A

.CONFIGURATION
N/A

.LINK
N/A

.EXAMPLE


.NOTES
Written by: Christophe Pelichet (c.pelichet@gmail.com)
 
Find me on: 
 
* LinkedIn:     https://linkedin.com/in/christophepelichet
* Github:       https://github.com/ChristophePelichet
 
Change Log 
V1.00 - 03/10/2020 - Initial version
#>

#Necessite module SQLServer (Install-Module -Name SqlServer)

Import-Module SqlServer


########################################################
######################## Path ##########################
########################################################

$myScriptPath    	= split-path -parent $MyInvocation.MyCommand.Definition
$myFunctionPath  	= $myScriptPath + "\Functions"
$myConfPath      	= $myScriptPath + "\Configuration\config.xml"
$mySqlQuery			= $myScriptPath + "\Query\"
$myReportPath		= $myScriptPath + "\Reporting"



########################################################
###################### Functions #######################
########################################################

# Load Configuration 

$MyLoadConf = $myFunctionPath +"\"+ "Get_LoadConfig.ps1"
	. $MyLoadConf
	Get_LoadConfig -path $myConfPath


#######################################################
###################### Variables ######################
#######################################################

$todayDate = get-date -UFormat %d_%m_%Y

## Debug
$debug = $appsettings["debug"]

## SQL Server
$sqlServer		= $appsettings["sqlServer"]
$sqlDB			= $appsettings["sqlDB"]
$sqlUser		= $appsettings["sqlUser"]
$sqlPassword	= $appsettings["sqlPassword"]

## Reporting 
$reportName = $appsettings["reportName"]

#########################################################
############### Path Concatenation ######################
#########################################################

# Query get client and scanner server
$qcas   = $mySqlQuery + "query_get_clients _and scanners.sql"
$qcue   = $mySqlQuery + "query_count_users_enable.sql"
$qcde   = $mySqlQuery + "query_count_desktop.sql"
$qclp   = $mySqlQuery + "query_count_laptop.sql"
$qctc   = $mySqlQuery + "query_count_thinclient.sql"
$qctbl  = $mySqlQuery + "query_count_tablet.sql"
$qcprt  = $mySqlQuery + "query_count_printer.sql"
$qlmso  = $mySqlQuery + "query_count_msoffice.sql"
$qlkasc = $mySqlQuery + "query_count_kas_client.sql"

# Reporting Name
$reportName = $reportName +"_"+ $todayDate +".csv"
$reportPath = $myReportPath +"\"+ $reportName

#######################################################
################### Start Scripts #####################
#######################################################


## Del report for code
Remove-Item $reportPath
## Debug
if ($debug -eq '1') { write-host "Start Script" }

## Reporting Header
'sep=;' | Out-File -FilePath $reportPath
'Client;Scanner;Users Enabled;Desktop;Laptop;ThinClient;Tablet;Printer;Ms Office;Kaspersky Client' | Out-File -FilePath $reportPath -Append



## Query for get client and scanner server.
$qcasResult = Invoke-Sqlcmd -InputFile $qcas -ServerInstance $sqlServer -Database $sqlDB -Username $sqlUser -Password $sqlPassword

foreach ( $qr in $qcasResult) {

	# Set client name and scanner
	$clientName	= $qr.Item(0)
	$clientScan	= $qr.item(1)

	## Query for count how many user enable by scanner.
	$qcueModified = (Get-content $qcue) -replace 'scannerToChange',$clientScan | Out-String
	$qcueResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $qcueModified -Username $sqlUser -Password $sqlPassword 
	$clientUsersEnable = $qcueResult.ITEM(0)

	## Query for count Desktop 
	$qcdeModified = (Get-content $qcde) -replace 'scannerToChange',$clientScan | Out-String
	$qcueResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $qcdeModified -Username $sqlUser -Password $sqlPassword 
	$clientCountDesktop = $qcueResult.ITEM(0)

	## Query for count Laptop 
	$qclpModified = (Get-content $qclp) -replace 'scannerToChange',$clientScan | Out-String
	$qclpResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $qclpModified -Username $sqlUser -Password $sqlPassword 
	$clientCountLaptop = $qclpResult.ITEM(0)

	## Query for count ThinClient
	$qctcModified = (Get-content $qctc) -replace 'scannerToChange',$clientScan | Out-String
	$qctcResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $qctcModified -Username $sqlUser -Password $sqlPassword 
	$clientCountThinClient = $qctcResult.ITEM(0)

	## Query for count Tablet
	$qctblModified = (Get-content $qctbl) -replace 'scannerToChange',$clientScan | Out-String
	$qctblResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $qctblModified -Username $sqlUser -Password $sqlPassword 
	$clientCountTablet = $qctblResult.ITEM(0)

	## Query for count Printer
	$qcprtModified = (Get-content $qcprt) -replace 'scannerToChange',$clientScan | Out-String
	$qcprtResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $qcprtModified -Username $sqlUser -Password $sqlPassword 
	$clientCountPrinter = $qcprtResult.ITEM(0)

	## Query for count MS Office STD and Pro
	$qlmsoModified = (Get-content $qlmso) -replace 'scannerToChange',$clientScan | Out-String
	$qlmsoResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $qlmsoModified -Username $sqlUser -Password $sqlPassword 
	$licenseMSOffice = $qlmsoResult.ITEM(0)

	## Query for count Kaspersky Client Licence
	$qlkascModified = (Get-content $qlkasc) -replace 'scannerToChange',$clientScan | Out-String
	$qlmsoResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $qlkascModified -Username $sqlUser -Password $sqlPassword 
	$licenseKasClient = $qlkascResult.ITEM(0)


	


	# Add client name and scanner to report.csv
	"$clientName;$clientScan;$clientUsersEnable;$clientCountDesktop;$clientCountLaptop;$clientCountThinClient;$clientCountTablet;$clientCountPrinter;$licenseMSOffice;$licenseKasClient" | Out-File -FilePath $reportPath -Append





}

#######################################################
#################### Ens Scripts ######################
#######################################################

if ($debug -eq '1') { write-host "End Script" }
