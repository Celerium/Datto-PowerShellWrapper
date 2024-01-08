#
# Module manifest for module 'DattoAPI'
#
# Generated by: David Schulte
#
# Generated on: 2022-04-23
#

@{

    # Script module or binary module file associated with this manifest
    RootModule = 'DattoAPI.psm1'

    # Version number of this module.
    # Follows https://semver.org Semantic Versioning 2.0.0
    # Given a version number MAJOR.MINOR.PATCH, increment the:
    # -- MAJOR version when you make incompatible API changes,
    # -- MINOR version when you add functionality in a backwards-compatible manner, and
    # -- PATCH version when you make backwards-compatible bug fixes.

    # Version number of this module.
    ModuleVersion = '2.2.1'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID = 'd536355d-2a81-444f-9e08-9eeeda6db819'

    # Author of this module
    Author = 'David Schulte'

    # Company or vendor of this module
    CompanyName = 'Celerium'

    # Copyright information of this module
    Copyright = 'https://github.com/Celerium/Datto-PowerShellWrapper/blob/main/LICENSE'

    # Description of the functionality provided by this module
    Description = 'This module provides a PowerShell wrapper for the Datto BCDR & SaaS API.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @( )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    #ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = 'Private/apiCalls/ConvertTo-DattoQueryString.ps1',
                    'Private/apiCalls/Get-DattoMetaData.ps1',
                    'Private/apiCalls/Invoke-DattoRequest.ps1',

                    'Private/apiKeys/Add-DattoAPIKey.ps1',
                    'Private/apiKeys/Get-DattoAPIKey.ps1',
                    'Private/apiKeys/Remove-DattoAPIKey.ps1',
                    'Private/apiKeys/Test-DattoAPIKey.ps1',

                    'Private/baseUri/Add-DattoBaseURI.ps1',
                    'Private/baseUri/Get-DattoBaseURI.ps1',
                    'Private/baseUri/Remove-DattoBaseURI.ps1',

                    'Private/moduleSettings/Export-DattoModuleSettings.ps1',
                    'Private/moduleSettings/Get-DattoModuleSettings.ps1',
                    'Private/moduleSettings/Import-DattoModuleSettings.ps1',
                    'Private/moduleSettings/Initialize-DattoModuleSettings.ps1',
                    'Private/moduleSettings/Remove-DattoModuleSettings.ps1',

                    'Public/BCDR/Get-DattoAgent.ps1',
                    'Public/BCDR/Get-DattoAlert.ps1',
                    'Public/BCDR/Get-DattoAsset.ps1',
                    'Public/BCDR/Get-DattoBCDR.ps1',
                    'Public/BCDR/Get-DattoDevice.ps1',
                    'Public/BCDR/Get-DattoShare.ps1',
                    'Public/BCDR/Get-DattoVMRestore.ps1',
                    'Public/BCDR/Get-DattoVolume.ps1',

                    'Public/Reporting/Get-DattoActivityLog.ps1',

                    'Public/SaaS/Get-DattoApplication.ps1',
                    'Public/SaaS/Get-DattoDomain.ps1',
                    'Public/SaaS/Get-DattoSaaS.ps1',
                    'Public/SaaS/Get-DattoSeat.ps1',
                    'Public/SaaS/Set-DattoBulkSeatAssignment.ps1'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = '*'

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('Datto', 'BCDR', 'SaaS', 'API', 'PowerShell', 'PSEdition_Desktop', 'PSEdition_Core', 'Windows', 'Kaseya', 'Celerium')

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/Celerium/Datto-PowerShellWrapper/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Celerium/Datto-PowerShellWrapper'

            # A URL to an icon representing this module.
            IconUri = 'https://raw.githubusercontent.com/Celerium/Datto-PowerShellWrapper/main/.github/images/Celerium_PoSHGallery_DattoAPI.png'

            # ReleaseNotes of this module
            ReleaseNotes = 'https://github.com/Celerium/Datto-PowerShellWrapper/blob/main/README.md'

            # Identifies the module as a prerelease version in online galleries.
            #PreRelease = '-BETA'

            # Indicate whether the module requires explicit user acceptance for install, update, or save.
            RequireLicenseAcceptance = $false

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = 'https://github.com/Celerium/Datto-PowerShellWrapper'

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

