function Test-PowerManagerModuleExists {
    <#
    .SYNOPSIS
    Checks the manifest file to see if a module was already added
    .PARAMETER Name
    Module Name
    .PARAMETER IsDev
    Is this a module for development
    .OUTPUTS
    $true = present
    $false = Missing
    #>
    param (
        [string] $Name,
        [switch] $IsDev
    )

    $module = Import-PowerManagerManifest
    if ($IsDev) {
        foreach ($mod in $module.DevModules) {
            if ($mod.name.tolower() -eq $Name.ToLower() ) {
                return $true
            }
        }
    } else {
        foreach ($mod in $module.Modules) {
            if ($mod.name.tolower() -eq $Name.ToLower() ) {
                return $true
            }
        }
    }
    return $false
}