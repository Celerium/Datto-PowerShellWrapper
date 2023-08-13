function Get-DattoSaaS {
<#
    .SYNOPSIS
        Gets Datto SaaS protection data

    .DESCRIPTION
        The Get-DattoSaaS cmdlet gets Datto SaaS protection data by combing all endpoints
        into a single command.

        This unique function does not contain any BCDR or Reporting endpoints. This function
        was added to simply testing & generating reports

    .PARAMETER endpoint_Domains
        Returns SaaS protection data about what domains are being protected

        Endpoint = /SaaS/domains

    .PARAMETER endpoint_CustomerSeats
        Returns SaaS protection seats for a given customer

        Endpoint = /SaaS/domains/{sassCustomerId}/seats

    .PARAMETER endpoint_CustomerApps
        Returns SaaS protection backup data for a given customer

        Endpoint = /SaaS/domains/{sassCustomerId}/applications

    .PARAMETER saasCustomerId
        Defines the id of the customer to get SaaS information from

        The parameter is mandatory

    .EXAMPLE
        Get-DattoSaaS

        Returns SaaS protection data about what domains are being protected

        This function uses the -endpoint_Domains switch by default

    .EXAMPLE
        Get-DattoSaaS -endpoint_CustomerSeats -saasCustomerId 12345678

        Returns SaaS protection seats for a given customer

    .EXAMPLE
        Get-DattoSaaS -endpoint_CustomerApps -saasCustomerId 12345678

        Returns SaaS protection backup data for a given customer

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSaaS.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index_Domains')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index_Domains')]
        [switch]$endpoint_Domains,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byCustomerSeats')]
        [switch]$endpoint_CustomerSeats,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byCustomerApps')]
        [switch]$endpoint_CustomerApps,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byCustomerSeats' )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byCustomerApps'  )]
        [ValidateNotNullOrEmpty()]
        [string]$saasCustomerId
    )

    begin{

        switch ($PSCmdlet.ParameterSetName) {
            'index_Domains'         { $resource_uri = "/saas/domains" }
            'index_byCustomerSeats' { $resource_uri = "/saas/$saasCustomerId/seats" }
            'index_byCustomerApps'  { $resource_uri = "/saas/$saasCustomerId/applications" }
        }

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_bcdrParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end{}

}
