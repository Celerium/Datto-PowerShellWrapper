function Get-DattoAgent {
<#
    .SYNOPSIS
        Get Datto BCDR agents from a given device

    .DESCRIPTION
        The Get-DattoAgent cmdlet get agents from a given BCDR device
        or for Endpoint Backup for PC agents (EB4PC)

        To get agents from the Datto BCDR the serialNumber of the BCDR
        needs to be defined.

        Endpoints:
        /bcdr/Agent
            Used for Endpoint Backup for PC agents (EB4PC)

        /bcdr/device/serialNumber/Asset/Agent
            Used for BCDR agents

    .PARAMETER serialNumber
        Defines the BCDR serial number to get agents from

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
        Get-DattoAgent

        Gets a list of Endpoint Backup for PC (EB4PC) clients and the agents
        under those clients.

    .EXAMPLE
        Get-DattoAgent -serialNumber "12345678"

        Returns the agents from the defined Datto BCDR

    .EXAMPLE
        Get-DattoAgent -serialNumber "12345678" -page 2 -perPage 10

        Returns the first 10 agents from page 2 from the defined Datto BCDR

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoAgent.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexByDevice')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [Parameter(Mandatory = $false, ParameterSetName = 'indexByDevice')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$page = 1,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [Parameter(Mandatory = $false, ParameterSetName = 'indexByDevice')]
        [ValidateRange(1, [Int64]::MaxValue)]
        [Int64]$perPage = 100,

        [Parameter( Mandatory = $false)]
        [Switch]$allPages
    )

    begin {

        switch ( [bool]$serialNumber ) {
            $true   { $resource_uri = "/bcdr/device/$serialNumber/asset/agent" }
            $false  { $resource_uri = "/bcdr/agent" }
        }

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters._page = 1 }
            else { $PSBoundParameters._page = $page }

            if( -not $PSBoundParameters.ContainsKey('perPage') ) { $PSBoundParameters._perPage = 100 }
            else { $PSBoundParameters._perPage = $perPage }

        Set-Variable -Name 'Datto_agentParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
