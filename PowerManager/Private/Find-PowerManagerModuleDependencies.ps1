function Find-PowerManagerModuleDependencies {
    <#
    .SYNOPSIS
    This function checks to find 
    #>
    param (
        [object] $Manifest,
        [switch] $IsDev
    )

    $modulesPath = Get-PowerManagerConfig -PathModulesCache
    $manifestPath = Get-PowerManagerConfig -Manifest

    # we got an extra module, we need to know what ones we got
    $modules = $manifest.Modules + $manifest.DevModules
    $installedModules = Get-ChildItem -Path $modulesPath
    foreach ($installed in $installedModules) {
        $exists = $modules.Name -contains $installed.Name
        if ($exists -eq $true) { continue }
        
        # Get the module version installed 
        $childpath = Join-Path -Path $modulesPath -ChildPath $installed.Name
        $childVersion = Get-ChildItem -Path $childpath

        Write-Host "$($installed.Name):$($childVersion.Name) was installed as a dependency."
        Write-Host "Getting details on it and adding it to the manifest."
        $childModule = Find-Module `
            -Name $installed.Name `
            -RequiredVersion $childVersion.Name
        $schema = @{
            Name = $childModule.Name
            Version = $childModule.Version
            Repository = $childModule.Repository
            Description = $childModule.Description
            IsDependency = $true
        }
        if ($IsDev) {
            $manifest.DevModules += $schema
        } else {
            $manifest.Modules += $schema
        }
    }
    
    $manifest | ConvertTo-Json | Out-File -FilePath $manifestPath
}