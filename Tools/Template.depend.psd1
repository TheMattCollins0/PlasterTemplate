@{
    PSDependOptions  = @{
    Target = 'CurrentUser'
    }

    PesterInstall = @{
        Name           = 'Pester'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
        Version        = '4.10.1'
    }

    PSScriptAnalyzerInstall = @{
        Name           = 'PSScriptAnalyzer'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
        Version        = '1.18.0'
    }

    PlatyPS          = 'latest'
}
