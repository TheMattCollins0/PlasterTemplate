# Prompt for the name of my new module
$ModuleName = Read-Host -Prompt "Please enter the name of the new module"

# Prompt for a description of the module
$ModuleDescription = Read-Host -Prompt "Please provide a description for the module"

# Creation of the destination path
$Destination = "C:\MattDropbox\Dropbox\Scripts\GitHub\" + $ModuleName

# Creation of the $PlasterSplat splat
$PlasterSplat = @{
    TemplatePath    = "C:\MattDropbox\Dropbox\Scripts\GitHub\PlasterTemplate"
    DestinationPath = $Destination
    ModuleName      = $ModuleName
    FullName        = "Matt Collins"
    ModuleDesc      = $ModuleDescription
    GitHubUserName  = "TheMattCollins0"
    GitHubRepo      = $ModuleName
}

# Creation of the destination path for the new module
If (!(Test-Path $PlasterSplat.DestinationPath)) {
    New-Item -ItemType Directory -Path $Destination | Out-Null
}

Invoke-Plaster @PlasterSplat -Verbose
