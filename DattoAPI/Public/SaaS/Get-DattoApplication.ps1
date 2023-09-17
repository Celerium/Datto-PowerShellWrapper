function Get-DattoApplication {
<#
    .SYNOPSIS
        Get Datto SaaS protection backup data for a given customer

    .DESCRIPTION
        The Get-DattoApplication cmdlet gets Datto SaaS protection
        backup data for a given customer

    .PARAMETER saasCustomerId
        Defines the id of the customer to get SaaS information from

        The parameter is mandatory

    .EXAMPLE
        Get-DattoApplication -saasCustomerId "12345678"

        Gets the Datto SaaS protection backup data from the define customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoApplication.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$saasCustomerId
    )

    begin {

        $resource_uri = "/saas/$saasCustomerId/applications"

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_applicationParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}
}
