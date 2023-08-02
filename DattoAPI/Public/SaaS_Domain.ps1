function Get-DattoDomain {
<#
    .SYNOPSIS
        Get Datto SaaS protection data about what domains are being protected

    .DESCRIPTION
        The Get-DattoDomain cmdlet gets SaaS protection data
        about what domains are being protected

    .EXAMPLE
        Get-DattoDomain

        Gets SaaS protection data about what domains are being protected

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
#>

    [CmdletBinding()]
    Param ()

    begin{

        $resource_uri = "/saas/domains"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_domainParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
