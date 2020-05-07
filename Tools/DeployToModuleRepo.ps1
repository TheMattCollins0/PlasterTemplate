[cmdletbinding()]
param (
    [Parameter(Mandatory = $false)]
    $RepositoryName,

    [Parameter(Mandatory = $false)]
    $FeedUsername,

    [Parameter(Mandatory = $false)]
    $PAT
)

# Variables
$ModuleFolderPath = ".\" + $env:BUILD_DEFINITIONNAME
$PackageSourceUrl = "https://pkgs.dev.azure.com/NodeIT/_packaging/" + $RepositoryName + "/nuget/v2"

Write-Verbose -Message "The specified module folder path is - $ModuleFolderPath"

# Create credential
$Password = ConvertTo-SecureString -String $PAT -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($FeedUsername, $Password)

# Test if the required version of PowerShellGet is available
try {
    Import-Module PowerShellGet -Force -RequiredVersion "1.5.0.0" -ErrorAction Stop
}
catch {
    Install-Module PowerShellGet -Force -RequiredVersion "1.5.0.0"
    Import-Module PowerShellGet -Force -RequiredVersion "1.5.0.0"
}

# Step 1
# Test if the Nuget PowerShell package provider already exists
try {
    Write-Output "Importing the Nuget provider"
    Import-PackageProvider -Name Nuget -RequiredVersion 3.0.0.1 -ErrorAction Stop
}
catch {
    Install-PackageProvider -Name Nuget -Scope CurrentUser -RequiredVersion 3.0.0.1 -Force -Confirm:$false -Verbose
}

# Create the Publish-Module splat
$PublishParams = @{
    Path        = $ModuleFolderPath
    Repository  = $RepositoryName
    NugetApiKey = 'VSTS'
    Credential  = $Credential
    Verbose     = $true
    Confirm     = $false
    Force       = $true
    ErrorAction = 'SilentlyContinue'
}

$ExistingRepo = Get-PSRepository -Name $RepositoryName -ErrorAction SilentlyContinue
if (!$ExistingRepo) {
    # Step 2
    # Testing if the Nuget source is already registered
    $NugetSourceTesting = nuget sources List | Select-String -Pattern $RepositoryName -Quiet
    if ( !$NugetSourceTesting ) {
        Nuget Sources Add -Name $RepositoryName -Source $PackageSourceUrl -Username $FeedUsername -Password $PAT
    }
    elseif ( $NugetSourceTesting ) {
        Write-Verbose -Message "The nuget source already exists, skipping the source addition step"
    }


    # Step 3
    # THIS WILL FAIL first time, so don't panic!
    # Try to Publish a PowerShell module - this will prompt and download NuGet.exe, and fail publishing the module (we publish at the end)
    Publish-Module @PublishParams | Out-Null

    # Step 4
    # Register feed
    Write-Output "Trying to register the PowerShell repository now"
    $RegisterParams = @{
        Name                      = $RepositoryName
        SourceLocation            = $PackageSourceUrl
        PublishLocation           = $PackageSourceUrl
        InstallationPolicy        = 'Trusted'
        PackageManagementProvider = 'Nuget'
        Credential                = $Credential
        Verbose                   = $true
    }
    Register-PSRepository @RegisterParams


}

# Step 5
# Publish PowerShell module (2nd time lucky!)
Write-Output "Trying to publish the PowerShell module now"
Publish-Module @PublishParams

# Run Find-Module to check that the publish has worked
Find-Module -Repository $RepositoryName -Credential $Credential -Verbose

# Step 6
# Check for the existence of the PowerShell repository
$RepositoryCheck = Get-PSRepository -Name $RepositoryName -ErrorAction SilentlyContinue
# Remove the PowerShell repository
if ( $RepositoryCheck ) {
    Write-Output "Unregistering PS Repository"
    Unregister-PSRepository -Name $RepositoryName
}

Write-Output "Publish has been completed"
