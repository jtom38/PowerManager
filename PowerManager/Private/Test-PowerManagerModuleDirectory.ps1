function Test-PowerManagerModuleDirectory {
    <#
    .SYNOPSIS
    This tests to see if the modules directory was created.
    #>
    param ()
    $res = Test-Path -Path ".\.pm\modules"    
    return $res
}