
BeforeAll {}

Describe 'Test-PowerManager'{
    It "-ManifestExists Should return false if the file is not present" {
        #$path = ".\.pmproject"
        $manifestPath = Get-PowerManagerConfig -Manifest
        $manifestExists = Test-Path $manifestPath
        if ($manifestExists -eq $true ) { Remove-Item $manifestPath -Force }
        Test-PowerManager -ManifestExists | Should be $false
    }

    It "-ManifestExists Should return true when file is present" {
        $path = Get-PowerManagerConfig -Manifest
        New-Item -Path $path
        Test-PowerManager -ManifestExists | Should be $true
    }

    It "-ModulesDirectoryExists should return false when the directory is missing" {
        $path = Get-PowerManagerConfig -PathModulesCache
        $existingDir = Test-Path -Path $path
        if ($existingDir -eq $true) { Move-Item -Path $path -Destination "$path.old" }
        $res = Test-PowerManager -ModulesDirectoryExists
        if ($existingDir -eq $true) { Move-Item -Path "$path.old" -Destination $path }
        $res | Should be $false
    }

    It "-ModulesDirectoryExists should return true when the directory is present" {
        $path = Get-PowerManagerConfig -PathModulesCache
        $existingDir = Test-Path -Path $path
        if ($existingDir -eq $false) { New-Item -Path $path -ItemType Directory }
        $res = Test-PowerManager -ModulesDirectoryExists
        if ($existingDir -eq $false) { Remove-Item -Path $path -Force }
        $res | Should be $true
    }

    It "-ModuleExists should return false when the module is missing" {

    }

    It "-ModuleExists should return true when the module is present" {
        
    }

    It "-ModuleExists should return false when the dev module is missing" {
        
    }

    It "-ModuleExists should return true when the dev module is present" {
        
    }
}

AfterAll {}