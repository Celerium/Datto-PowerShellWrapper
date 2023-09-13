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
        Invoke-Pester -Path .\Tests\Private\baseUri\Get-DattoBaseURI.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\baseUri\Get-DattoBaseURI.Tests.ps1 -Output Detailed

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
    [String]$version,

    [Parameter(Mandatory=$true)]
    [ValidateSet('built','notBuilt')]
    [string]$buildTarget
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available inside It but NOT Describe or Context
    BeforeAll {

        $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\Tests')) )"

        switch ($buildTarget){
            'built'     { $modulePath = "$rootPath\build\$moduleName\$version" }
            'notBuilt'  { $modulePath = "$rootPath\$moduleName" }
        }

        if (Get-Module -Name $moduleName){
            Remove-Module -Name $moduleName -Force
        }
        Import-Module -Name "$modulePath\$moduleName.psd1" -ErrorAction Stop -ErrorVariable moduleError *> $null

        if ($moduleError){
            $moduleError
            exit 1
        }

    }

    AfterAll{

        Remove-DattoAPIKey -WarningAction SilentlyContinue

        if (Get-Module -Name $moduleName){
            Remove-Module -Name $moduleName -Force
        }

    }

#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $pester_TestName = (Get-Item -Path $PSCommandPath).Name
        $commandName = $pester_TestName -replace '.Tests.ps1',''

    }

#EndRegion  [ Prerequisites ]


Describe "Testing [ $commandName ] functions with [ $pester_TestName ]" {

Context "[ $commandName ] testing functions" {

    It "[ $commandName ] should have an alias of [ Set-DattoBaseURI ]" {
        Get-Alias -Name Set-DattoBaseURI | Should -BeTrue
    }

    It "Without parameters should return the default URI" {
        Add-DattoBaseURI
        Get-DattoBaseURI | Should -Be 'https://api.datto.com/v1'
    }

    It "Should accept a value from the pipeline" {
        'https://celerium.org' | Add-DattoBaseURI
        Get-DattoBaseURI | Should -Be 'https://celerium.org'
    }

    It "With parameter -base_uri <value> should return what was inputted" {
        Add-DattoBaseURI -base_uri 'https://celerium.org'
        Get-DattoBaseURI | Should -Be 'https://celerium.org'
    }

    It "With parameter -data_center US should return the default URI" {
        Add-DattoBaseURI -data_center 'US'
        Get-DattoBaseURI | Should -Be 'https://api.datto.com/v1'
    }

    It "With invalid parameter value -data_center Space should return an error" {
        Remove-DattoBaseURI
        {Add-DattoBaseURI -data_center Space} | Should -Throw
    }

    It "The default URI should NOT contain a trailing forward slash" {
        Add-DattoBaseURI

        $URI = Get-DattoBaseURI
        ($URI[$URI.Length-1] -eq "/") | Should -BeFalse
    }

    It "A custom URI should NOT contain a trailing forward slash" {
        Add-DattoBaseURI -base_uri 'https://celerium.org/'

        $URI = Get-DattoBaseURI
        ($URI[$URI.Length-1] -eq "/") | Should -BeFalse
    }
}

}