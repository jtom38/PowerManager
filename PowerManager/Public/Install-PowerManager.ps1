function Install-PowerManager {
    <#
    .SYNOPSIS
    This installs all the dependancies for a project into your workspace.
    #>
    param (
        [switch] $IsDev,
        [switch] $Force
    )

    $pm = [PowerManager]::new()

    if ($Force) {
        Clear-PowerManager -Modules
    }

}