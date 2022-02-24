function New-PowerManagerFile {
    param (
        
    )
    $schema = @{
        Project = @{
            Name = ''
            Version = ''
            RootModule = ''
            Author = ''
            CompanyName = ''
            Description = ''
        }
        Modules = @(
            @{
                Name = "PSGallery"
                Version = ""
            }
        )
        Repositories = @(
            @{
                Name = "PSGallery"
                Url = "https://www.powershellgallery.com/api/v2"
                InstallPolicy = "Untrusted"
            }
        )
    }

    # Capture the returned object to keep STDOUT quiet
    $r = New-Item -Path ".\.pm\" -Name 'runtime' -ItemType Directory
    $r = New-Item -Path ".\.pm\" -Name 'modules' -ItemType Directory

    #$r = New-Item -Path '.' -Name ".pmproject"
    $schema | ConvertTo-Json | Out-File -FilePath ".\.pmproject"
}