# PowerManager

PowerShell Package Manager

## Why PowerManager

This modules goal is to elevate PowerShell module management by giving it some features you might miss if you are use to other programing languages like `python`, `javascript`, or even `C#`.  Breaking away the dependance on global modules to more project level module.  If you need a specific version of `SqlServer` and don't want to risk breaking changes from new version of that module then storing your dependencies local to your project is ideal.  `PowerManager` lets you define your project dependencies rather then your computers modules.  If you have two projects that need different version of the same module, your in good hands.

## Getting Started

Download PowerManager as a global package. **TBD**

Open your project folder and run the following command to get started.
`New-PowerManager` This will ask you some questions and get your project ready

## Commands

### General Commands

`New-PowerManager` This will setup a new PowerManager instance in your current folder.  This is required to get started.  
`Install-PowerManager` This will check the manifest file and install all the project requirements into your cache.  
`Initialize-PowerManager` This will tailor your current PowerShell session to work with your installed modules.  Any modules that are duplicated by name will be replaced by the module in your cache to keep your versions the same.  
`Upgrade-PowerManager` = Upgrade your current instance of PowerManager with the newest build available.  
`Clear-PowerManagerCache` = Deletes the local cache for your project.  Once this is used, run `Install-PowerManager` to rebuild.  

### Module Commands

`New-PowerManagerModule` This will add a new module to your manifest and download the module into your cache for later use.  
`Remove-PowerManagerModule` = This will remove a module from your manifest and cache.  
`Update-PowerManagerModule` = This will update the package if any is available.  

### Repository Commands

TBD

### Package Management Commands

TBD

### Runtime Management Commands

TBD

## Terms

* `manifest` = This is the schema that defines the requirements of a module and or script.  This can be found in the .pmproject or as a hashtable in your script.
* `module` = This is the standard PowerShell module that you would be able to install with `Install-Module`.
* `cache` = This is the location where your modules are stored relative to your project. `.pm/`
* `global` = This term is around global package installs.  When you install a package with `Install-Package` this is a package that can be used always.

## Goals

### Module Management

   1. PowerManager helps to organize the module/script module dependencies.  Have a manifest file that works for Repos' and also scripts
   2. Many people use PowerShell as just a script runner without building modules.
   3. Having the manifest in the script allows to define the requirements for a script to avoid breaking changes.



### Package Modules/Scripts

Given PowerManager will know about all the requirements for the script/module, being able to package up the project would be ideal.  

PowerManager will be able to build your psd1 file based on the information defined in the manifest file.

If you need to publish your module to an internal repository, PowerManager will generate the required nuget files based on the manifest, build, and upload for you.  This should help with CI/CD processes.

### Runtime Management

Be able to download a PowerShell Runtime and use it in the instance.  This lets you keep your runtime the same no matter where you are.  Older versions like 5.1, might not be supported as they are Windows only and also packaged with Windows.