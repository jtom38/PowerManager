function Clear-PowerManager {
    <#
    .SYNOPSIS
    This will clear out the PowerManager cache.  
    Use this if you are experiencing odd behaviour with your modules and are looking to reinstall.
    #>
    param (
        [switch] $Modules
        #[switch] $Cache
    )
    if ($Modules) {
        $Path = Get-PowerManagerConfig -PathModulesCache
        Remove-Item -Path $Path -Force -Recurse
        $r = New-Item -Path $Path -ItemType Directory
    }
}