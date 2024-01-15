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
        Set-DattoBulkSeatAssignment -saasCustomerId "12345678" -externalSubscriptionId 'Classic:Office365:123456' -seatType "User" -remoteId "ab23-bdf234-1234-asdf" -actionType "License"

        Sets the Datto SaaS protection seats from the defined Office365 customer id

    .EXAMPLE
        Set-DattoBulkSeatAssignment -saasCustomerId "12345678" -externalSubscriptionId 'Classic:GoogleApps:123456' -seatType "SharedDrive" -remoteId "ab23-bdf234-1234-asdf" -actionType "Pause"

        Sets the Datto SaaS protection seats from the defined Google customer id

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
        [string]$externalSubscriptionId,

        # Parameter help description
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'index'
            )]
        [ValidateNotNullOrEmpty()]
        [string]$seatType,
        
        # Valid methods are 'License' to "Protect", 'Pause' to "Pause", and 'Unlicense' to "Unprotect"
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'index'
            )]
        [ValidateSet('License','Pause','Unlicense')]
        [ValidateNotNullOrEmpty()]
        [string]$actionType,

        # Either like 'Classic:Office365:123456', or 'Classic:GoogleApps:123456'
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'index'
            )]
        [ValidateNotNullOrEmpty()]
        [string[]]$remoteId
    )

    begin {

        $resource_uri = "/saas/$saasCustomerId/$externalSubscriptionId/bulkSeatChange"

        $requestBody = @{
            seat_type = $seatType
            action_type = $actionType
            ids = $remoteId
            }

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_bulkSeatParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method PUT -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -data $requestBody

    }

    end {}
}