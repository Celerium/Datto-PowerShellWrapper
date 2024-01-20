function Set-DattoBulkSeatChange {
<#
    .SYNOPSIS
        Sets Datto SaaS Protection bulk seat changes

    .DESCRIPTION
        The Set-DattoBulkSeatChange cmdlet is used to set SaaS Protection bulk seat changes

    .PARAMETER saasCustomerId
        Defines the id of the Organization to set SaaS information from

    .PARAMETER externalSubscriptionId
        Defines the external Subscription ID of the SaaS Protection Organization used to set SaaS bulk seat changes

    .EXAMPLE
        Set-DattoBulkSeatChange -saasCustomerId "12345678" -externalSubscriptionId 'Classic:Office365:123456' -seatType "User" -remoteId "ab23-bdf234-1234-asdf" -actionType "License"

        Sets the Datto SaaS protection seats from the defined Office365 customer id

    .EXAMPLE
        Set-DattoBulkSeatChange -saasCustomerId "12345678" -externalSubscriptionId 'Classic:GoogleApps:123456' -seatType "SharedDrive" -remoteId "ab23-bdf234-1234-asdf","cd45-cfe567-5678-qwer" -actionType "Pause"

        Sets the Datto SaaS protection seats from the defined Google customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Set-DattoBulkSeatChange.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index', SupportsShouldProcess = $true)]
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

        if ($PSCmdlet.ShouldProcess("saasCustomerId: $saasCustomerId, externalSubscriptionId: $externalSubscriptionId, $remoteId", "$actionType $seatType")) {
            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
            Set-Variable -Name 'Datto_bulkSeatParameters' -Value $PSBoundParameters -Scope Global -Force

            Invoke-DattoRequest -method PUT -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -data $requestBody
        }

    }

    end {}
}