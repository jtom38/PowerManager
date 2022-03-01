function Test-PowerManagerManifestFile {
    <#
    .SYNOPSIS
    This will test to make if the manifest file exists on disk.
    #>
    param ()
    $res = Test-Path -Path ".\.pmproject"
    return $res
}