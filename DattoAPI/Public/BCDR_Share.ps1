function Get-DattoShare {
<#
    .SYNOPSIS
        Gets Datto BCDR shares for a given device

    .DESCRIPTION
        The Get-DattoShare cmdlet gets Datto BCDR shares
        for a given device

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
        Get-DattoShare -serialNumber "12345678"

        Gets the Datto BCDR with the defined serialNumber and returns any shares.

    .EXAMPLE
        Get-DattoShare -serialNumber "12345678" -page 2 -pageSize 10

        Gets the Datto BCDR with the defined serialNumber
        with the first 10 shares from the 2nd page of results.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoShare.html
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

        $resource_uri = "/bcdr/device/$serialNumber/asset/share"

    }

    process{

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_assetShareParameters' -Value $PSBoundParameters -Scope Global -Force

        switch ($allPages) {
            $true   { Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages }
            $false  { Invoke-ApiRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters }
        }

    }

    end{}

}
