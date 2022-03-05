function New-PowerManagerModule {
    <#
    .SYNOPSIS
    Adds a new module to the PowerManager.

    .PARAMETER Name
    Defines the name of the module you are looking to add

    .PARAMETER Global
    This installs a module into your PowerShell global space and is not tracked by PowerManager.

    .PARAMETER Version
    Lets you define the version of the module you are looking to install.  This uses the exact version number.

    .PARAMETER IsDev
    This flags the module as a development module so it can become optional if the user is not developing the module.

    #>
    param (
        [Parameter(Mandatory)]
        [string] $Name,

        [string] $Version,
        [switch] $isDev,
        [switch] $Global
    )
    [PowerManagerModules] $pmm = [PowerManagerModules]::new()

    # Run validation
    if ($pmm._validation.ManifestExist() -eq $false) { throw "Unable to find .pmproject in the directory." }
    if ($pmm._validation.ModulesDirectoryExists() -eq $false) { throw "Unable to find the modules folder." }
    if ($pmm.DoesModuleExist($Name) -eq $true) { Write-Warning "Unable to add '$Name' because its already in the manifest."; return $null }

    if ($Global) {
        $pmm.InstallGlobalModule($Name, $Version)
    } else {
        # Add Module
        $pmm.NewModule($Name, $Version, $isDev)
    }
}