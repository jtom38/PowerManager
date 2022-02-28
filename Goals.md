# PowerManager

## Terms

* `manifest` = This is the schema that defines the requirements of a module and or script.  This can be found in the .pmproject or as a hashtable

## Goals

### Module Dependencies

   1. PowerManager helps to organize the module/script module dependencies.  Have a manifest file that works for Repos' and also scripts
   2. Many people use PowerShell as just a script runner without building modules.
   3. Having the manifest in the script allows to define the requirements for a script to avoid breaking changes.

### Package Modules/Scripts

Given PowerManager will know about all the requirements for the script/module, being able to package up the project would be ideal.  

PowerManager will be able to build your psd1 file based on the information defined in the manifest file.

If you need to publish your module to an internal repository, PowerManager will generate the required nuget files based on the manifest, build, and upload for you.  This should help with CI/CD processes.

### Disposable PowerShell Runtimes

Be able to download a PowerShell Runtime and use it in the instance.  This lets you keep your runtime the same no matter where you are.  Older versions like 5.1, might not be supported as they are Windows only and also packaged with Windows.