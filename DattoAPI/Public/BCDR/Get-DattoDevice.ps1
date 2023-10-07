function Get-DattoDevice {
<#
    .SYNOPSIS
        Gets Datto BCDR devices from the the Datto API.

    .DESCRIPTION
        The Get-DattoDevice cmdlet gets can get a one or more
        Datto BCDR devices.

        /bcdr/device - Returns all BCDR devices
        /bcdr/device/serialNumber - Returns a single BCDR device

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

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
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoDevice.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexByDevice')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateSet('0','1')]
        [string]$showHiddenDevices,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateSet('0','1')]
        [string]$showChildResellerDevices,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [Switch]$allPages
    )

    begin {

        switch ( [bool]$serialNumber ) {
            $true   { $resource_uri = "/bcdr/device/$serialNumber" }
            $false  { $resource_uri = "/bcdr/device" }
        }

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_deviceParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
