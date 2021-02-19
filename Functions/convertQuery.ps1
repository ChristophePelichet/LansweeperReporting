Function convertQuery {

<#

.SYNOPSIS 
	

.DESCRIPTION
	 
	
	
.NOTES
	Version:     1.0
	Auteur:      Christophe Pelichet / c.pelichet@gmail.com
	Date:        02.19.2021
	Information: Initial Version

.EXAMPLE

	convertQuery -ServerInstance <my_db_server> -Database <my_db> -Query <my_query> -Username <my_db_user> -Password <my_db_password>

#>



Param (
[string]$ServerInstance,
[string]$Database,
[string]$Query,
[string]$Username,
[string]$Password
)

$queryModified = (Get-content $Query) -replace 'scannerToChange',$clientScan | Out-String
$queryResult = Invoke-Sqlcmd -ServerInstance $sqlServer -Database $sqlDB -Query $queryModified -Username $sqlUser -Password $sqlPassword 

return $queryResult.ITEM(0)







}