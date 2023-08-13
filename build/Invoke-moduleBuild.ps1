<#
.NOTES
    Copyright 1990-2023 Celerium

    NAME: build.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2023-04-1
        EMAIL:   celerium@Celerium.org
        Updated:
        Date:

    TODO:

.SYNOPSIS
    Builds & prepares the PowerShell module for deployment

.DESCRIPTION
    The build script builds & prepares the PowerShell module for deployment

    The builds runs through various workflows such as the creation of the
    module into an output folder, various Pester & code coverage tests,
    markdown documentation and more.

.PARAMETER SourcePath
    The path to the module folder, manifest or build.psd1

    The default value is ...\moduleName\moduleName.psd1

.PARAMETER OutputDirectory
    Where to build the module

    The default value is ...\build\versions\1.2.3

.PARAMETER Version
    The module version (must be a valid System.Version such as PowerShell supports for modules)

.PARAMETER UnversionedOutputDirectory
    Overrides the VersionedOutputDirectory, producing an OutputDirectory without a version number as the last folder

.EXAMPLE
    .\Invoke-moduleBuild.ps1 -Version 1.2.3

    Compiles the module files located in ..\moduleName and builds
    a combined module in ...\build\versions\1.2.3

.INPUTS
    SourcePath[String]

.OUTPUTS
    N\A

.LINK
    https://celerium.org

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 5.1
#Requires -Modules @{ ModuleName="ModuleBuilder";   ModuleVersion="3.0.0" }
#Requires -Modules @{ ModuleName="Pester";          ModuleVersion="5.4.0" }
#Requires -Modules @{ ModuleName="platyPS";         ModuleVersion="0.14.2" }

#Region  [ Parameters ]

[CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory=$false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SourcePath = "$($PSScriptRoot | Split-Path)\DattoAPI\DattoAPI.psd1",

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$OutputDirectory = "$($PSScriptRoot | Split-Path)\build\versions",

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Version,

        [Parameter(Mandatory=$false)]
        [Switch]$UnversionedOutputDirectory
    )

#EndRegion  [ Parameters ]

Write-Verbose ''
Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - [ $($PSCmdlet.ParameterSetName) ]"
Write-Verbose ''

#Region     [ Prerequisites ]

$StartDate = Get-Date

#EndRegion  [ Prerequisites ]

#Region     [ Build Module ]

#Added because of weird Az DevOps issue
if ( $PSVersionTable.PSVersion.Major -eq '5' ){

    $SourcePath         = "$($PSScriptRoot | Split-Path)\DattoAPI\DattoAPI.psd1"
    $OutputDirectory    = "$($PSScriptRoot | Split-Path)\build\versions"

}

    $params = @{
        SourcePath      = $SourcePath
        OutputDirectory = $OutputDirectory
        Version         = $Version
        PublicFilter    = 'Private\*.ps1','Public\*.ps1'
        UnversionedOutputDirectory = $UnversionedOutputDirectory
    }

    Build-Module @params -Verbose

#EndRegion  [ Build Module ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''

$TimeToComplete = New-TimeSpan -Start $StartDate -End (Get-Date)
Write-Verbose 'Time to complete'
Write-Verbose ($TimeToComplete | Select-Object * -ExcludeProperty Ticks,Total*,Milli* | Out-String)