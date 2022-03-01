function Get-PowerManagerConfig {
    param (
        [switch] $ModuleCache,
        [switch] $Manifest
    )
    if ($ModuleCache) { return "$PWD/.pm/modules" }
    if ($Manifest) { return "$PWD/.pmproject" }
}