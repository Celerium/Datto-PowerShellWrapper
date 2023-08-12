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

.PARAMETER Modules
    Defines one or more modules to install

.PARAMETER Update
    Update the modules if they are already installed

.PARAMETER Force
    Force install and or update modules

.EXAMPLE
    .\build.ps1

    Installs the prerequisites needed to build and test a Celerium PowerShell project.

    No progress information is sent to the console while the script is running.

.INPUTS
    Modules[String]

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

[CmdletBinding(DefaultParameterSetName = 'Install', SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory=$false, ParameterSetName = 'Build', ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SourcePath = "$($PSScriptRoot | Split-Path)\Source\DattoAPI.psd1",

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Version = '2.0.1'
    )

#EndRegion  [ Parameters ]

Write-Verbose ''
Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - [ $($PSCmdlet.ParameterSetName) ]"
Write-Verbose ''

#Region     [ Prerequisites ]

$StartDate = Get-Date

#EndRegion  [ Prerequisites ]

#Region     [ Main Code ]

#$RootPath1 = $PSScriptRoot | Split-Path | Split-Path
#$RootPath2 = $PSScriptRoot

#Set-Variable -Name Testrootpath1 -Value $RootPath1 -Scope Global -Force
#Set-Variable -Name Testrootpath2 -Value $RootPath2 -Scope Global -Force


if ( $PSVersionTable.PSVersion.Major -eq '5' ){
    $SourcePath = "$($PSScriptRoot | Split-Path)\Source\DattoAPI.psd1"
}

$params = @{
    SourcePath = $SourcePath
    #CopyPaths = @("$PSScriptRoot\README.md", "$PSScriptRoot\Source\KpInfo.nuspec")
    Version = $Version
    UnversionedOutputDirectory = $true
}

Build-Module @params -Verbose

#EndRegion  [ Main Code ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''

$TimeToComplete = New-TimeSpan -Start $StartDate -End (Get-Date)
Write-Verbose 'Time to complete'
Write-Verbose ($TimeToComplete | Select-Object * -ExcludeProperty Ticks,Total*,Milli* | Out-String)