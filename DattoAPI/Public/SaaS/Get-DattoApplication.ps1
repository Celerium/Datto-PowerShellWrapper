function Get-DattoApplication {
<#
    .SYNOPSIS
        Get Datto SaaS protection backup data for a given customer

    .DESCRIPTION
        The Get-DattoApplication cmdlet gets Datto SaaS protection
        backup data for a given customer

    .PARAMETER saasCustomerId
        Defines the ID of the Datto SaaS organization

    .PARAMETER daysUntil
        Defines the number of days until the report should be generated
        
        By default '10' days is returned by the API.

    .PARAMETER includeRemoteID
        Defines if remote IDs are included in the return

        Note:
            0 = No
            1 = Yes

        Allowed Values:
            0, 1

    .EXAMPLE
        Get-DattoApplication -saasCustomerId "123456"

        Gets the Datto SaaS protection backup data from the define customer ID and
        does not include remote IDs

    .EXAMPLE
        Get-DattoApplication -saasCustomerId "123456" -includeRemoteID 1

        Gets the Datto SaaS protection backup data from the define customer ID and
        includes remote IDs

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoApplication.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$saasCustomerId,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$daysUntil,

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateSet( 0, 1 )]
        [int]$includeRemoteID
    )

    begin {

        $resource_uri = "/saas/$saasCustomerId/applications"

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_applicationParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}
}
