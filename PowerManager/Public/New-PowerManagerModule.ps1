function New-PowerManagerModule {
    <#
    .SYNOPSIS
    Adds a new module to the PowerManager.

    .EXAMPLE
    New-
    #>
    param (
        [Parameter(Mandatory)]
        [string] $Name,

        [string] $Version,
        [switch] $isDev
    )
    $ErrorActionPreference = 'Stop'
    if ((Test-PowerManager -ManifestExists) -eq $false) { throw "Unable to find .pmproject in the directory."; return $null }
    if ((Test-PowerManager -ModulesDirectoryExists) -eq $false) { throw "Unable to find the modules folder."; return $null }
    if ((Test-PowerManager -ModuleExists $Name) -eq $true) { Write-Warning "Unable to add '$Name' because its already in the manifest."; return $null }

    $modulesPath = Get-PowerManagerConfig -PathModulesCache
    $manifestPath = Get-PowerManagerConfig -Manifest

    $manifest = Import-PowerManagerManifest    
    
    Write-Host "Checking the repositories for '$Name'"
    $foundResults = Find-Module -Name $Name
    Write-Host "Found '$($foundResults.Name):$($foundResults.Version)'"
    $schema = @{
        Name = $foundResults.Name
        Version = $foundResults.Version
        Repository = $foundResults.Repository
        Description = $foundResults.Description
        IsDependency = $false
    }

    if ($isDev) {
        $manifest.DevModules += $schema
    } else {
        $manifest.Modules += $schema
    }
    # Gets the directories on disk before we add the new module to track dependancies
    $modulesBeforeInstall = Get-ChildItem -Path $modulesPath
    
    # doing this conversion to keep the format the same for later
    $manifest = ConvertTo-Json $manifest -Depth 10
    $manifest = ConvertFrom-Json $manifest

    # Save the requested module along with any dependancies 
    Save-Module -Name $Name -Path $modulesPath  
    
    # Check after the install to see if we got any unexpected modules
    $modulesAfterInstall = Get-ChildItem -Path $modulesPath
    $unexpectedModules = ($modulesAfterInstall.Length) - ($modulesBeforeInstall.Length) - 1
    if ( $unexpectedModules -eq 0 ) { 
        $manifest | ConvertTo-Json | Out-File -FilePath $manifestPath
        return $null 
    }

    if ($isDev) {
        Find-PowerManagerModuleDependencies `
            -Manifest $manifest `
            -IsDev
    }
    Find-PowerManagerModuleDependencies `
        -Manifest $manifest `
}