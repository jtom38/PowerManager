function New-PowerManagerModule {
    [Alias('')]
    param (
        [Parameter(Mandatory)]
        [string] $Name
    )

    if ((Test-Path -Path '.\.pm\modules') -eq $false) {
        throw "Unable to find he modules folder.  Did you '"
    }

    Save-Module -Name $Name
}