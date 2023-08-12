<#
.NOTES
    Copyright 1990-2023 Celerium

    NAME: Install-Prerequisites.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2023-04-1
        EMAIL:   celerium@Celerium.org
        Updated:
        Date:

    TODO:

.SYNOPSIS
    Installs the prerequisites needed to build and test a Celerium PowerShell project.

.DESCRIPTION
    The Install-Prerequisites script Installs the prerequisites needed to
    build and test a Celerium PowerShell project.

    The various prerequisites required allow for the automation of documentation,
    Azure Pipelines, Pester testing, GitHub repo setup, PowerShell module setup
    and much more.

.PARAMETER Modules
    Defines one or more modules to install

.PARAMETER Update
    Update the modules if they are already installed

.PARAMETER Force
    Force install and or update modules

.EXAMPLE
    .\Install-Prerequisites.ps1

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
<# #Requires -RunAsAdministrator #>

#Region  [ Parameters ]

[CmdletBinding(DefaultParameterSetName = 'Install', SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory=$false, ParameterSetName = 'Install', ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Modules = @('ModuleBuilder', 'Pester', 'platyPS'),

        [Parameter(Mandatory=$false, ParameterSetName = 'Update')]
        [Switch]$Update,

        [Parameter(Mandatory=$false)]
        [Switch]$Force
    )

#EndRegion  [ Parameters ]

Write-Verbose ''
Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - [ $($PSCmdlet.ParameterSetName) ]"
Write-Verbose ''

#Region     [ Prerequisites ]

$StartDate = Get-Date

#EndRegion  [ Prerequisites ]

#Region     [ Main Code ]

<#
foreach ($Module in $Modules) {

    if ( [bool](Get-InstalledModule -Name $Module -ErrorAction SilentlyContinue) ) {
        Write-Verbose "-       - $(Get-Date -Format MM-dd-HH:mm) - [ $Module ] is already installed"

        if($Update){
            Update-Module -Name $Module -Force:$Force
        }

    }
    else{

        Write-Verbose "-       - $(Get-Date -Format MM-dd-HH:mm) - Installing [ $Module ]"

        Install-Module -Name $Module -Force:$Force

    }

}#>

foreach ($Module in $Modules) {

    try {
        Get-InstalledModule -Name $Module -ErrorAction Stop
    }
    catch {
        Write-Host "Installing [ $Module ]"
        Install-Module -Name $Module -Force
    }

}

Get-InstalledModule $Modules

#EndRegion  [ Main Code ]

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''

$TimeToComplete = New-TimeSpan -Start $StartDate -End (Get-Date)
Write-Verbose 'Time to complete'
Write-Verbose ($TimeToComplete | Select-Object * -ExcludeProperty Ticks,Total*,Milli* | Out-String)