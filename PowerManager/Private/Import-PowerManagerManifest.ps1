function Import-PowerManagerManifest {
    <#
    .SYNOPSIS
    This imports the Manifest file into memory and returns it as a Hashtable
    #>
    param ()
    
    if ((Test-PowerManager -ManifestExists) -eq $false) { throw "Unable to import the manifest file as it does not exist." }
    $res = Get-Content -Path (Get-PowerManagerConfig -Manifest) -Raw | ConvertFrom-Json
    if ($null -eq $res) { throw "The file was imported from disk, but had no content." }
    return $res
}