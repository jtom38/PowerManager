function New-PowerManager {
    param (
        [string] $ProjectName,
        [string] $Version = '0.1.0',
        [string] $RootModule,
        [string] $Author,
        [string] $CompanyName,
        [string] $Description,
        [string] $PowerShellRuntime = $($PSVersionTable.PSVersion)
    )
    $ErrorActionPreference = 'Stop'
    if ((Test-PowerManager -ManifestExists) -eq $True) { Write-Error "Found a manifest file already exists." }
    $manifest = New-PowerManagerManifest
    
    if (-not $Name) { $ProjectName = Read-Host "Enter the name of your project" }
    if (-not $RootModule) { $RootModule = Read-Host "Enter the name of the PowerShell Module File (psm1) if this is for a module (Enter $none if this is a script)" }
    if (-not $Author) { $Author = Read-Host "Enter the name of the author" }
    if (-not $CompanyName) { $CompanyName = Read-Host "Enter the company/team name:" }
    if (-not $Description) { $Description = Read-Host "Enter the projects description" }
    
    Write-Host "Project Name: $ProjectName"
    Write-Host "Version = $Version"
    Write-Host "RootModule: $RootModule"
    Write-Host "Author: $Author"
    Write-Host "Company/Team Name: $CompanyName"
    Write-Host "Description: $Description"
    Write-Host 'PowerShell Runtime: $PowerShellRuntime'

    $accept = Read-Host "Please confirm the following values: (y/n)"
    switch ($accept.ToLower()) {
        'y' {
            Write-Host "Generating .pmproject"
        }
        'n' {
            Write-Host "Aborted by user"
            exit
        }
        default {
            Write-Host "Invalid entry."
            exit
        }
    }

    $manifest.Project.Name = $ProjectName
    $manifest.Project.Version = $Version
    $manifest.Project.RootModule = $RootModule
    $manifest.Project.Author = $Author
    $manifest.Project.CompanyName = $CompanyName
    $manifest.Project.Description = $Description
    $manifest.Project.PowerShellRuntime = $PowerShellRuntime

    $manifest | ConvertTo-Json | Out-File ".\.pmproject"

    if ((Test-Path -Path ".\.pm\modules") -eq $true) {
        $r = New-Item -Path ".\.pm\" -Name 'modules' -ItemType Directory
    }

    # Update .gitignore if its present
    #$gitIgnore = Get-ChildItem -Path . -Filter './.gitignore'
    #$ignoreContent = Get-Content $gitIgnore.FullName
    #if ($ignoreContent -like '.pm/*')
    #Add-Content -Path $gitIgnore.FullName -Value ".pm/*"
}