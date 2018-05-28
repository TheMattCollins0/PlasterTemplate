# Prompt for the name of my new module
$ModuleName = Read-Host -Prompt "Please enter the name of the new module"

# Prompt for a description of the module
$ModuleDescription = Read-Host -Prompt "Please provide a description for the module"

# Creation of the destination path
$Destination = "C:\GitHub\" + $ModuleName

# Creation of the $PlasterSplat splat
$PlasterSplat = @{
    TemplatePath    = "C:\GitHub\PlasterTemplate"
    FullName        = "Matt Collins"
    DestinationPath = $Destination
    Version         = "0.0.1"
    ModuleName      = $ModuleName
    ModuleDesc      = $ModuleDescription
}

# Creation of the destination path for the new module
If (!(Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination | Out-Null
}

# Invoke Plaster using the supplied splat
Invoke-Plaster @PlasterSplat

# Change location to the newly created module directory
Set-Location $Destination
