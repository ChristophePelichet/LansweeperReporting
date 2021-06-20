<#

██╗      █████╗ ███╗   ██╗███████╗██╗    ██╗███████╗███████╗██████╗ ███████╗██████╗     ██████╗ ███████╗██████╗  ██████╗ ██████╗ ████████╗██╗███╗   ██╗ ██████╗ 
██║     ██╔══██╗████╗  ██║██╔════╝██║    ██║██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗    ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██║████╗  ██║██╔════╝ 
██║     ███████║██╔██╗ ██║███████╗██║ █╗ ██║█████╗  █████╗  ██████╔╝█████╗  ██████╔╝    ██████╔╝█████╗  ██████╔╝██║   ██║██████╔╝   ██║   ██║██╔██╗ ██║██║  ███╗
██║     ██╔══██║██║╚██╗██║╚════██║██║███╗██║██╔══╝  ██╔══╝  ██╔═══╝ ██╔══╝  ██╔══██╗    ██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║██╔══██╗   ██║   ██║██║╚██╗██║██║   ██║
███████╗██║  ██║██║ ╚████║███████║╚███╔███╔╝███████╗███████╗██║     ███████╗██║  ██║    ██║  ██║███████╗██║     ╚██████╔╝██║  ██║   ██║   ██║██║ ╚████║╚██████╔╝
╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
                                                                                                                                                                Version 1.0                                                                                                                                                                                    

.SYNOPSIS 
LansweeperReporting.ps1 - Scripts to create a multi-client report in .csv format based on Lansweeper software

.DESCRIPTION

Lansweeper is an application that gathers hardware and software information of computers and other devices on a computer network for management and compliance and audit purposes. 
The application also encompasses a ticket based help desk system and capabilities for software updates on target devices.

The problem I have encountered is that when you use Lansweeper in a service company that has to manage the IT assets of different companies it becomes complicated to maintain 
reports without having to edit or modify them frequently.

This is why I created a powershell script that was much easier to maintain at the query level. This script exported the data of my queries directly into a .csv file 
that I could send to anyone.

.INPUTS
N/A

.OUTPUTS

Report to .csv format . Store locally or send by email.

.CONFIGURATION

the entire configuration is done in the configuration file 
"MyScriptPath\Config\config.xml"

Show the Readme.md in the github repository for all variables explanation (https://github.com/ChristophePelichet/LansweeperReporting/blob/master/README.md)

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

## Date Format
$dateFormat = $appSettings["dateFormat"]
$todayDate	= (Get-Date -UFormat "$dateFormat")
$todayMonth = Get-Date -UFormat %B


## Debug
$debug = $appsettings["debug"]

## SQL Server
$sqlServer		= $appsettings["sqlServer"]
$sqlDB			= $appsettings["sqlDB"]
$sqlUser		= $appsettings["sqlUser"]
$sqlPassword	= $appsettings["sqlPassword"]

## Reporting 
$reportName = $appsettings["reportName"]

## Email Configuration
$emailSend = $appSettings["emailSend"]
$emailTo   = $appSettings["emailTo"]
$emailFrom = $appSettings["emailFrom"]
$emailSubj = $appSettings["emailSubj"]
$emailBody = $appSettings["emailBody"]
$emailServ = $appSettings["emailServ"]
$emailPort = $appSettings["emailPort"]

#########################################################
############### Path Concatenation ######################
#########################################################

# Query Path
$qcas   = $mySqlQuery + "query_get_clients_and scanners.sql"
$qcue   = $mySqlQuery + "query_count_users_enable.sql"
$qcde   = $mySqlQuery + "query_count_desktop.sql"
$qclp   = $mySqlQuery + "query_count_laptop.sql"
$qctc   = $mySqlQuery + "query_count_thinclient.sql"
$qctbl  = $mySqlQuery + "query_count_tablet.sql"
$qcprt  = $mySqlQuery + "query_count_printer.sql"
$qcmso  = $mySqlQuery + "query_count_msoffice.sql"
$qckasc = $mySqlQuery + "query_count_kas_client.sql"
$qcvmwi = $mySqlQuery + "query_count_vm_windows.sql"
$qcvmli = $mySqlQuery + "query_count_vm_linux.sql"
$qcvmot = $mySqlQuery + "query_count_vm_others.sql"
$qcnas	= $mySqlQuery + "query_count_nas.sql"
$qcsan	= $mySqlQuery +	"query_count_san.sql"
$qcdd	= $mySqlQuery +	"query_count_datadomain.sql"
$qctape	= $mySqlQuery +	"query_count_tape.sql"
$qcwlno	= $mySqlQuery + "query_count_windows_lic_not_oem.sql"
$qcwlo	= $mySqlQuery + "query_count_windows_lic_oem.sql"

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
'Client;Scanner;Users Enabled;Desktop;Laptop;ThinClient;Tablet;Printer;Ms Office;Kaspersky Client;VM OS Windows;VM OS Linux;VM OS Other;Nas;San;DataDomain;Tape Device;Windows Lic Not OEM;Windows Lic OEM' | Out-File -FilePath $reportPath -Append



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

	## Query for count Vm with Windows OS
	$countVmWindows = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcvmwi -Username $sqlUser -Password $sqlPassword

	## Query for count VM with Linux OS
	$countVmLinux = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcvmli -Username $sqlUser -Password $sqlPassword

	## Query for count Vm with Other OS
	$countVmOther = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcvmot -Username $sqlUser -Password $sqlPassword

	## Query for count Nas
	$countNas = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcnas -Username $sqlUser -Password $sqlPassword

	## Query for count San
	$countSan = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcsan -Username $sqlUser -Password $sqlPassword

	## Query for count Datadomain
	$countDD = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcdd -Username $sqlUser -Password $sqlPassword

	## Query for count Datadomain
	$countTape = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qctape -Username $sqlUser -Password $sqlPassword

	## Query for count not OEM Windows Licence
	$countWlno = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcwlno -Username $sqlUser -Password $sqlPassword

	## Query for count OEM Windows Licence
	$countWlo = convertQuery -ServerInstance $sqlServer -Database $sqlDB -Query $qcwlo -Username $sqlUser -Password $sqlPassword



	# Add client name and scanner to report.csv
	"$clientName;$clientScan;$countUsersEnable;$countDesktop;$countLaptop;$countThinClient;$countTablet;$countPrinter;$countMSOffice;$countKasClient;$countVmWindows;$countVmLinux;$countVmOther;$countNas;$countSan;$countDD;$countTape;$countWlno;$countWlo" | Out-File -FilePath $reportPath -Append

}

## Email reporting
if ($emailSend -eq "1") {
    Send-MailMessage -From $emailFrom -To $emailTo.split(';') -Subject "$emailSubj - $todayMonth" -Body "$emailBody" -Attachments $reportPath  -SmtpServer $emailServ -Port $emailPort
}

#######################################################
#################### End Scripts ######################
#######################################################

if ($debug -eq '1') { write-host "End Script" }
