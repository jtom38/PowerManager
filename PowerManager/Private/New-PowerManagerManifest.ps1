function New-PowerManagerManifest {
    <#
    .SYNOPSIS
    This will create a blank manifest file
    #>
    param ()
    # [Alias("npmf")]
    $schema = @{
        Project = @{
            Name = ''
            Version = ''
            RootModule = ''
            Author = ''
            CompanyName = ''
            Description = ''
            PowerShellRuntime = ""
        }
        Modules = @(
        )
        DevModules = @(
        )
        Repositories = @(
            @{
                Name = "PSGallery"
                Url = "https://www.powershellgallery.com/api/v2"
                InstallPolicy = "Untrusted"
            }
        )
    }

    if ((Test-PowerManager -ManifestExists) -eq $false) {
        $schema | ConvertTo-Json | Out-File -FilePath ".\.pmproject"
    }

    # Capture the returned object to keep STDOUT quiet
    #$r = New-Item -Path ".\.pm\" -Name 'runtime' -ItemType Directory

    return $schema
}