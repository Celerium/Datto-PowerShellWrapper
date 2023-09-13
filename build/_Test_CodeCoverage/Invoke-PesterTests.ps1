<#
    .SYNOPSIS
        Invoke Pester tests against all functions in a module

    .DESCRIPTION
        Invoke Pester tests against all functions in a module

        Also tests code coverage

    .PARAMETER moduleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'built', 'notBuilt'

    .EXAMPLE
        Invoke-PesterTests -moduleName DattoAPI -Version 1.2.3

        Runs various pester tests against all functions in the module
        and outputs the results to the console as well as creates
        code coverage files.

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

    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$version = '2.1.0',

    [Parameter(Mandatory=$false)]
    [string[]]$ExcludeTag = 'PLACEHOLDER',

    [Parameter(Mandatory=$false)]
    [Switch]$CodeCoverage,

    [Parameter(Mandatory=$false)]
    [Switch]$TestResult
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

try {

    $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\build')) )"
    $modulePath_UnBuilt = "$rootPath\$moduleName"
    $modulePath_Built = "$rootPath\build\versions\$moduleName\$version"
    $testPath = "$rootPath\Tests"

    #$pester_TestName = (Get-Item -Path $PSCommandPath).Name
    #$commandName = $pester_TestName -replace '.Tests.ps1',''

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Prerequisites ]

#Region     [ Files ]

$import_Tests = Get-ChildItem -Path $testPath -Filter "*.ps1" -Recurse | Sort-Object FullName
$import_Functions = Get-ChildItem -Path $modulePath_UnBuilt -Filter "*.ps1" -Recurse | Sort-Object FullName

#EndRegion  [ Files ]

#Region     [ Pester Configuration ]

#$pester_defaultConfig   = New-PesterConfiguration
#Set-Variable -Name test_defaultConfig -Value $pester_defaultConfig -Scope Global -Force

$pester_Container = New-PesterContainer -Path $($test.FullName) -Data @{ 'moduleName' = $moduleName; 'Version' = $Version }

$pester_Options = @{

    Run = @{
        Container = $pester_Container
        #Path = "$rootPath\Tests\Private\apiKeys\*.Tests.ps1"
        PassThru = $true
    }

    Filter = @{
        ExcludeTag = $ExcludeTag
    }

    <#
    CodeCoverage = @{
        Enabled = $false
        OutputFormat = 'JaCoCo'
        OutputPath = ".\build\Code Coverage\$($test.BaseName)_Coverage.xml"
        OutputEncoding = 'UTF8'
        #Path = ".\DattoAPI\Private\apiKeys\*.ps1"
        Path = $( $($import_Functions | Where-Object {$_.FullName -eq $test.FullName}).FullName )
        UseBreakpoints = $false
    }
    #>
    TestResult = @{
        Enabled = $true
        OutputFormat = 'NUnitXml'
        OutputPath = ".\build\Code Coverage\$($test.BaseName)_Results.xml"
        OutputEncoding = 'UTF8'
    }

    Output = @{
        Verbosity = 'Detailed'
    }

}

    $pester_Configuration = New-PesterConfiguration -Hashtable $pester_Options

#EndRegion  [ Pester Configuration ]

#Region     [ Pester Invoke ]

$pester_Results = Invoke-Pester -Configuration $pester_Configuration
Set-Variable -Name Test_pester_Results -Value $pester_Results -Scope Global -Force

#EndRegion  [ Pester Invoke ]

