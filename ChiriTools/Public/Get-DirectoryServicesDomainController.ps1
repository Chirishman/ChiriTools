function Get-DirectoryServicesDomainController {
	[CmdletBinding()]
    Param(
		[Parameter(
			Mandatory = $false,
            Position = 0
		)]
            [String]$Domain = (Get-CimInstance Win32_ComputerSystem | select -ExpandProperty Domain)
	)
	# Get a list of domain controllers
	(Get-DirectoryServicesDomain -Domain $Domain).DomainControllers
}