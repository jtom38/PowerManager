function New-PowerManagerRuntime {
    param (
        [Parameter(Mandatory)]
        [ValidateSet(
            "latest",
            "7.2.1",
            "7.2.0"
        )]
        [string] $RuntimeVersion
    )
    $ErrorActionPreference = 'Stop'
    throw "Not enabled yet."
    
    $url = "https://github.com/PowerShell/PowerShell/releases/download/v7.2.1/powershell-7.2.1-osx-x64.tar.gz"
    $urlSplit = $url.Split('/')
    $fileName = $urlSplit[($urlSplit.Length - 1)]
    # needs to be able to parse for the URL to download.
    # Either a local index or external
    Write-Host "Please wait as PowerManager downloads runtime $RuntimeVersion..."
    Invoke-WebRequest -Uri $url -OutFile $fileName

}