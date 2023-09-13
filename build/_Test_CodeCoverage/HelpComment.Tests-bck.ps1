<#
    .SYNOPSIS
        Pester tests for the DattoAPI module manifest file.

    .DESCRIPTION
        Pester tests for the DattoAPI module manifest file.


    .PARAMETER moduleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'built', 'notBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\apiKeys\Get-DattoAPIKey.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\apiKeys\Get-DattoAPIKey.Tests.ps1 -Output Detailed

        Runs a pester test and outputs detailed results

    .INPUTS
        N\A

    .OUTPUTS
        N\A

    .NOTES
        Build out more robust, logical, & scalable pester tests.
        Huge thank you to LazyWinAdmin, Vexx32, & JeffBrown for their blog posts!

    .LINK
        https://celerium.org

    .LINK
        https://vexx32.github.io/2020/07/08/Verify-Module-Help-Pester/
        https://lazywinadmin.com/2016/05/using-pester-to-test-your-comment-based.html
        https://jeffbrown.tech/getting-started-with-pester-testing-in-powershell/
        https://github.com/Celerium/Datto-PowerShellWrapper

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

    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$version = '2.1.0',

    [Parameter(Mandatory=$false)]
    [ValidateSet('built','notBuilt')]
    [string]$buildTarget
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        $pester_TestName = (Get-Item -Path $PSCommandPath).Name
        $commandName = $pester_TestName -replace '.Tests.ps1',''

        switch ($buildTarget){
            'built'     { $modulePath = "$rootPath\build\$moduleName\$version" }
            'notBuilt'  { $modulePath = "$rootPath\$moduleName" }
        }

        Import-Module -Name "$modulePath\$moduleName.psd1" -ErrorAction Stop -ErrorVariable moduleError *> $null

        $module = Get-Module $moduleName
        $moduleFunctions = @(
                                $Module.ExportedFunctions.Keys
                                $Module.ExportedCmdlets.Keys
                            )

    }

#Available inside It but NOT Describe or Context
    BeforeAll {

        $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"

        switch ($buildTarget){
            'built'     { $modulePath = "$rootPath\build\$moduleName\$version" }
            'notBuilt'  { $modulePath = "$rootPath\$moduleName" }
        }

        if (Get-Module -Name $moduleName){
            Remove-Module -Name $moduleName -Force
        }

        Import-Module -Name "$modulePath\$moduleName.psd1" -ErrorAction Stop -ErrorVariable moduleError *> $null

        #$Module = Get-Module -Name $moduleName | Select-Object * -ExcludeProperty Definition
        #$moduleFunctions = Get-ChildItem -Path $modulePath -File -Recurse

        if ($moduleError){
            $moduleError
            exit 1
        }

    }

    AfterAll{

        if (Get-Module -Name $moduleName){
            Remove-Module -Name $moduleName -Force
        }

    }

#EndRegion  [ Prerequisites ]

Describe "Testing the [ $buildTarget ] version of [ $moduleName ] with [ $pester_TestName ]" {

    Context "[ <functionName> ]" -ForEach $moduleFunctions {

        BeforeAll {
            # Renaming the automatic $_ variable to $functionName to make it easier to work with
            $functionName = $_
            $ShouldProcessParameters = 'WhatIf', 'Confirm'
        }

        BeforeEach {

            $help_Function = Get-Help -Name $functionName -Full

            # Look into [ Get-Help : No parameter matches criteria * ] error on some commands
            $help_Parameters = [System.Collections.Generic.List[object]]::new()
            Get-Help -Name $functionName -Parameter * -ErrorAction Ignore |
                Where-Object { $_.Name -and $_.Name -notin $ShouldProcessParameters } |
                    ForEach-Object {
                        $data = [PSCustomObject]@{
                            name            = $_.name
                            description     = $_.description.Text
                            defaultValue    = $_.defaultValue
                            parameterValue  = $_.parameterValue
                            type            = $_.type
                            required        = $_.required
                            globbing        = $_.globbing
                            pipelineInput   = $_.pipelineInput
                            position        = $_.position
                        }
                        $help_Parameters.Add($data) > $null
                }

                #PowerShell Abstract Syntax Tree \ will be $null if the command is a compiled cmdlet
                #https://vexx32.github.io/2020/07/08/Verify-Module-Help-Pester/
                $help_Ast = @{
                    Ast        = (Get-Content -Path "function:\$functionName" -ErrorAction Ignore).Ast
                    Parameters = $help_Parameters
                }

                $help_Examples = [System.Collections.Generic.List[object]]::new()
                $help_Function.Examples.Example |
                    ForEach-Object {
                        $data = [PSCustomObject]@{
                            introduction    = $_.introduction
                            code            = $_.code
                            remarks         = $_.remarks
                            title           = $_.title -replace '-',''
                        }
                        $help_Examples.Add($data) > $null
                    }

        }

        It "[ <functionName> ] contains comment based help" {
            $help_Function | Should -Not -BeNullOrEmpty
        }

        It "[ <functionName> ] contains a synopsis" {
            $help_Function.Synopsis | Should -Not -BeNullOrEmpty
        }

        It "[ <functionName> ] contains a description" {
            $help_Function.Description | Should -Not -BeNullOrEmpty
        }

        It "[ <functionName> ] contains an example" {
            $help_Function.Examples | Should -Not -BeNullOrEmpty
        }

        It "[ <functionName> ] contains a note" {
            $help_Function.alertSet.alert.text -split '\n' | Should -Not -BeNullOrEmpty
            #$Notes[0].Trim() | Should -Not -BeNullOrEmpty
        }

        It "[ <functionName> ] contains a link" {
            $help_Function.relatedLinks.navigationLink.uri| Should -Not -BeNullOrEmpty
        }

        # This will be skipped for compiled commands ($help_Ast.Ast will be $null)
        It "[ <functionName> ] has a help entry for all parameters" -Skip:(-not ($help_Parameters -and $help_Ast.Ast) ) {
            @($help_Parameters).Count | Should -Be $help_Ast.Ast.Body.ParamBlock.Parameters.Count -Because 'the number of parameters in the help should match the number in the function script'
        }

        # -<Name> is a pester variable
        It "[ <functionName> ] has a description for parameter [ -<Name> ]" -Skip:(-not $help_Parameters) {
            $Description | Should -Not -BeNullOrEmpty -Because "parameter $Name should have a description"
        }

        It "[ <functionName> ] has at least one usage example" {
            $help_Examples.count | Should -BeGreaterOrEqual 1
        }

        Context "[ <functionName> ] Example code & descriptions" -ForEach $help_Examples {

            BeforeAll {
                # Renaming the automatic $_ variable to $functionHelp to make it easier to work with
                $functionHelp = $_
            }

            # <title> is a pester variable
            It "[ <functionName> ] lists example code & description for: [ <functionHelp.title> ]" {
                $functionHelp.code | Should -Not -BeNullOrEmpty -Because "[ $($functionHelp.title) ] should have example code!"
                $functionHelp.Remarks | Should -Not -BeNullOrEmpty -Because "[ $($functionHelp.title) ] should have a description!"
            }

        }

        # <title> is a pester variable
        #It "[ <functionName> ] lists a description for: [ <help_Examples.Title> ]" {
        #    $help_Examples.Remarks | Should -Not -BeNullOrEmpty -Because "example $($help_Examples.Title) should have a description!"
        #}

    }
}