# Prompt for the name of my new module
$ModuleName = Read-Host -Prompt "Please enter the name of the new module"

# Prompt for a description of the module
$ModuleDescription = Read-Host -Prompt "Please provide a description for the module"

# Creation of the destination path
$DestinationPath = "C:\MattDropbox\Dropbox\Scripts\GitHub\" + $ModuleName

# Creation of the $PlasterSplat splat
$PlasterSplat = @{
    TemplatePath    = "C:\MattDropbox\Dropbox\Scripts\GitHub\PlasterTemplate"
    DestinationPath = $DestinationPath
    Name            = $ModuleName
    FullName        = "Matt Collins"
    ModuleDesc      = $ModuleDescription
    GitHubUserName  = "TheMattCollins0"
}

# Creation of the destination path for the new module
If (!(Test-Path $PlasterSplat.DestinationPath)) {
    New-Item -ItemType Directory -Path $PlasterSplat.DestinationPath | Out-Null
}

Invoke-Plaster @PlasterSplat -Verbose
