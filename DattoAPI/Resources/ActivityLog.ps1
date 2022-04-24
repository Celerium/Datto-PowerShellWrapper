function Get-DattoActivityLog {
<#
    .SYNOPSIS
        Gets a filtered list of activity logs ordered by date

    .DESCRIPTION
        The Get-DattoActivityLog cmdlet gets a filtered list of activity logs ordered by date

    .PARAMETER clientName
        Defines a client name with which to do a partial/prefix match

        2022-04: Filter does not not return any results

    .PARAMETER  user
        Defines a username with which to do a partial/prefix match

    .PARAMETER since
        Defines the number of days (unless overridden with sinceUnits), up until now, for which to produce logs

        Default value : 1

    .PARAMETER sinceUnits
        Defines the units to use for the since filter

        Available values : days, hours, minutes

        Default value : days

    .PARAMETER target
        Defines a comma-separated array of targetType:targetId tuples

        Example: bcdr-device:D05099DC4835

        2022-04: Only works with 1 item in the array right now (See Notes)

    .PARAMETER targetType
        Defines the type of target for which to find activity logs

        Example : bcdr-device

    .PARAMETER page
        Defines the page number to return.

        The default value is 1

    .PARAMETER pageSize
        Defines the amount of items to return with each page.

        The default value is 100

    .EXAMPLE
        Example Response Body:

    {
        "pagination": {
            "page": 0,
            "perPage": 0,
            "totalPages": 0,
            "count": 0
    },
    "items": [
            {
            "timestamp": "2018-08-28T19:00:16+00:00",
            "requestId": "device-web.123555-2343",
            "targetType": "bcdr-device",
            "targetId": "A56E78CC098A",
            "targetDisplayName": "WIN-SRV-03",
            "clientName": "Pawnee City",
            "interface": "Portal",
            "user": "testsubj@example.com",
            "userRoles": [
                "security"
            ],
            "ipAddress": "192.168.0.1",
            "action": "protectedSystem.deleted",
            "messageEN": "Agent xyx123 was removed from the device",
            "success": true
            }
        ]
    }

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
        Get-DattoActivityLog  -since 30 -sinceUnits days -page 2 -pageSize 10

        Gets the Datto BCDR platform activity logs from the past 30 day.

        Returns the second page of 10 items.

    .NOTES
        clientName does not appear to be a working filter for this endpoint (2022-04)
        Cannot get the filter to returned data when run from Datto's own portal as well.

        Need to figure out how to get the target parameter to accept more then 1 item in an array
        For right now I am forcing it to only take the first item in the array

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://portal.dattobackup.com/integrations/xml
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$clientName,

        [Parameter(ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$user,

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$since,

        [Parameter(ParameterSetName = 'index')]
        [validateSet('days', 'hours', 'minutes')]
        [string]$sinceUnits,

        [Parameter(ParameterSetName = 'index', ValueFromPipeline = $true)]
        [string[]]$target,

        [Parameter(ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$targetType,

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$pageSize = 100
    )

    Set-Variable -Name TestTarget -Value $target -Scope global -Force

    $Datto_Report_URI = $Datto_Base_URI -replace '/bcdr',''

    $resource_uri = "/report/activity-log"

    $body = @{}

    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($clientName) {
            $body += @{'clientName' = $clientName}
        }
        if ($user) {
            $body += @{'user' = $user}
        }
        if ($since) {
            $body += @{'since' = $since}
        }
        if ($sinceUnits) {
            $body += @{'sinceUnits' = $sinceUnits}
        }
        if ($target) {
            $body += @{'target' = $target[0]} #2022-04-temp fix
        }
        if ($targetType) {
            $body += @{'targetType' = $targetType}
        }
        if ($page) {
            $body += @{'_page' = $page}
        }
        if ($pageSize) {
            $body += @{'_perPage' = $pageSize}
        }
    }

    Set-Variable -Name TestBody -Value $body -Scope global -Force

    try {
        if ($null -eq $Datto_Public_Key -or $null -eq $Datto_Secret_Key) {
            throw "The Datto API keys are not set. Run Add-DattoAPIKey to set the API keys."
        }

        $Datto_Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Datto_Public_Key, $Datto_Secret_Key
        $Credentials = Get-Credential $Datto_Credentials

        $rest_output = Invoke-RestMethod    -method 'GET' -uri ( $Datto_Report_URI + $resource_uri ) -headers $Datto_Headers -Credential $Credentials `
            -body $body -ErrorAction Stop -ErrorVariable web_error
    }
    catch {
        Write-Error $_
    }
    finally {}

    $data = @{}
    $data = $rest_output
    return $data
}
