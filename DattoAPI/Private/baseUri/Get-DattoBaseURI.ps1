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
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoBaseURI.html
#>

    [cmdletbinding()]
    Param ()

    switch ([bool]$Datto_Base_URI) {
        $true   { $Datto_Base_URI }
        $false  { Write-Warning "The Datto base URI is not set. Run Add-DattoBaseURI to set the base URI." }
    }

}