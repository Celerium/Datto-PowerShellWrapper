<#
.NOTES
    Copyright 2020-2023 Celerium

    NAME: Invoke-HelpContent.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2022-11-26
        EMAIL:   celerium@celerium.org
        Updated:
        Date:

    VERSION HISTORY:
    0.1 - 2022-11-26 - Initial Release

    TODO:
    N\A

.SYNOPSIS
    Calls the Update-HelpContent script to update module markdown help files

.DESCRIPTION
    The Update-HelpContent script calls the Update-HelpContent script to
    update module markdown help files

.PARAMETER moduleName
    The name of the module to update help docs for

.PARAMETER SourcePath
    The source location of the module

.PARAMETER githubPageUri
    The github project url to inject into help docs

.EXAMPLE
    .\Invoke-HelpContent.ps1
        -moduleName DattoAPI
        -helpDocsPath "C:\Celerium\Projects\Datto-PowerShellWrapper\docs"
        -csvFilePath "C:\Celerium\Projects\Datto-PowerShellWrapper\docs\S1-Endpoints-v2.1.csv"
        -githubPageUri "https://celerium.github.io/Datto-PowerShellWrapper"

    Updates markdown docs and external help files

    No progress information is sent to the console while the script is running.

.INPUTS
    helpDocsPath

.OUTPUTS
    N\A

.LINK
    https://celerium.org

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 5.1
#Requires -Modules @{ ModuleName="platyPS"; ModuleVersion="0.14.2" }

#Region  [ Parameters ]

[CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$moduleName = 'DattoAPI',

        [Parameter(Mandatory=$false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SourcePath = $($PSScriptRoot | Split-Path),

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$githubPageUri = "https://celerium.github.io/Datto-PowerShellWrapper"
    )

#EndRegion  [ Parameters ]

Write-Verbose ''
Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - [ $($PSCmdlet.ParameterSetName) ]"
Write-Verbose ''

#Region     [ Prerequisites ]

$StartDate = Get-Date

#EndRegion  [ Prerequisites ]

#Region  [ Update Help ]

    Import-Module "$SourcePath\build\Update-HelpContent.ps1" -Force

    $parameters = @{
        moduleName      = $moduleName
        helpDocsPath    = "$SourcePath\docs"
        csvFilePath     = "$SourcePath\docs\Endpoints.csv"
        githubPageUri   = $githubPageUri
        verbose         = $true
    }

    Update-HelpContent @parameters

#EndRegion  [ Update Help ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''

$TimeToComplete = New-TimeSpan -Start $StartDate -End (Get-Date)
Write-Verbose 'Time to complete'
Write-Verbose ($TimeToComplete | Select-Object * -ExcludeProperty Ticks,Total*,Milli* | Out-String)