function New-PowerManagerManifest {
    <#
    .SYNOPSIS
    This will create a blank manifest file
    #>
    param ()

    $pmv = [PowerManagerValidation]::new()
    if ($pmv.ManifestExist -eq $true) { Write-Warning "Manifest file already exists!"; return $null}
    

    $pmm = [PowerManagerManifest]::new()
    $schema = $pmm.NewBlankManifest

    if ($pmv.ManifestExist() -eq $false) {
        $schema | ConvertTo-Json | Out-File -FilePath ".\.pmproject"
    }

    # Capture the returned object to keep STDOUT quiet
    #$r = New-Item -Path ".\.pm\" -Name 'runtime' -ItemType Directory

    return $schema
}