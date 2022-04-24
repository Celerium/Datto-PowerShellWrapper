<#
    .SYNOPSIS
        Pester tests for functions in the "APIKey.ps1" file

    .DESCRIPTION
        Pester tests for functions in the APIKey.ps1 file which
        is apart of the DattoAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\APIKey.Tests.ps1

        Runs a pester test against "APIKey.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\APIKey.Tests.ps1 -Output Detailed

        Runs a pester test against "APIKey.Tests.ps1" and outputs detailed test results.

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


Describe "Testing [ *-DattoAPIKey ] functions with [ $FullFileName ]" {

    Context "[ Add-DattoAPIKey ] testing functions" {

        It "The Datto_Public_Key variable should initially be empty or null" {
            $Datto_Public_Key | Should -BeNullOrEmpty
        }

        It "The Datto_Secret_Key variable should initially be empty or null" {
            $Datto_Secret_Key | Should -BeNullOrEmpty
        }

        It "[ Add-DattoAPIKey ] should accept a value from the pipeline" {
            "DattoApiKey" | Add-DattoAPIKey -Api_Key_Public '12345'
            Get-DattoAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ Add-DattoAPIKey ] called with parameter -Api_Key_Public & -Api_Key_Secret should not be empty" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Get-DattoAPIKey | Should -Not -BeNullOrEmpty
        }
    }

    Context "[ Get-DattoAPIKey ] testing functions" {

        It "[ Get-DattoAPIKey ] should return a value" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Get-DattoAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ Get-DattoAPIKey ] -Public_Only should only return the public value" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Get-DattoAPIKey -Public_Only | Should -be '12345'
        }

        It "[ Get-DattoAPIKey ] -Secret_Only should only return the secret SecureString" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Get-DattoAPIKey -Secret_Only | Should -BeOfType SecureString
        }

        It "[ Get-DattoAPIKey ] public key should be a String (From PipeLine)" {
            "DattoApiKey" | Add-DattoAPIKey -Api_Key_Public '12345'
            (Get-DattoAPIKey).PublicKey | Should -BeOfType String
        }

        It "[ Get-DattoAPIKey ] secret key should be a SecureString (With Parameter)" {
            "DattoApiKey" | Add-DattoAPIKey -Api_Key_Public '12345'
            (Get-DattoAPIKey).SecretKey | Should -BeOfType SecureString
        }

        It "[ Get-DattoAPIKey ] public key should be a String (With Parameter)" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            (Get-DattoAPIKey).PublicKey | Should -BeOfType String
        }

        It "[ Get-DattoAPIKey ] secret key should be a SecureString (With Parameter)" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            (Get-DattoAPIKey).SecretKey | Should -BeOfType SecureString
        }
    }

    Context "[ Remove-DattoAPIKey ] testing functions" {

        It "[ Remove-DattoAPIKey ] should remove the Datto_API_Key variables" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Remove-DattoAPIKey
            $Datto_Public_Key | Should -BeNullOrEmpty
            $Datto_Secret_Key | Should -BeNullOrEmpty
        }
    }

    Context "[ Test-DattoAPIKey ] testing functions" {

        It "[ Test-DattoAPIKey ] without an API key should fail to authenticate" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Remove-DattoAPIKey
            $Value = Test-DattoAPIKey
            $Value.Message | Should -BeLike '*keys are not*'
        }
    }

}