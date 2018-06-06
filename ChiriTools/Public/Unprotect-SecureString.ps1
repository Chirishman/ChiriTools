function Unprotect-SecureString {
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        $SecureString
    )
    [System.Runtime.InteropServices.marshal]::PtrToStringAuto([System.Runtime.InteropServices.marshal]::SecureStringToBSTR($SecureString))
}