function New-PowerManager {
    param (
        [string] $ProjectName,
        [string] $Version = '0.1.0',
        [string] $RootModule,
        [string] $Author,
        [string] $CompanyName,
        [string] $Description,
        [string] $PowerShellRuntime = $($PSVersionTable.PSVersion),
        [switch] $Force
    )
    $ErrorActionPreference = 'Stop'

    $pmv = [PowerManagerValidation]::new()
    if ($pmv.ManifestExist() -eq $True) { Write-Warning "Found a manifest file already exists."; return $null }

    $pm = [PowerManager]::new()
    $pm.New($ProjectName, $Version, $RootModule, $Author, $CompanyName, $Description, $PowerShellRuntime, $Force)

}