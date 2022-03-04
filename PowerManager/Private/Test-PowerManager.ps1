function Test-PowerManager {
    <#
    .SYNOPSIS
    General purpose test function.  
    .PARAMETER ModuleExists
    Checks the manifest to see if the module was already added to the mainfest.
    Returns a bool
    .PARAMETER ManifestExsits
    Checks the known location for the manifest file.
    Returns bool
    .PARAMETER ModulesDirectoryExists
    Checks to see if the Modules directory exists in the cache folder.
    Returns bool
    #>
    param (
        [switch] $ManifestExists,
        [switch] $ModulesDirectoryExists,
        [string] $ModuleExists
    )

    if ($ManifestExists) {
        $res = Test-Path -Path (Get-PowerManagerConfig -Manifest)
        return $res
    }

    if ($ModulesDirectoryExists) {
        $res = Test-Path -Path (Get-PowerManagerConfig -PathModulesCache)
        return $res
    }

    if ($ModuleExists) {
        $manifest = Import-PowerManagerManifest
        foreach ($module in $manifest.Modules + $manifest.DevModules) {
            if ($module.Name -eq $ModuleExists) { 
                return $true 
            }
        }
        return $false
    }
}