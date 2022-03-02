function Get-PowerManagerConfig {
    param (
        [switch] $ModuleCache,
        [switch] $Manifest
    )
    if ($ModuleCache) { return (Join-Path -Path $PWD -ChildPath ".pm" -AdditionalChildPath @('modules')) }
    if ($Manifest) { return (Join-Path -Path $PWD -ChildPath ".pmproject") }
}