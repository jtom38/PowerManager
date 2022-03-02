Import-Module .\PowerManager -Force
$privatePath = Join-Path -Path $PWD -ChildPath '/PowerManager/Private'
$private = Get-ChildItem -Path $privatePath

# Import the private functions so tests can ran against them.
foreach($func in $private) {
    . $func.FullName
}

# Save the the pmproect file if one exits
$manifestPathNormal = Join-Path -Path $PWD -ChildPath ".pmproject"
$manifestPathTemp = Join-Path -Path $PWD -ChildPath ".pmproject-temp"

$manifestExists = Test-Path -Path $manifestPathNormal
if ($manifestExists -eq $true) { Move-Item -Path $manifestPathNormal -Destination $manifestPathTemp }

# run the tests!
Invoke-Pester 

# Cleanup
Remove-item -Path $manifestPathNormal -Force

if ($manifestExists -eq $true) { Move-Item -Path $manifestPathTemp -Destination $manifestPathNormal }