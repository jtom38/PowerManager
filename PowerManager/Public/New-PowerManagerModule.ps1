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
    if ((Test-PowerManagerManifestFile) -eq $false) { throw "Unable to find .pmproject in the directory." }
    if ((Test-PowerManagerModuleDirectory) -eq $false) { throw "Unable to find the modules folder." }
    if ($isDev) {
        if ((Test-PowerManagerModuleExists -Name $Name -isDev ) -eq $true) { 
            throw "Unable to add the package as it already exists in the manifest."
        }
    } else {
        if ((Test-PowerManagerModuleExists -Name $Name ) -eq $true) { 
            throw "Unable to add the package as it already exists in the manifest."
        }
    }
    if ((Test-PowerManagerModuleExists) -eq $true) { throw "Unable to add the package as it already exists in the manifest."}

    $manifest = Import-PowerManagerManifest    
    
    Write-Host "Checking the repositories for '$Name'"
    $foundResults = Find-Module -Name $Name
    $schema = @{
        Name = $foundResults.Name
        Version = $foundResults.Version
        Repository = $foundResults.Repository
        Description = $foundResults.Description
    }

    if ($isDev) {
        $manifest.DevModules += $schema
    } else {
        $manifest.Modules += $schema
    }

    $manifest | ConvertTo-Json | Out-File "$PWD\.pmproject"

    Save-Module -Name $Name -Path "$PWD\.pm\modules"

}