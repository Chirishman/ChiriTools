function Test-ADCredential {
    Param(
        [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline = $true)]
        [pscredential]$Credential
    )
    
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
	$AuthLookup = @{
		$true = 'machine'
		$false = 'domain'
	}

    $DS = [System.DirectoryServices.AccountManagement.PrincipalContext]::new($AuthLookup[($env:USERDOMAIN -eq $env:COMPUTERNAME)])
    $Credential.GetNetworkCredential() | % {
        $DS.ValidateCredentials($_.UserName, $_.Password)
    }
}