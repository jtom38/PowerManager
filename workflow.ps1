Import-Module ./PowerManager -Force

try {
    New-PowerManager
}
catch {

}
try { New-PowerManagerModule -Name "pester" -isDev }
catch {}

Initialize-PowerManager