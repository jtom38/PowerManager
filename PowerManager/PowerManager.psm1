using namespace System.IO

class PowerManagerSchema {
    PowerManagerSchema() {}
}

class PowerManagerManifestProject {
    [string] $Name
    [string] $Version
    [string] $RootModule
    [string] $Author
    [string] $CompanyName
    [string] $Description
    [string] $PowerShellRuntime

    PowerManagerManifestProject(
        [string] $Name = '', 
        [string] $Version = '', 
        [string] $RootModule = '', 
        [string] $Author = '', 
        [string] $CompanyName = '', 
        [string] $Description = '', 
        [string] $PowerShellRuntime = '5.1'
        ) {
        $this.Name = $Name
        $this.Version = $Version
        $this.Author = $Author
        $this.RootModule = $RootModule
        $this.CompanyName = $CompanyName
        $this.Description = $Description
        $this.PowerShellRuntime = $PowerShellRuntime
    }
}

class PowerManagerConfig {
    [string] $ManifestPath
    [string] $ModulesCachePath
    [string] $LockfilePath

    PowerManagerConfig() {
        $this.ManifestPath = (Join-Path -Path $PWD -ChildPath ".pmproject")
        $this.ModulesCachePath = (Join-Path -Path $PWD -ChildPath ".pm" -AdditionalChildPath @('modules'))
        $this.LockfilePath = (Join-Path -Path $PWD -ChildPath '.pmproject.lock')
    }
}

enum PowerManagerOsEnum {
    WINDOWS
    MAC
    LINUX
}

class PowerManagerValidation {
    [PowerManagerConfig] $_config
    PowermanagerValidation() {
        $this._config = [PowerManagerConfig]::new()
    }
    [bool] ManifestExist() {
        $res = Test-Path -Path $this._config.ManifestPath
        return $res
    }

    [bool] ModulesDirectoryExists() {
        $res = Test-Path -Path $this._config.ModulesCachePath
        return $res
    }
    
    [bool] LockFileExists() {
        $res = Test-Path -Path $this._config.LockfilePath
        return $res
    }

    [PowerManagerOsEnum] GetRuntimeOS() {
        $os = $Global:PSVersionTable.OS
        if ($os.Contains("Darwin") -eq $true ) {return [PowerManagerOsEnum]::MAC }
        elseif ($os.Contains("Windows") -eq $true) { return [PowerManagerOsEnum]::WINDOWS }
        else { return [PowerManagerOsEnum]::LINUX }
    }

    [string] GetOSPathSeperator() {
        $osType = $this.GetRuntimeOS()
        if ($osType -eq [PowerManagerOsEnum]::WINDOWS) { return ';' }
        else { return ':' }
    }

    [bool] IsModulePathInPSModulePath() {
        # have the module path in memory
        $modulePath = $this._config.ModulesCachePath

        # Figure out the os path seperator 
        #$pathSeperator = $this.GetOSPathSeperator()

        # build the path that we will need
        # $env:PSModulePath += "$pathSeperator$modulePath"
        if ($env:PSModulePath.Contains($modulePath) -eq $true) { 
            return $true
        }
        else {
            return $false
        }
    }
} 

class PowerManagerManifest {
    [PowerManagerConfig] $_config

    PowerManagerManifest(){
        $this._config = [PowerManagerConfig]::new()
    }

    [void] Write([object] $Manifest) {
        $json = ConvertTo-Json $Manifest -Depth 10
        $json | Out-File $this._config.ManifestPath
    }

    [object] Import(){
        if ((Test-PowerManager -ManifestExists) -eq $false) { throw "Unable to import the manifest file as it does not exist." }
        $res = Get-Content -Path (Get-PowerManagerConfig -Manifest) -Raw | ConvertFrom-Json
        if ($null -eq $res) { throw "The file was imported from disk, but had no content." }
        return $res
    }

    [hashtable] NewBlankManifest() {
        $schema = @{
            Project = $this.GetBlankProjectSchema()
            Modules = @()
            DevModules = @()
            Repositories = @(
                $this.GetDefaultRepositorySchema()
            )
        }
        return $schema
    }

    [hashtable] GetBlankProjectSchema() {
        $schema = @{
            Name = ''
            Version = ''
            RootModule = ''
            Author = ''
            CompanyName = ''
            Description = ''
            PowerShellRuntime = ""
        }
        return $schema
    }

    [hashtable] GetDefaultRepositorySchema() {
        return @{
            Name = "PSGallery"
            Url = "https://www.powershellgallery.com/api/v2"
            InstallPolicy = "Untrusted"
        }
    }

