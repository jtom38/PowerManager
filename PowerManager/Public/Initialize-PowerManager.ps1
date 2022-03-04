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
    if ((Test-PowerManager -ManifestExists) -eq $false ) { throw "Unable to find the manifest file." }
    if ((Test-PowerManager -ModulesDirectoryExists) -eq $false) { throw "Unable to find the modules directory" }

    #$manifest = Import-PowerManagerManifest
    $modules = Get-ChildItem -Path (Get-PowerManagerConfig -PathModulesCache) -Filter *
    foreach ($module in $modules) {
        $activeModule = Get-Module -Name $Module.Name
        if (!$null -eq $activeModule) {
            Remove-Module -Name $module.Name
        }
        $name = $module.Name
        try {
            Import-Module "./.pm/modules/$name" -Force
        }
        catch {
            Write-Error "Failed to import $"
        }
    }
    
}