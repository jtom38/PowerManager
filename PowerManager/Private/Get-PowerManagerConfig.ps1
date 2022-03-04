function Get-PowerManagerConfig {
    param (
        [switch] $PathModulesCache,
        [switch] $Manifest,
        [switch] $LockfilePath
    )
    if ($PathModulesCache) { return (Join-Path -Path $PWD -ChildPath ".pm" -AdditionalChildPath @('modules')) }
    if ($Manifest) { return (Join-Path -Path $PWD -ChildPath ".pmproject") }
    if ($LockfilePath) { return (Join-Path -Path $PWD -ChildPath '.pmproject.lock') }
}