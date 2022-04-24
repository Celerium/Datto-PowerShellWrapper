<#
    .SYNOPSIS
        Pester tests for functions in the "BaseURI.ps1" file

    .DESCRIPTION
        Pester tests for functions in the "BaseURI.ps1" file which
        is apart of the DattoAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1

        Runs a pester test against "BaseURI.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1 -Output Detailed

        Runs a pester test against "BaseURI.Tests.ps1" and outputs detailed test results.

    .NOTES
        Build out more robust, logical, & scalable pester tests.
        Look into BeforeAll as it is not working as expected with this test

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
#>

#Requires -Version 5.0
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }
#Requires -Modules @{ ModuleName='DattoAPI'; ModuleVersion='1.0.0' }

# General variables
    $FullFileName = $MyInvocation.MyCommand.Name
    #$ThisFile = $PSCommandPath -replace '\.Tests\.ps1$'
    #$ThisFileName = $ThisFile | Split-Path -Leaf


Describe " Testing [ *-DattoBaseURI } functions with [ $FullFileName ]" {

    Context "[ Add-DattoBaseURI ] testing functions" {

        It "[ Add-DattoBaseURI ] without parameter should return a valid URI" {
            Add-DattoBaseURI
            Get-DattoBaseURI | Should -Be 'https://api.datto.com/v1/bcdr'
        }

        It "[ Add-DattoBaseURI ] should accept a value from the pipeline" {
            'https://celerium.org' | Add-DattoBaseURI
            Get-DattoBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-DattoBaseURI ] with parameter -base_uri should return a valid URI" {
            Add-DattoBaseURI -base_uri 'https://celerium.org'
            Get-DattoBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-DattoBaseURI ] with parameter -data_center US should return a valid URI" {
            Add-DattoBaseURI -data_center 'US'
            Get-DattoBaseURI | Should -Be 'https://api.datto.com/v1/bcdr'
        }

        It "[ Add-DattoBaseURI ] a trailing / from a base_uri should be removed" {
            Add-DattoBaseURI -base_uri 'https://celerium.org/'
            Get-DattoBaseURI | Should -Be 'https://celerium.org'
        }
    }

    Context "[ Get-DattoBaseURI ] testing functions" {

        It "[ Get-DattoBaseURI ] should return a valid URI" {
            Add-DattoBaseURI
            Get-DattoBaseURI | Should -Be 'https://api.datto.com/v1/bcdr'
        }

        It "[ Get-DattoBaseURI ] value should be a string" {
            Add-DattoBaseURI
            Get-DattoBaseURI | Should -BeOfType string
        }
    }

    Context "[ Remove-DattoBaseURI ] testing functions" {

        It "[ Remove-DattoBaseURI ] should remove the variable" {
            Add-DattoBaseURI
            Remove-DattoBaseURI
            $Datto_Base_URI | Should -BeNullOrEmpty
        }
    }

}