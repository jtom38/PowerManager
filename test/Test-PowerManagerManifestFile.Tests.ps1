
BeforeAll {
    #. .\PowerManager\Private\Test-PowerManagerManifestFile.ps1
}

Describe 'Test-PowerManagerManifestFile'{
    It "Should return false if the file is not present" {
        #$path = ".\.pmproject"
        $manifestPath = Get-PowerManagerConfig -Manifest
        $manifestExists = Test-Path $manifestPath
        if ($manifestExists -eq $true ) { Remove-Item $manifestPath -Force }
        Test-PowerManagerManifestFile | Should be $false
    }

    It "Should return true when file is present" {
        $path = Join-Path -Path $PWD -ChildPath "./.pmproject"
        New-Item -Path $path
        Test-PowerManagerManifestFile | Should be $true
    }
}

AfterAll {
    #$path = ".\.pmproject"
    #Remove-Item -Path $path
}