# Set the global Error action preference to stop
$ErrorActionPreference = 'stop'

# Install the Nuget package provider, Pester and PSScriptAnalyzer packages for testing
Install-PackageProvider -Name Nuget -Scope CurrentUser -Force -Confirm:$false
Install-Module -Name Pester -Scope CurrentUser -Force -Confirm:$false
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -Confirm:$false

# Install third party modules required for the module 
# Install-Module -Name <MODULENAME> -Scope CurrentUser -Force -Confirm:$false

# Import the Pester and PSScriptAnalyzer
Import-Module Pester
Import-Module PSScriptAnalyzer

# Run the Pester and PSScriptAnalyzer tests
Invoke-Pester -OutputFile 'PesterResults.xml' -OutputFormat 'NUnitXml' -Script '.\Tests\ModuleImport.tests.ps1'
Invoke-Pester -OutputFile 'PSSAResults.xml' -OutputFormat 'NUnitXml' -Script '.\Tests\PSSA.tests.ps1'
