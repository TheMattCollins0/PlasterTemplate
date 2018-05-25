$ErrorActionPreference = 'stop'
Install-PackageProvider -Name Nuget -Scope CurrentUser -Force -Confirm:$false
Install-Module -Name Pester -Scope CurrentUser -Force -Confirm:$false
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -Confirm:$false
Import-Module Pester
Import-Module PSScriptAnalyzer
Invoke-Pester -OutputFile 'PesterResults.xml' -OutputFormat 'NUnitXml' -Script '.\Tests\ModuleImport.tests.ps1'
Invoke-Pester -OutputFile 'PSSAResults.xml' -OutputFormat 'NUnitXml' -Script '.\Tests\PSSA.tests.ps1'
