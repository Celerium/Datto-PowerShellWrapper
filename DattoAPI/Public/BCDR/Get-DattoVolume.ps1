function Get-DattoVolume {
<#
    .SYNOPSIS
        Gets an asset(s)(agent or share) for a specific volume on a device

    .DESCRIPTION
        The Get-DattoVolume cmdlet gets an asset(s)(agent or share)
        for a specific volume on a device

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

    .PARAMETER volumeName
        Defines the name (id) of the protected volume

        The content of the 'volume' field when calling /v1/bcdr/device/{serialNumber}/asset

    .EXAMPLE
        Get-DattoVolume -serialNumber "12345678" -volumeName "0987654321"

        Gets the Datto BCDR with the defined serialNumber and returns any
        agents or shares for the defined volume.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVolume.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber,

        [Parameter(Mandatory = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$volumeName
    )

    begin {

        $resource_uri = "/bcdr/device/$serialNumber/asset/$volumeName"

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_assetVolumeParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}

}
