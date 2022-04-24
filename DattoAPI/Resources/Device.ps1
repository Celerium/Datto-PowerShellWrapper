function Get-DattoDevice {
<#
    .SYNOPSIS
        Gets Datto BCDR devices from the the Datto API.

    .DESCRIPTION
        The Get-DattoDevice cmdlet gets Datto BCDR devices from the the Datto API.

    .PARAMETER serialNumber
        Defines the device's serial number

        The parameter is mandatory if you want to get a specific device.

    .PARAMETER showHiddenDevices
        Whether hidden devices should be included in your results

        Acceptable values are:
            '0', '1'

        By default '1' is returned by the API which shows hidden devices.

    .PARAMETER showChildResellerDevices
        Whether child reseller devices should be included in your results

        Acceptable values are:
            '0', '1'

        By default '1' is returned by the API which shows child reseller devices.

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
            "serialNumber": "string",
            "name": "string",
            "model": "string",
            "lastSeenDate": "string",
            "clientCompanyName": "string",
            "hidden": true,
            "servicePlan": "string",
            "registrationDate": "string",
            "servicePeriod": "string",
            "warrantyExpire": "string",
            "localStorageUsed": {
                "size": 0,
                "units": "string"
            },
            "localStorageAvailable": {
                "size": 0,
                "units": "string"
            },
            "offsiteStorageUsed": {
                "size": 0,
                "units": "string"
            },
            "internalIP": "string",
            "activeTickets": 0,
            "resellerCompanyName": "string",
            "agentCount": 0,
            "shareCount": 0,
            "alertCount": 5,
            "uptime": 0,
            "remoteWebUrl": "string"
            }
        ]
    }

    .EXAMPLE
        Get-DattoDevice

        Gets the first 100 Datto BCDR devices with any hidden or child reseller devices.

    .EXAMPLE
        Get-DattoDevice -showHiddenDevices 0 -showChildResellerDevices 0

        Gets the first 100 Datto BCDR devices without any hidden or child reseller devices.

    .EXAMPLE
        Get-DattoDevice -page 2 -pageSize 10

        Gets the first 10 Datto BCDR devices from the second page.
        Hidden and child reseller devices will be included.

    .NOTES
        Setting some parameters to an [INT] causes them to not be added to the body. (Show*Devices)
        Documentation around the Show* endpoints just defines that an integer is accepted.
            In testing only 0 or 1 appear to do anything.

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://portal.dattobackup.com/integrations/xml
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(ParameterSetName = 'indexByDevice', Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet('0','1')]
        [string]$showHiddenDevices,

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet('0','1')]
        [string]$showChildResellerDevices,

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$pageSize = 100
    )

    if ($serialNumber){
        $resource_uri = "/device/$serialNumber"
    }
    else{
        $resource_uri = "/device"
    }

    $body = @{}

    if (($PSCmdlet.ParameterSetName -eq 'index') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByDevice')) {

        if ($serialNumber) {
            $body += @{'serialNumber' = $serialNumber}
        }
        if ($showHiddenDevices) {
            $body += @{'showHiddenDevices' = $showHiddenDevices}
        }
        if ($showChildResellerDevices) {
            $body += @{'showChildResellerDevices' = $showChildResellerDevices}
        }
        if ($page) {
            $body += @{'_page' = $page}
        }
        if ($pageSize) {
            $body += @{'_perPage' = $pageSize}
        }
    }

    try {
        if ($null -eq $Datto_Public_Key -or $null -eq $Datto_Secret_Key) {
            throw "The Datto API keys are not set. Run Add-DattoAPIKey to set the API keys."
        }

        $Datto_Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Datto_Public_Key, $Datto_Secret_Key
        $Credentials = Get-Credential $Datto_Credentials

        $rest_output = Invoke-RestMethod    -method 'GET' -uri ( $Datto_Base_URI + $resource_uri ) -headers $Datto_Headers -Credential $Credentials `
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
