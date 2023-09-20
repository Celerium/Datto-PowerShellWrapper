function Get-DattoBulkSeatAssignment {
<#
    .SYNOPSIS
        Get SaaS Protection bulk seats assignment

    .DESCRIPTION
        The Get-DattoBulkSeatAssignment cmdlet get SaaS Protection
        bulk seats assignment

    .PARAMETER saasCustomerId
        Defines the id of the customer to get SaaS information from

    .PARAMETER externalSubscriptionId
        Defines the external Subscription Id of the customer to
        get SaaS bulk seat information from

    .EXAMPLE
        Get-DattoBulkSeatAssignment -saasCustomerId "12345678" -externalSubscriptionId 'ab23-bdf234-1234-asdf'

        Gets the Datto SaaS protection seats from the define customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoBulkSeatAssignment.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$saasCustomerId,

        [Parameter(Mandatory = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$externalSubscriptionId
    )

    begin {

        $resource_uri = "/saas/$saasCustomerId/$externalSubscriptionId/bulkSeatAssignment"

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_bulkSeatParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}
}
