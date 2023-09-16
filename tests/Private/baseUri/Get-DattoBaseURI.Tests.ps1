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
    [string]$buildTarget,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Api_Key_Public,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Api_Key_Secret
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available inside It but NOT Describe or Context
    BeforeAll {

        if ($IsWindows -or $PSEdition -eq 'Desktop') {
            $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }
        else{
            $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }

        switch ($buildTarget){
            'built'     { $modulePath = Join-Path -Path $rootPath -ChildPath "\build\$moduleName\$version" }
            'notBuilt'  { $modulePath = Join-Path -Path $rootPath -ChildPath "$moduleName" }
        }

        if (Get-Module -Name $moduleName){
            Remove-Module -Name $moduleName -Force
        }

        $modulePsd1 = Join-Path -Path $modulePath -ChildPath "$moduleName.psd1"

        Import-Module -Name $modulePsd1 -ErrorAction Stop -ErrorVariable moduleError *> $null

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

Describe "Testing [ $commandName ] function with [ $pester_TestName ]" {

    Context "[ $commandName ] testing function" {

        It "The default URI should be returned" {
            Add-DattoBaseURI
            Get-DattoBaseURI | Should -Be 'https://api.datto.com/v1'
        }

        It "The URI should be a string" {
            Add-DattoBaseURI
            Get-DattoBaseURI | Should -BeOfType string
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

        It "If the baseUri is not set a warning should be thrown" {
            Remove-DattoBaseURI
            Get-DattoBaseURI -WarningAction SilentlyContinue -WarningVariable baseUriWarning
            [bool]$baseUriWarning | Should -BeTrue
        }

    }

}