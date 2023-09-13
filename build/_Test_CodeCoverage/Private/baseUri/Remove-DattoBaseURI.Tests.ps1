<#
    .SYNOPSIS
        Pester tests for the DattoAPI baseURI functions

    .DESCRIPTION
        Pester tests for the DattoAPI baseURI functions

    .PARAMETER moduleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'built', 'notBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\baseUri\Remove-DattoBaseURI.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\baseUri\Remove-DattoBaseURI.Tests.ps1 -Output Detailed

        Runs a pester test and outputs detailed results

    .INPUTS
        N\A

    .OUTPUTS
        N\A

    .NOTES
        N\A

    .LINK
        https://celerium.org

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 5.1
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.5.0' }

#Region     [ Parameters ]

#Available in Discovery & Run
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [String]$moduleName = 'DattoAPI',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$version
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available inside It but NOT Describe or Context
    BeforeAll {

        $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        #$modulePath = "$rootPath\build\versions\$moduleName\$version"
        $scriptPath = "$rootPath\$moduleName\Private\baseUri\"

        $import_Scripts = Get-ChildItem -Path $scriptPath

        Foreach ($script in $import_Scripts){

            if (Get-Module -Name $script.BaseName){
                Remove-Module -Name $script.BaseName -Force
            }
            Import-Module $script.FullName -ErrorAction Stop -ErrorVariable moduleError *> $null

            if ($moduleError){
                $moduleError
                exit 1
            }

        }

    }

    AfterAll{
        Foreach ($script in $import_Scripts){
            if (Get-Module -Name $script.BaseName){
                Remove-Module -Name $script.BaseName -Force
            }
        }
    }


#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $pester_TestName = (Get-Item -Path $PSCommandPath).Name
        $commandName = $pester_TestName -replace '.Tests.ps1',''

    }

#EndRegion  [ Prerequisites ]

Describe "Testing [ $commandName ] function with [ $pester_TestName ]" {

    Context "[ $commandName ] testing function" {

        It "The baseUri variable should not longer exist" {
            Add-DattoBaseURI
            Remove-DattoBaseURI
            $Datto_Base_URI | Should -BeNullOrEmpty
        }

        It "If the baseUri is already gone a warning should be thrown" {
            Add-DattoBaseURI
            Remove-DattoBaseURI
            Remove-DattoBaseURI -WarningAction SilentlyContinue -WarningVariable baseUriWarning
            [bool]$baseUriWarning | Should -BeTrue
        }

    }

}