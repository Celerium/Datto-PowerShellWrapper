function Get-DattoVMRestore {
<#
    .SYNOPSIS
        Gets Datto BCDR VM restores by serial number

    .DESCRIPTION
        The Get-DattoVMRestore cmdlet gets device VM restores
        by serial number

    .PARAMETER serialNumber
        Defines the BCDR serial number to get

    .EXAMPLE
        Get-DattoVMRestore -serialNumber 12345

        Gest Datto VM restores from the defined device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/BCDR/Get-DattoVMRestore.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'index')]
        [ValidateNotNullOrEmpty()]
        [string]$serialNumber
    )

    begin {

        $resource_uri = "/bcdr/device/$serialNumber/vm-restores"

    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_VMRestoreParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters

    }

    end {}

}
