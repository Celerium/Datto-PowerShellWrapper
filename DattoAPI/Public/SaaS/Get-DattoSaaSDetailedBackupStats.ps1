function Get-DattoSaaSDetailedBackupStats {
<#
    .SYNOPSIS
        Get Datto SaaS protection detailed backup stats for a given customer

    .DESCRIPTION
        The Get-DattoSeat cmdlet gets Datto SaaS protection detailed backup stats
        for a given customer

    .PARAMETER saasCustomerId
        Defines the id of the Datto SaaS organization

    .EXAMPLE
        Get-DattoSaaSDetailedBackupStats -saasCustomerId "123456"

        Gets the Datto SaaS protection detailed backup stats from the define customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSaaSDetailedBackupStats.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [int]$saasCustomerId
    )

    begin {

        $resource_uri = "/saas/$saasCustomerId/detailedBackupStats"

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_SaaSBackupStatsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}
}
