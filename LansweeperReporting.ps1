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

$myLoadConf = $myFunctionPath +"\"+ "Get_LoadConfig.ps1"
	. $myLoadConf
	Get_LoadConfig -path $myConfPath


# Convert Query
$convQuery  = $myFunctionPath +"\"+ "convertQuery.ps1"
	. $convQuery




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
$qcas   = $mySqlQuery + "query_get_clients_and scanners.sql"
$qcue   = $mySqlQuery + "query_count_users_enable.sql"
$qcde   = $mySqlQuery + "query_count_desktop.sql"
$qclp   = $mySqlQuery + "query_count_laptop.sql"
$qctc   = $mySqlQuery + "query_count_thinclient.sql"
$qctbl  = $mySqlQuery + "query_count_tablet.sql"
$qcprt  = $mySqlQuery + "query_count_printer.sql"
$qcmso  = $mySqlQuery + "query_count_msoffice.sql"
$qckasc = $mySqlQuery + "query_count_kas_client.sql"

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
	$countUsersEnable = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcue -Username $sqlUser -Password $sqlPassword

	## Query for count Desktop 
	$countDesktop = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcde -Username $sqlUser -Password $sqlPassword

	## Query for count Laptop 
	$countLaptop = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qclp -Username $sqlUser -Password $sqlPassword

	## Query for count ThinClient
	$countThinClient = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qctc -Username $sqlUser -Password $sqlPassword

	## Query for count Tablet
	$countTablet = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qctbl -Username $sqlUser -Password $sqlPassword

	## Query for count Printer
	$countPrinter = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcprt -Username $sqlUser -Password $sqlPassword

	## Query for count MS Office STD and Pro
	$countMSOffice = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcmso -Username $sqlUser -Password $sqlPassword

	## Query for count Kaspersky Client Licence
	$countKasClient = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qckasc -Username $sqlUser -Password $sqlPassword



	


	# Add client name and scanner to report.csv
	"$clientName;$clientScan;$countUsersEnable;$countDesktop;$countLaptop;$countThinClient;$countTablet;$countPrinter;$countMSOffice;$countKasClient" | Out-File -FilePath $reportPath -Append





}

#######################################################
#################### Ens Scripts ######################
#######################################################

if ($debug -eq '1') { write-host "End Script" }
