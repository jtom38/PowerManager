function Import-PowerManagerManifest {
    <#
    .SYNOPSIS
    This imports the Manifest file into memory and returns it as a Hashtable
    #>
    param ()
    
    if ((Test-PowerManagerManifestFile) -eq $false) {
        throw "Unable to import the manifest file as it does not exist."
    }

    $res = Get-Content -Path ".\.pmproject" -Raw | ConvertFrom-Json
    if ($null -eq $res) {
        throw 
    }
    return $res
}