function Get-DattoActivityLog {
<#
    .SYNOPSIS
        Gets a filtered list of activity logs ordered by date

    .DESCRIPTION
        The Get-DattoActivityLog cmdlet gets a filtered list of activity logs ordered by date

    .PARAMETER clientName
        Defines a client name with which to do a partial/prefix match

        2022-04: Filter does not appear to work

    .PARAMETER since
        Defines the number of days (unless overridden with sinceUnits), up until now,
        for which to produce logs

        Default value : 1

    .PARAMETER sinceUnits
        Defines the units to use for the since filter

        Available values : days, hours, minutes

        Default value : days

    .PARAMETER target
        Defines a comma-separated array of targetType:targetId tuples

        Example: bcdr-device:DC1234DC1234

        2022-04: Only works with 1 item in the array right now (See Notes)

    .PARAMETER targetType
        Defines the type of target for which to find activity logs

        Example : bcdr-device

    .PARAMETER  user
        Defines a username with which to do a partial/prefix match

    .PARAMETER page
        Defines the page number to return

        The default value is 1

    .PARAMETER perPage
        Defines the amount of items to return with each page

        The default value is 100

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Get-DattoActivityLog

        Gets the Datto BCDR platform activity logs from the past day.

    .EXAMPLE
        Get-DattoActivityLog -since 7 -sinceUnits days

        Gets the Datto BCDR platform activity logs from the past 7 day.

    .EXAMPLE
        Get-DattoActivityLog -user bob -since 7 -sinceUnits days

        Gets the Datto BCDR platform activity logs for the user named bob from the past 7 day.

    .EXAMPLE
        Get-DattoActivityLog -since 30 -sinceUnits days -target 'bcdr-device:D0123456789','bcdr-device:D9876543210'

        Gets the Datto BCDR platform activity logs from the defined targets for the past 30 day.

    .EXAMPLE
        Get-DattoActivityLog -since 30 -sinceUnits days -page 2 -pageSize 10

        Gets the Datto BCDR platform activity logs from the past 30 day.

        Returns the second page of 10 items.

    .NOTES
        As of 2022-04 the clientName parameter does not appear to be a working filter for this endpoint
            Cannot get the filter to returned data when run from Datto's own portal as well.

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Reporting/Get-DattoActivityLog.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$clientName,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$since = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [validateSet('days', 'hours', 'minutes')]
        [string]$sinceUnits = 'days',

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [string[]]$target,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$targetType,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$user,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [switch]$allPages
    )

    begin{

        $resource_uri = "/report/activity-log"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_activityLogParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
