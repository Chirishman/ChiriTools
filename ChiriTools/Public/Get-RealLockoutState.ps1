function Get-RealLockoutState {
        [CmdletBinding()]
        Param (
                [Parameter(Mandatory = $true,
                                   Position = 0)]
                [String]$SAMAccountName,

                [Parameter(Mandatory = $false,
                                   Position = 1)]
                [String]$Domain = (Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty Domain)
        )

        # Pull out all of the dc's in the domain.
        [array]$dcList = Get-DirectoryServicesDomainController -Domain $Domain | Select-Object -ExpandProperty Name
        Write-Verbose -Message ('[GetRealLogonDate] Found {0} DCs in {1}' -f $dcList.count, $Domain)

        # Define a script block which we'll use to feed into a job.
        $queryBlock = [scriptblock]::Create("
            #Initialize Record
            `$ThisRecord = [ordered]@{
                User = [string]'$SAMAccountName'.ToLower();
                'Lockout Time' = `$null;
                'Domain Controller' = [string]`$_.ToLower();
            }
            # Search the individual domain controller for the user in question
            `$searcher = new-object System.DirectoryServices.DirectorySearcher([ADSI]""LDAP://`$_"")
            `$searcher.filter = '(&(objectClass=User)(SAMAccountName=$SAMAccountName))'
            #[void]`$searcher.PropertiesToLoad.Add('lockouttime')
            try {
                `$ThisRecord.'Lockout Time' = [datetime]::FromFileTime([int64]::Parse(`$searcher.FindOne().Properties.lockouttime))
            }
            catch {
                return `$null
            }
            if (`$ThisRecord.'Lockout Time' -eq [datetime]::FromFileTime(0)){
                Write-Verbose -Message ""User not locked out on: `$_""
                `$ThisRecord.'Lockout Time' = `$null
            }
            New-Object -TypeName PSObject -Property `$ThisRecord
        ")

        # Go through each DC in the list and query for the user account.

        Write-Verbose -Message "`r`n$($(($QueryResult = ($dcList | Invoke-Parallel -ScriptBlock $queryBlock -ImportVariables) | Sort-Object -Property 'Domain Controller')) | Format-Table -AutoSize | Out-String)"

        $QueryResult | Sort-Object 'Lockout Time' -Descending | Select-Object -First 1
}