function Add-DattoBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the Datto API connection.

    .DESCRIPTION
        The Add-DattoBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the Datto API connection using Datto's URI or a custom URI.

    .PARAMETER data_center
        Datto's URI connection point that can be one of the predefined data centers.

        The accepted values for this parameter are:
        [ US ]
            US = https://api.datto.com/v1

        Placeholder for other data centers.

    .EXAMPLE
        Add-DattoBaseURI

        The base URI will use https://api.datto.com/v1 which is Datto's default URI.

    .EXAMPLE
        Add-DattoBaseURI -data_center US

        The base URI will use https://api.datto.com/v1 which is Datto's US URI.

    .EXAMPLE
        Add-DattoBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to Datto's API.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$base_uri = 'https://api.datto.com/v1',

        [ValidateSet( 'US' )]
        [String]$data_center
    )

    # Trim superfluous forward slash from address (if applicable)
    if ($base_uri[$base_uri.Length-1] -eq "/") {
        $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
    }

    switch ($data_center) {
        'US' { $base_uri = 'https://api.datto.com/v1' }
    }

    Set-Variable -Name "Datto_Base_URI" -Value $base_uri -Option ReadOnly -Scope global -Force
}



function Get-DattoBaseURI {
<#
    .SYNOPSIS
        Shows the Datto base URI global variable.

    .DESCRIPTION
        The Get-DattoBaseURI cmdlet shows the Datto base URI global variable value.

    .EXAMPLE
        Get-DattoBaseURI

        Shows the Datto base URI global variable value.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
#>

    [cmdletbinding()]
    Param ()

    switch ([bool]$Datto_Base_URI) {
        $true   { $Datto_Base_URI }
        $false  { Write-Warning "The Datto base URI is not set. Run Add-DattoBaseURI to set the base URI." }
    }

}



function Remove-DattoBaseURI {
<#
    .SYNOPSIS
        Removes the Datto base URI global variable.

    .DESCRIPTION
        The Remove-DattoBaseURI cmdlet removes the Datto base URI global variable.

    .EXAMPLE
        Remove-DattoBaseURI

        Removes the Datto base URI global variable.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    switch ([bool]$Datto_Base_URI) {
        $true   { Remove-Variable -Name "Datto_Base_URI" -Scope global -Force }
        $false  { Write-Warning "The Datto base URI variable is not set. Nothing to remove" }
    }

}

New-Alias -Name Set-DattoBaseURI -Value Add-DattoBaseURI