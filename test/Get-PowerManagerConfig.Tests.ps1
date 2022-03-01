
BeforeAll {

}
Describe "Get-PowerManagerConfig" {
    It "Should return nothing is switch is missing" {
        Get-PowerManagerConfig | Should be $null
    }

    It "Should return the Path to the manifest" {
        $expectedPath = Join-Path -Path $PWD -ChildPath ".pmproject"
        Get-PowerManagerConfig -Manifest | Should be $expectedPath
    }

    It "Should return the path to the cache" {
        $expectedPath = Join-Path -Path $PWD -ChildPath ".pm/modules"
        Get-PowerManagerConfig -ModuleCache | Should be $expectedPath
    }
}

AfterAll {
    
}