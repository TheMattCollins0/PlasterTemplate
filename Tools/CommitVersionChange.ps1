
[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)][string]$EmailAddress
)

# Variables for the version number change commit back to GitHub
$ModuleName = $env:BUILD_DEFINITIONNAME
$ModulePath = ".\" + $ModuleName + "\" + $ModuleName + ".psd1"

# Git for the version number change commit back to GitHub
git config user.email $EmailAddress
git config user.name "TheMattCollins0"
git checkout master
git add "$ModulePath"
git commit -m "Updated Version Number ***NO_CI***"
git push origin HEAD:master
