function Get-DattoBCDR {
<#
    .SYNOPSIS
        Gets Datto BCDR devices and assets

    .DESCRIPTION
        The Get-DattoBCDR cmdlet gets Datto BCDR devices and assets by combing all endpoints
        into a single command.

        This unique function does not contain any Reporting or SaaS endpoints. This function
        was added to simply testing & generating reports

    .PARAMETER endpoint_Agents
        Returns a list of BCDR clients and the agents under those clients

        As of 2022-04 this endpoint always returns no data

        Endpoint = /bcdr/agent

    .PARAMETER endpoint_Devices
        Returns a list of BCDR devices registered under your portal

        Endpoint = /bcdr/device

    .PARAMETER endpoint_byDevice
        Returns a single BCDR device registered under your portal

        Endpoint = /bcdr/device/{serialNumber}

    .PARAMETER endpoint_byDeviceAgent
        Returns a list BCDR agents from a given device

        Endpoint = /bcdr/device/{serialNumber}/asset/agent

    .PARAMETER endpoint_byDeviceAlert
        Returns a list BCDR alerts from a given device

        Endpoint = /bcdr/device/{serialNumber}/alert

    .PARAMETER endpoint_byDeviceAsset
        Returns a list BCDR agents & shares from a given device

        Endpoint = /bcdr/device/{serialNumber}/asset

    .PARAMETER endpoint_byDeviceShare
        Returns a list BCDR shares from a given device

        Endpoint = /bcdr/device/{serialNumber}/asset/share

    .PARAMETER endpoint_byDeviceVolume
        Returns a list BCDR volumes from a given device

        Endpoint = /bcdr/device/{serialNumber}/asset/volume

    .PARAMETER serialNumber
        Defines the BCDR serial number to get information from

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

    .PARAMETER volumeName
        Gets an asset(s)(agent or share) for a specific volume on a device

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
        Get-DattoBCDR

        Gets the first 100 Datto BCDR devices

        This function uses the -endpoint_Devices switch by default

    .EXAMPLE
        Get-DattoBCDR -endpoint_Agents -serialNumber '12345678'

        Returns a list of BCDR clients and the agents under those clients

        As of 2022-04 this endpoint always returns no data

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDevice -serialNumber '12345678'

        Returns a single BCDR device registered under your portal

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceAgent -serialNumber '12345678'

        Returns a list BCDR agents from a given device

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceAlert -serialNumber '12345678'

        Returns a list BCDR alerts from a given device

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceAsset -serialNumber '12345678'

        Returns a list BCDR agents & shares from a given device

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceShare -serialNumber '12345678'

        Returns a list BCDR shares from a given device

    .EXAMPLE
        Get-DattoBCDR -endpoint_byDeviceVolume -serialNumber '12345678'

        Returns a list BCDR volumes from a given device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoBCDR.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index_Devices')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'index_Agents')]
        [switch]$endpoint_Agents,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices')]
        [switch]$endpoint_Devices,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDevice')]
        [switch]$endpoint_byDevice,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceAgent')]
        [switch]$endpoint_byDeviceAgent,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceAlert')]
        [switch]$endpoint_byDeviceAlert,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceAsset')]
        [switch]$endpoint_byDeviceAsset,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceShare')]
        [switch]$endpoint_byDeviceShare,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceVolume')]
        [switch]$endpoint_byDeviceVolume,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDevice'        )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceAgent'   )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceAlert'   )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceAsset'   )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceShare'   )]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index_byDeviceVolume'  )]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices')]
        [ValidateSet('0','1')]
        [string]$showHiddenDevices,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices')]
        [ValidateSet('0','1')]
        [string]$showChildResellerDevices,

        [Parameter(Mandatory = $true, ParameterSetName = 'index_byDeviceVolume')]
        [ValidateNotNullOrEmpty()]
        [string]$volumeName,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Agents'            )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices'           )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAgent'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAlert'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAsset'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceShare'     )]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Agents'            )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices'           )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAgent'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAlert'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAsset'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceShare'     )]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter(Mandatory = $false, ParameterSetName = 'index_Agents'            )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_Devices'           )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAgent'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAlert'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceAsset'     )]
        [Parameter(Mandatory = $false, ParameterSetName = 'index_byDeviceShare'     )]
        [Switch]$allPages
    )

    begin{

        switch ($PSCmdlet.ParameterSetName) {
            'index_Agents'          { $resource_uri = "/bcdr/agent" }
            'index_Devices'         { $resource_uri = "/bcdr/device" }
            'index_byDevice'        { $resource_uri = "/bcdr/device/$serialNumber" }
            'index_byDeviceAgent'   { $resource_uri = "/bcdr/device/$serialNumber/asset/agent" }
            'index_byDeviceAlert'   { $resource_uri = "/bcdr/device/$serialNumber/alert" }
            'index_byDeviceAsset'   { $resource_uri = "/bcdr/device/$serialNumber/asset" }
            'index_byDeviceShare'   { $resource_uri = "/bcdr/device/$serialNumber/asset/share" }
            'index_byDeviceVolume'  { $resource_uri = "/bcdr/device/$serialNumber/asset/$volumeName" }
        }

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        if (($PSCmdlet.ParameterSetName -eq 'index_Agents') -or
            ($PSCmdlet.ParameterSetName -eq 'index_Devices') -or
            ($PSCmdlet.ParameterSetName -eq 'index_byDeviceAgent') -or
            ($PSCmdlet.ParameterSetName -eq 'index_byDeviceAlert') -or
            ($PSCmdlet.ParameterSetName -eq 'index_byDeviceAsset') -or
            ($PSCmdlet.ParameterSetName -eq 'index_byDeviceShare'))
        {

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }
        }

        Set-Variable -Name 'Datto_bcdrParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
