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

    $pmv = [PowerManagerValidation]::new()
    if ($pmv.ManifestExist() -eq $True) { Write-Error "Found a manifest file already exists." }

    $pm = [PowerManager]::new()
    $pm.New($ProjectName, $Version, $RootModule, $Author, $CompanyName, $Description, $PowerShellRuntime)

    # Update .gitignore if its present
    #$gitIgnore = Get-ChildItem -Path . -Filter './.gitignore'
    #$ignoreContent = Get-Content $gitIgnore.FullName
    #if ($ignoreContent -like '.pm/*')
    #Add-Content -Path $gitIgnore.FullName -Value ".pm/*"
}