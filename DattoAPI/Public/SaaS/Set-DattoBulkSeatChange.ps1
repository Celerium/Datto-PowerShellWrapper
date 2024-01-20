function Set-DattoBulkSeatChange {
<#
    .SYNOPSIS
        Sets Datto SaaS Protection bulk seat changes

    .DESCRIPTION
        The Set-DattoBulkSeatChange cmdlet is used to bulk set SaaS Protection seat changes

    .PARAMETER saasCustomerId
        Defines the id of the Datto SaaS organization

    .PARAMETER externalSubscriptionId
        Defines the external Subscription ID used to set SaaS bulk seat changes

        The externalSubscriptionId can be found by referencing the data returned form Get-DattoApplication

        Example:
            'Classic:Office365:123456'
            'Classic:GoogleApps:123456'

    .PARAMETER seatType
        Defines the seat type to backup

        Example:
            SharedMailbox, Site, TeamSite, User

    .PARAMETER actionType
        Defines what active to take against the seat

        Active:         The seat exists in the organization and is actively backed up, meaning the seat is protected.
        Paused:         The seat exists in the organization; backups were enabled but are currently paused.
        Unprotected:    The seat exists in the organization but backups are not enabled.

        Allowed values:
            License, Pause, Unlicense

    .PARAMETER remoteId
        Defines the target ids to change

        Remote ids can be found by referencing the data returned form Get-DattoApplication

        Example:
            ab23-bdf234-1234-asdf

    .EXAMPLE
        Set-DattoBulkSeatChange -customerId "123456" -externalSubscriptionId 'Classic:Office365:654321' -seatType "User" -actionType License -remoteId "ab23-bdf234-1234-asdf"

        Sets the Datto SaaS protection seats from the defined Office365 customer id

    .EXAMPLE
        Set-DattoBulkSeatChange -customerId "123456" -externalSubscriptionId 'Classic:GoogleApps:654321' -seatType "SharedDrive" -actionType Pause -remoteId "ab23-bdf234-1234-asdf","cd45-cfe567-5678-1234"

        Sets the Datto SaaS protection seats from the defined Google customer id

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Set-DattoBulkSeatChange.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set', SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'set')]
        [ValidateNotNullOrEmpty()]
        [string]$saasCustomerId,

        [Parameter(Mandatory = $true, ParameterSetName = 'set')]
        [ValidateNotNullOrEmpty()]
        [string]$externalSubscriptionId,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'set')]
        [ValidateNotNullOrEmpty()]
        [string]$seatType,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'set')]
        [ValidateSet('License', 'Pause', 'Unlicense')]
        [string]$actionType,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'set')]
        [ValidateNotNullOrEmpty()]
        [string[]]$remoteId
    )

    begin {

        $resource_uri = "/saas/$saasCustomerId/$externalSubscriptionId/bulkSeatChange"

    }

    process {

        $request_Body = @{
            seat_type   = $seatType
            action_type = $actionType
            ids         = $remoteId
        }

        if ($PSCmdlet.ShouldProcess("saasCustomerId: [ $saasCustomerId ], externalSubscriptionId: [ $externalSubscriptionId, $remoteId ]", "actionType: [ $actionType $seatType ]")) {

            Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
            Set-Variable -Name 'Datto_bulkSeatParameters' -Value $PSBoundParameters -Scope Global -Force

            Invoke-DattoRequest -method PUT -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -data $request_Body

        }

    }

    end {}
}