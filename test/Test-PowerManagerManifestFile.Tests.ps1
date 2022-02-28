
BeforeAll {
    . .\PowerManager\Private\Test-PowerManagerManifestFile.ps1
}

Describe 'Test-PowerManagerManifestFile'{
    It "Should return false if the file is not present" {
        $path = ".\.pmproject"
        Test-PowerManagerManifestFile | Should be $false
    }
}

AfterAll {
    Remove-Item -Path $path
}