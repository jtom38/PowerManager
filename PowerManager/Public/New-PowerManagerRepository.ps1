function New-PowerManagerRepository {
    <#
    .SYNOPSIS
    This adds a entry for a PowerShell Module Repository to your project file.

    .EXAMPLE
    New-PowerManagerRepository `
        -Name "InternalRepository" `
        -Url "https://dev.azure.com"
    #>
    param (
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Url,

        [Parameter(Mandatory)]
        [ValidateSet(
            "Untrusted",
            "Trusted"
        )]
        [string] $Policy
    )

    Register-PSRepository
}