function Get-DattoAlert {
<#
    .SYNOPSIS
        Gets Datto BCDR alerts for a given device.

    .DESCRIPTION
        The Get-DattoAlert cmdlet gets Datto BCDR alerts for a given device.

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

        The parameter is mandatory

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
        Get-DattoAlert -serialNumber "12345678"

        Gets the Datto BCDR with the defined serialNumber and returns any alerts.

    .EXAMPLE
        Get-DattoAlert -serialNumber "12345678" -page 2 -pageSize 10

        Gets the Datto BCDR with the defined serialNumber
        with the first 10 alerts from the 2nd page of results.

    .NOTES
        PerPage always gets set to 100 regardless of value, appears this is not
        a valid parameter for this endpoint.

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false, ParameterSetName = 'index')]
        [Switch]$allPages
    )

    begin{

        $resource_uri = "/bcdr/device/$serialNumber/alert"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_alertParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
