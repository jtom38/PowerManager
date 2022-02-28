Import-Module .\PowerManager -Force
$private = Get-ChildItem -Path ./PowerManager/Private

foreach($func in $private) {
    . $private.FullName
}

Invoke-Pester 