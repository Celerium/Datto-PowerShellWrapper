function Set-DattoBulkSeatAssignment {
<#
    .SYNOPSIS
        Set SaaS Protection bulk seats assignment

    .DESCRIPTION
        The Set-DattoBulkSeatAssignment cmdlet sets SaaS Protection
        bulk seats assignment

    .PARAMETER saasCustomerId
        Defines the id of the customer to set SaaS information from

    .PARAMETER externalSubscriptionId
        Defines the external Subscription Id of the customer to
        set SaaS bulk seat information from

    .EXAMPLE
        Set-DattoBulkSeatAssignment -saasCustomerId "12345678" -externalSubscriptionId 'Classic:Office365:123456'

        Sets the Datto SaaS protection seats from the define customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Set-DattoBulkSeatAssignment.html
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

        Invoke-DattoRequest -method PUT -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}
}
