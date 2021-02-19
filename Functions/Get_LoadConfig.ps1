Function Get_LoadConfig () 
{
<#

.SYNOPSIS 
	Chargement de la configuration

.DESCRIPTION
	

.PARAMETER 

.INPUTS


.OUTPUTS


.NOTES
	Version:     1.0
	Auteur:      Christophe Pelichet / iXion Services S.A / Christophe.Pelichet@ixion.ch
	Date:        08.05.2015
	Information: Version initiale


.EXAMPLE
	Get_LoadConfig -path <config_xml_path>


#>
	Param 
	(
		[Parameter(Mandatory=$true)][string]$Path
	)


	$global:appSettings = @{}
	$config = [xml](get-content $path)

		foreach ($addNode in $config.configuration.appsettings.add) {
			if ($addNode.Value.Contains(',')) 
			{
			# Array case
				$value = $addNode.Value.Split(',')
				for ($i = 0; $i -lt $value.length; $i++) 
				{ 
				$value[$i] = $value[$i].Trim() 
				}
			}
			else 
			{
			# Scalar case
				$value = $addNode.Value
			}
				$global:appSettings[$addNode.Key] = $value
		}
}