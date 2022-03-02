function Install-PowerManager {
    <#
    .SYNOPSIS
    This installs all the dependancies for a project into your workspace.
    #>
    param (
        [switch] $IsDev,
        [switch] $Force
    )
    if ($Force) {
        Clear-PowerManager -Modules
    }

    $manifest = Import-PowerManagerManifest
    $modules = $manifest.Modules
    if ($IsDev) {
        $modules += $manifest.DevModules
    }

    $cachePath = Get-PowerManagerConfig -ModuleCache
    foreach ($module in $modules) {
        $expectedPath = Join-Path -Path $cachePath -ChildPath $module.Name
        $expectedPath = Join-Path -Path $expectedPath -ChildPath $module.Version
        $moduleNameAndVersion = "$($module.Name):$($module.Version)"
        if ((Test-Path -Path $expectedPath ) -eq $true) {
            Write-Host "$moduleNameAndVersion = present"
        } else {
            Write-Host "$moduleNameAndVersion = downloading"
            Save-Module `
                -Name $module.Name `
                -RequiredVersion $module.Version `
                -Path $cachePath
        }
    }
}