    [hashtable] GetModulesSchema([string] $Name, [string] $Version, [string] $Repository, [string] $Description, [bool] $IsDependency) {
        $schema = @{
            Name = $Name
            Version = $Version
            Repository = $Repository
            Description = $Description
            IsDependency = $IsDependency
        }
        return $schema
    }
}

class PowerManagerModules {
    [PowerManagerConfig] $_config
    [PowerManagerManifest] $_manifest
    [PowerManagerValidation] $_validation

    PowerManagerModules() {
        $this._config = [PowerManagerConfig]::new()
        $this._manifest = [PowerManagerManifest]::new()
        $this._validation = [PowerManagerValidation]::new()
    }

    [bool] DoesModuleExist([string] $ModuleName) {
        # Checks to see if the moduleName passed exists in the manifest
        $manifest = $this._manifest.Import()
        $modules = $manifest.Modules + $manifest.DevModules
        $exists = $modules.Name -contains $ModuleName
        return $exists
    }

    [void] FindDependency([int] $ExpectedModules, [switch] $IsDev) {
        $modulesPath = $this._config.ModulesCachePath
        $manifest = $this._manifest.Import()    

        # we got an extra module, we need to know what ones we got
        $modules = $manifest.Modules + $manifest.DevModules
        $installedModules = Get-ChildItem -Path $this._config.ModulesCachePath
        foreach ($installed in $installedModules) {
            $exists = $modules.Name -contains $installed.Name
            if ($exists -eq $true) { continue }
            
            # Get the module version installed 
            $childpath = Join-Path -Path $modulesPath -ChildPath $installed.Name
            $childVersion = Get-ChildItem -Path $childpath
    
            Write-Host "$($installed.Name):$($childVersion.Name) was installed as a dependency."
            Write-Host "Getting details on it and adding it to the manifest."
            $childModule = Find-Module `
                -Name $installed.Name `
                -RequiredVersion $childVersion.Name
        
            $schema = $this._manifest.GetModulesSchema(
                $childModule.Name, 
                $childModule.Version, 
                $childModule.Repository, 
                $childModule.Description,
                $true
            )

            if ($IsDev) {
                $manifest.DevModules += $schema
            } else {
                $manifest.Modules += $schema
            }
        }
        $this._manifest.Write($manifest)
    } 

    # Need to add a globl flag to ignore PowerManager even though most might not use it.
    [void] NewModule([string] $Name, [string] $version, [bool] $IsDev) {

        $manifest = $this._manifest.Import()

        Write-Host "Checking the repositories for '$Name'"
        $foundResults = Find-Module -Name $Name
        Write-Host "Found '$($foundResults.Name):$($foundResults.Version)'"
        $schema = $this._manifest.GetModulesSchema(
            $foundResults.Name,
            $foundResults.Version,
            $foundResults.Repository,
            $foundResults.Description,
            $false
        )     

        if ($isDev) {
            $manifest.DevModules += $schema
        } else {
            $manifest.Modules += $schema
        }
        # Gets the directories on disk before we add the new module to track dependancies
        $modulesBeforeInstall = Get-ChildItem -Path $this._config.ModulesCachePath

        $this._manifest.Write($manifest)
        $manifest = $this._manifest.Import()

        # Save the requested module along with any dependancies 
        Save-Module -Name $Name -Path $this._config.ModulesCachePath

        $this.FindDependency($($modulesBeforeInstall.Length + 1), $isDev )
    }

    [void] InstallGlobalModule([string] $Name, [string] $Version) {
        $result = Find-Module -Name $Name -RequiredVersion $Version
        if ($null -eq $result) { Write-Error "Unable to find '${Name}:${Version}'!"}
        Install-Module -Name $Name -RequiredVersion $Version
    }

    [void] hidden InstallModule([object] $module) {
        $cachePath = Get-PowerManagerConfig -PathModulesCache
        $expectedPath = $this.FindModuleVersionImportPath($module.Name, $module.Version)

        $moduleNameAndVersion = "$($module.Name):$($module.Version)"
        if ((Test-Path -Path $expectedPath ) -eq $true) {
            Write-Host "$moduleNameAndVersion = present"
        } else {
            Write-Host "$moduleNameAndVersion = downloading"
            Save-Module `
                -Name $module.Name `
                -RequiredVersion $module.Version `
                -Path $cachePath `
                -Repository $module.Repository
            $this.Import($module.Name, $module.Version)
        }
    }

