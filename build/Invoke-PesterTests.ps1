

<#
#Invoke from external source
$Container = New-PesterContainer -Path '.\Tests\Private\APIKey.Tests.ps1' -Data @{ 'Api_Key' = '12344' }
Invoke-Pester -Container $Container -Output Detailed -TagFilter Add

#Code Coverage
$ContainerCC = New-PesterContainer -Path '.\Tests\Private\APIKey.Tests.ps1'
Invoke-Pester -Container $ContainerCC -Output Detailed -TagFilter Add
#>

#$PesterPreference = [PesterConfiguration]::Default
#$PesterPreference.CodeCoverage.Enabled = $true

#$pester_Configuration = New-PesterConfiguration
#$pester_Configuration.CodeCoverage.Enabled = $true
#$pester_Configuration.CodeCoverage.OutputPath = '.\ApiKey_Coverage.xml'
#$pester_Configuration.CodeCoverage.OutputEncoding = 'utf8'
#$pester_Configuration.CodeCoverage.OutputFormat = 'JaCoCo'

<#
$Test_Results = Invoke-Pester -Path .\Tests\Private\APIKey.Tests.ps1 `
                    -CodeCoverage .\DattoAPI\Private\APIKey.ps1 `
                    -CodeCoverageOutputFile '.\ApiKey_Coverage.xml' `
                    -CodeCoverageOutputFileFormat JaCoCo -PassThru
#>

$pester_defaultConfig = New-PesterConfiguration

Set-Variable -Name test_defaultConfig -Value $pester_defaultConfig -Scope Global -Force

$pester_Container = New-PesterContainer -Path '.\Tests\Private\APIKey.Tests.ps1' -Data @{ 'Api_Key' = '12345' }

$pester_Options = @{

    Run = @{
        Container = $pester_Container
        PassThru = $true
    }

    CodeCoverage = @{
        Enabled = $true
        Path = ".\DattoAPI\Private\APIKey.ps1"
        OutputPath = '.\ApiKey_Coverage.xml'
        OutputFormat = 'JaCoCo'
        OutputEncoding = 'UTF8'
    }
    TestResult = @{
        Enabled = $true
        OutputPath = '.\ApiKey_Test.xml'
        OutputFormat = 'NUnitXml'
        OutputEncoding = 'UTF8'
    }

    Output = @{
        Verbosity = 'Detailed'
    }

}

$pester_Configuration = New-PesterConfiguration -Hashtable $pester_Options

$Test_Results = Invoke-Pester -Configuration $pester_Configuration

Set-Variable -Name Test_Results -Value $Test_Results -Scope Global -Force

#$pester_Configuration.Run.Container = $pester_Container

#$Test_Results = Invoke-Pester -Configuration $pester_Configuration

#$Test_Results = Invoke-Pester -Container $pester_Container

#$pester_Configuration = New-PesterConfiguration
#$pester_Configuration.CodeCoverage.Enabled = $true
#$pester_Configuration.CodeCoverage.OutputPath = '.\ApiKey_Coverage.xml'
#$pester_Configuration.CodeCoverage.OutputEncoding = 'utf8'
#$pester_Configuration.CodeCoverage.OutputFormat = 'JaCoCo'




#$Test_Results = Invoke-Pester -Path .\Tests\Private\APIKey.Tests.ps1 - .\DattoAPI\Private\APIKey.ps1 -PassThru
