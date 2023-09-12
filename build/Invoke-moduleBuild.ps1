<#
.NOTES
    Copyright 1990-2024 Celerium

    NAME: Invoke-moduleBuild.ps1
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
    The Invoke-moduleBuild.ps1 script builds & prepares the PowerShell
    module for deployment

.PARAMETER SourcePath
    The path to the module folder, manifest or build.psd1

    Default value: .\moduleName\moduleName.psd1

.PARAMETER OutputDirectory
    Where to build the module

    Example: .\build\1.2.3

.PARAMETER Version
    The module version (must be a valid System.Version such as PowerShell supports for modules)

.PARAMETER UnversionedOutputDirectory
    Overrides the VersionedOutputDirectory, producing an OutputDirectory without a version number as the last folder

.EXAMPLE
    .\Invoke-moduleBuild.ps1 -Version 1.2.3

    Compiles the module files located in ..\moduleName and builds
    a combined module in ...\build\1.2.3

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
        [String]$OutputDirectory = "$($PSScriptRoot | Split-Path)\build",

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
    $OutputDirectory    = "$($PSScriptRoot | Split-Path)\build"

}

    $params = @{
        SourcePath      = $SourcePath
        OutputDirectory = $OutputDirectory
        Version         = $Version
        PublicFilter    = 'Private\*.ps1','Public\*.ps1'
        UnversionedOutputDirectory = $UnversionedOutputDirectory
    }

    Build-Module @params -Verbose

    #Replace & comment out NestedModules from nonBuilt module
    $modulePath = "$OutputDirectory\DattoAPI\$Version\DattoAPI.psd1"

    Update-Metadata -Path $modulePath -PropertyName NestedModules -Value  @()
    (Get-Content -Path $modulePath -Raw) -replace 'NestedModules = @\(\)', '# NestedModules = @()' | Set-Content -Path $modulePath

#EndRegion  [ Build Module ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''

$TimeToComplete = New-TimeSpan -Start $StartDate -End (Get-Date)
Write-Verbose 'Time to complete'
Write-Verbose ($TimeToComplete | Select-Object * -ExcludeProperty Ticks,Total*,Milli* | Out-String)