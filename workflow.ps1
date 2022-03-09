$envModulePath = Get-ChildItem -Path Env:/PSModulePath
$modulePaths = $envModulePath.Value.Split(':')
$modulePath = $modulePaths[0]
Copy-Item -Path PowerManager -Destination $modulePath -Recurse -Force
$ModulePathPowerMonitor = Join-Path -Path $modulePath -ChildPath "PowerManager"


Import-Module ./PowerManager -Force

#try {
#    New-PowerManager `
#        -ProjectName "PowerManager" `
#        -Description "Package Manager for PowerShell" `
#        -RootModule "PowerManager.psm1" `
#        -Author "Team PowerManager" `
#        -Version "0.1.0" `
#        -CompanyName "Team PowerManager" -Force
#} catch {}
#
#try { New-PowerManagerModule -Name "pester" -isDev } catch {}
#try { New-PowerManagerModule -Name "Az.Storage" } catch {}
#
#Clear-PowerManager -Modules

Install-PowerManager -IsDev

Invoke-PowerManager