    [void] Install([switch] $IsDev) {
        $this.AppendPSModulePath()
        $manifest = $this._manifest.Import()
        $modules = $manifest.Modules
        if ($IsDev) {
            $modules += $manifest.DevModules
        }
    
        # Install Dependencies
        foreach ($module in $modules) {
            if ($module.IsDependency -eq $true) { $this.InstallModule($module) }
        }

        # Install the rest
        foreach ($module in $modules) {
            if ($module.IsDependency -eq $false) { $this.InstallModule($module) }
        }
    }

    [string] FindModuleImportPath([string] $Name) {
        $cachePath = $this._config.ModulesCachePath
        $expectedPath = Join-Path -Path $cachePath -ChildPath $Name
        return $expectedPath
    }

    [string] FindModuleVersionImportPath([string] $Name, [string] $Version) {
        $cachePath = $this._config.ModulesCachePath
        $expectedPath = Join-Path -Path $cachePath -ChildPath $Name
        $expectedPath = Join-Path -Path $expectedPath -ChildPath $Version
        return $expectedPath
    }

    [void] Import([string] $Name, [string] $Version) {
        $importPath = $this.FindModuleImportPath($Name)
        $expectedPath = $this.FindModuleVersionImportPath($Name, $Version)
        if ((Test-Path -Path $expectedPath) -eq $false ) { throw "Unable to find the path for ${Name}:${Version} on disk!  Try Install-PowerManager."}
        Import-Module -Name $importPath -Force
    }

    [void] AppendPSModulePath() {
        if ($this._validation.IsModulePathInPSModulePath() -eq $false) {
            $env:PSModulePath += "$($this._validation.GetOSPathSeperator())$($this._config.ModulesCachePath)"
        }
    }

    [void] RemovePSModulePath() {
        if ($this._validation.IsModulePathInPSModulePath() -eq $true) {
            $env:PSModulePath = $env:PSModulePath.Remove("$($this._validation.GetOSPathSeperator())$($this._config.ModulesCachePath)")
        }
    }
}

class PowerManager {
    [PowerManagerConfig] $_config
    [PowerManagerManifest] $_manifest
    [PowerManagerValidation] $_validation
    [PowerManagerModules] $_modules

    PowerManager() {
        $this._config = [PowerManagerConfig]::new()
        $this._manifest = [PowerManagerManifest]::new()
        $this._validation = [PowerManagerValidation]::new()
        $this._modules = [PowerManagerModules]::new()
    }

    [void] New(
        [string] $ProjectName, 
        [string] $Version, 
        [string] $RootModule, 
        [string] $Author, 
        [string] $CompanyName, 
        [string] $Description,
        [string] $PowerShellRuntime,
        [bool] $Force
            ){
        
        if (-not $ProjectName) { $ProjectName = Read-Host "Enter the name of your project" }
        if (-not $RootModule) { $RootModule = Read-Host "Enter the name of the PowerShell Module File (psm1) if this is for a module (Enter 'none' if this is a script)" }
        if (-not $Author) { $Author = Read-Host "Enter the name of the author" }
        if (-not $CompanyName) { $CompanyName = Read-Host "Enter the company/team name:" }
        if (-not $Description) { $Description = Read-Host "Enter the projects description" }
        
        Write-Host "Project Name: $ProjectName"
        Write-Host "Version = $Version"
        Write-Host "RootModule: $RootModule"
        Write-Host "Author: $Author"
        Write-Host "Company/Team Name: $CompanyName"
        Write-Host "Description: $Description"
        Write-Host "PowerShell Runtime: $PowerShellRuntime"
        
        if ($Force -eq $false) {
            $accept = Read-Host "Please confirm the following values: (y/n)"
            switch ($accept.ToLower()) {
                'y' { Write-Host "Generating .pmproject" }
                'n' { Write-Host "Aborted by user"; exit }
                default { Write-Host "Invalid entry."; exit }
            }
        }
        
        $manifest = $this._manifest.NewBlankManifest()
        $manifest.Project.Name = $ProjectName
        $manifest.Project.Version = $Version
        $manifest.Project.RootModule = $RootModule
        $manifest.Project.Author = $Author
        $manifest.Project.CompanyName = $CompanyName
        $manifest.Project.Description = $Description
        $manifest.Project.PowerShellRuntime = $PowerShellRuntime

        $this._manifest.Write($manifest)

        if ($this._validation.ModulesDirectoryExists() -eq $true) {
            $this.CreateModuleCache()
        }
    }

    [void] CreateModuleCache(){
        $r = New-Item -Path $this._config.ModulesCachePath -ItemType Directory 
    }
}

Write-Debug -Message "Looking for all files in Public"
$Public =  @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)

Write-Debug -Message "Looking for all files in Private"
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)

foreach($import in @($Public + $Private)){
    try{
        . $import.fullname
    }catch{
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename