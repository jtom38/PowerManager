function Install-PowerManager {
    <#
    .SYNOPSIS
    This installs all the dependancies for a project into your workspace.
    #>
    param (
        [switch] $IsDev,
        [switch] $Force
    )
    $ErrorActionPreference = "SilentlyContinue"
    #$pm = [PowerManager]::new()
    $pmm = [PowerManagerModules]::new()

    # Add Repos

    # Download Modules
    if ($Force) { Clear-PowerManager -Modules }
    $pmm.Install($IsDev)
}