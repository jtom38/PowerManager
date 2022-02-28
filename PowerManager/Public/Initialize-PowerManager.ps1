function Initialize-PowerManager {
    <#
    .SYNOPSIS
    This will check to ensure your local instance is in sync with the manifest.
    Project modules will be loaded into your session.
    #>
    # Alias("ipm")]
    param (

    )
    $ErrorActionPreference = 'Stop'
    if ((Test-PowerManagerManifestFile) -eq $false ) { throw "Unable to find the manifest file." }
    if ((Test-PowerManagerModuleDirectory) -eq $false) { throw "Unable to find the modules directory" }

    $manifest = Import-PowerManagerManifest
    foreach ($module in $manifest.Modules) {
        $activeModule = Get-Module -Name $Module.Name
        if (!$null -eq $activeModule) {
            Remove-Module -Name $module.Name
        }
        $name = $module.Name
        Import-Module "./.pm/modules/$name"
    }
    
}