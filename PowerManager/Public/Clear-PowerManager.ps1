function Clear-PowerManager {
    <#
    .SYNOPSIS
    This will clear out the PowerManager cache.  Use this if you are experiencing odd behaviour with your modules.
    #>
    param (
        [switch] $Modules
    )
    if ($Modules) {
        $Path = "$PWD/.pm/modules"
        Remove-Item -Path $Path -Force
        $r = New-Item -Path $Path
    }
}