<#
.NOTES
    Copyright 2020-2024 Celerium

    NAME: Publish-CeleriumModule.ps1
    Type: PowerShell

        AUTHOR:  David Schulte
        DATE:    2023-09-11
        EMAIL:   celerium@celerium.org
        Updated:
        Date:

    TODO:

.SYNOPSIS
    Publishes a PowerShell module to the PowerShell Gallery

.DESCRIPTION
    The Update-HelpContent script publishes a PowerShell module
    to the PowerShell Gallery

.PARAMETER moduleName
    The name of the module to update help docs for

    Default value: DattoAPI

.PARAMETER version
    The build version to publish

.PARAMETER NuGetApiKey
    The PowerShell Gallery NuGetApiKey with permissions to
    publish modules

.EXAMPLE
    .\Publish-CeleriumModule.ps1 -Version 1.0.0 -NuGetApiKey 12345 -WhatIf -Verbose

    Shows what will happen if a module is pushed to the PowerShell Gallery

.EXAMPLE
    .\Publish-CeleriumModule.ps1 -Version 1.0.0 -NuGetApiKey 12345 -Verbose

    Publishes a PowerShell module to the PowerShell Gallery

.INPUTS
    N\A

.OUTPUTS
    N\A

.LINK
    https://celerium.org

#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$moduleName = 'DattoAPI',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$version,

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$NuGetApiKey

)

begin {
    $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\build')) )"
    $modulePath = "$rootPath\build\$moduleName\$version"
}

process {

    if ( $($Test = Test-ModuleManifest -Path "$modulePath\$moduleName.psd1" -ErrorAction SilentlyContinue; $?) ) {

        $publish_Params = @{
            Path        = $modulePath
            NuGetApiKey = $NuGetApiKey
            WhatIf      = $WhatIfPreference
        }

        Publish-Module @publish_Params

    }
    else{
        throw "The [ $moduleName ] module failed Test-ModuleManifest"
        Write-Error $_
    }

}

end {}