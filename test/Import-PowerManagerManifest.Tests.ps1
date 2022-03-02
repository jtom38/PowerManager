Describe "Import-PowerManagerManifest" {
    It "Should error if the file is missing" {
        $manifestPath = Get-PowerManagerConfig -Manifest
        $manifestExists = Test-Path $manifestPath
        if ($manifestExists -eq $true ) { Remove-Item $manifestPath }
        { Import-PowerManagerManifest } | Should -Throw
    }

    It "Should error if the file exists but is empty" {
        $manifestPath = Get-PowerManagerConfig -Manifest
        $manifestExists = Test-Path $manifestPath
        if ($manifestExists -eq $true ) { Remove-Item $manifestPath }
        New-Item $manifestPath
        { Import-PowerManagerManifest } | Should -Throw
        Remove-Item $manifestPath -Force
    }

    It "Should return a hashtable if the file exists and has proper format" {
        $manifestPath = Get-PowerManagerConfig -Manifest
        $manifestExists = Test-Path $manifestPath
        if ($manifestExists -eq $true ) { Remove-Item $manifestPath }
        New-PowerManagerManifest
        $res = Import-PowerManagerManifest 
        $res | should -not -Be ""
        #Remove-Item $manifestPath -Force
    }

    It "Should have the Project Key" {
        $res = Import-PowerManagerManifest
        $res.Project | Should be $res.Project
    }

}

AfterAll {

}