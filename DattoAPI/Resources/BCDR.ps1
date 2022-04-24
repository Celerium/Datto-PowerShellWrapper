function Get-DattoBCDR {
<#
    .SYNOPSIS
        Gets Datto BCDR devices and assets from the the Datto API.

    .DESCRIPTION
        The Get-DattoBCDR cmdlet gets Datto BCDR devices and assets from the the Datto API.

        This is a special cmdlet that can query all the known endpoints from the Datto API.

        I added this command as it was useful in only needing to run a single command when testing\generating reports

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

    .PARAMETER Asset
        Get Datto BCDR assets (agents and shares) for a given device

    .PARAMETER volumeName
        Gets an asset(s)(agent or share) for a specific volume on a device

    .PARAMETER Share
        Gets Datto BCDR shares for a given device

    .PARAMETER allAgents
        Get Datto BCDR clients and the agents under those clients

        2022-04 - Appears to be a deprecated endpoint.

    .PARAMETER agents
        Get Datto BCDR agents for a given device

    .PARAMETER alert
        Gets Datto BCDR alerts for a given device.

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
        Get-DattoBCDR

        Gets the first 100 Datto BCDR devices with any hidden or child reseller devices.

    .EXAMPLE
        Get-DattoBCDR -showHiddenDevices 0 -showChildResellerDevices 0

        Gets the first 100 Datto BCDR devices without any hidden or child reseller devices.

    .EXAMPLE
        Get-DattoBCDR -serialNumber '12345678' -Asset

        Gets the Datto BCDR with the defined serialNumber and returns any agents or shares.

    .EXAMPLE
        Get-DattoBCDR -serialNumber '12345678' -volumeName 'd0w9876542321'

        Gets the Datto BCDR with the defined serialNumber and returns any agents or shares for the defined volume.

    .EXAMPLE
        Get-DattoBCDR -serialNumber '12345678' -Share

        Gets the Datto BCDR with the defined serialNumber and returns any shares.

    .EXAMPLE
        Get-DattoBCDR -allAgents

        Gets a list of clients and the agents under those clients.

        However this endpoint appears to be deprecated and does not return any data.
        Leaving this here in the event Datto corrects this endpoint.

    .EXAMPLE
        Get-DattoBCDR -serialNumber '12345678' -agents

        Gets the Datto BCDR with the defined serialNumber and returns its agents.

    .EXAMPLE
        Get-DattoBCDR -serialNumber '12345678' -alert

        Gets the Datto BCDR with the defined serialNumber and returns any alerts.

    .EXAMPLE
        Get-DattoBCDR -page 2 -pageSize 10

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
        [Parameter(ParameterSetName = 'indexByDevice',          Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'indexByAsset',           Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'indexByVolume',          Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'indexByShare',           Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'indexByDeviceAgents',    Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'indexByAlert',           Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet('0','1')]
        [string]$showHiddenDevices,

        [Parameter(ParameterSetName = 'index')]
        [ValidateSet('0','1')]
        [string]$showChildResellerDevices,

        [Parameter(ParameterSetName = 'indexByAsset', Mandatory = $true)]
        [switch]$asset,

        [Parameter(ParameterSetName = 'indexByVolume', Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$volumeName,

        [Parameter(ParameterSetName = 'indexByShare', Mandatory = $true)]
        [switch]$share,

        [Parameter(ParameterSetName = 'indexAgents', Mandatory = $true)]
        [switch]$allAgents,

        [Parameter(ParameterSetName = 'indexByDeviceAgents', Mandatory = $true)]
        [switch]$agents,

        [Parameter(ParameterSetName = 'indexByAlert', Mandatory = $true)]
        [switch]$alert,

        [Parameter(ParameterSetName = 'index')]
        [Parameter(ParameterSetName = 'indexByAsset')]
        [Parameter(ParameterSetName = 'indexByShare')]
        [Parameter(ParameterSetName = 'indexAgents')]
        [Parameter(ParameterSetName = 'indexByDeviceAgents')]
        [Parameter(ParameterSetName = 'indexByAlert')]
        [ValidateRange(1, [int]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(ParameterSetName = 'index')]
        [Parameter(ParameterSetName = 'indexByAsset')]
        [Parameter(ParameterSetName = 'indexByShare')]
        [Parameter(ParameterSetName = 'indexAgents')]
        [Parameter(ParameterSetName = 'indexByDeviceAgents')]
        [Parameter(ParameterSetName = 'indexByAlert')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$pageSize = 100
    )

    switch ($PSCmdlet.ParameterSetName) {
        'index'                 { $resource_uri = "/device" }
        'indexByDevice'         { $resource_uri = "/device/$serialNumber" }
        'indexByAsset'          { $resource_uri = "/device/$serialNumber/asset" }
        'indexByVolume'         { $resource_uri = "/device/$serialNumber/asset/$volumeName" }
        'indexByShare'          { $resource_uri = "/device/$serialNumber/asset/share" }
        'indexAgents'           { $resource_uri = "/agent" }
        'indexByDeviceAgents'   { $resource_uri = "/device/$serialNumber/asset/agent" }
        'indexByAlert'          { $resource_uri = "/device/$serialNumber/alert" }
    }

    $body = @{}

    # Unique Parameters
    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($showHiddenDevices) {
            $body += @{'showHiddenDevices' = $showHiddenDevices}
        }
        if ($showChildResellerDevices) {
            $body += @{'showChildResellerDevices' = $showChildResellerDevices}
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'indexByVolume') {

        if ($volumeName) {
            $body += @{'volumeName' = $volumeName}
        }
    }

    # Common parameters
    if (($PSCmdlet.ParameterSetName -eq 'indexByDevice') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByAsset') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByVolume') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByShare') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByDeviceAgents') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByAlert')) {

            if ($serialNumber) {
                $body += @{'serialNumber' = $serialNumber}
            }
    }

    if (($PSCmdlet.ParameterSetName -eq 'index') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByAsset') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByShare') -or
        ($PSCmdlet.ParameterSetName -eq 'indexAgents') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByDeviceAgents') -or
        ($PSCmdlet.ParameterSetName -eq 'indexByAlert')) {

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
