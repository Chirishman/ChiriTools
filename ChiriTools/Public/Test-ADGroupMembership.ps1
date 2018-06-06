function Test-ADGroupMembership {
    Param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('UserName','UN')]
        [String]
        $User,
        [Parameter(
            Position=1,
            Mandatory=$true,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]$TargetGroup
    )
    
    $Groups = Get-ADGroupMembership -User $User
    
    $TargetGroup -in $Groups
}