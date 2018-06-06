function Get-DirectoryServicesDomain {
	[CmdletBinding()]
    Param(
		[Parameter(
			Mandatory = $false,
            Position = 0
		)]
            [String]$Domain = (Get-CimInstance Win32_ComputerSystem | select -ExpandProperty Domain)
	)

	# Build a domain object

    try {
        [DirectoryServices.ActiveDirectory.Domain]::GetDomain(
			(
				New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Domain', $Domain)
			)
		)
    }
    catch {
        throw ('Unable to connect to {0}: {1}' -f $Domain, $_.exception.message)
    }
}