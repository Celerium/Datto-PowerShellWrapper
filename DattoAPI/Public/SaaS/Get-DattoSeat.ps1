function Get-DattoSeat {
<#
    .SYNOPSIS
        Get Datto SaaS protection seats for a given customer

    .DESCRIPTION
        The Get-DattoSeat cmdlet gets Datto SaaS protection seats
        for a given customer

    .PARAMETER saasCustomerId
        Defines the id of the Datto SaaS organization

    .EXAMPLE
        Get-DattoSeat -saasCustomerId "123456"

        Gets the Datto SaaS protection seats from the define customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSeat.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [int]$saasCustomerId
    )

    begin {

        $resource_uri = "/saas/$saasCustomerId/seats"

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_seatParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}
}
