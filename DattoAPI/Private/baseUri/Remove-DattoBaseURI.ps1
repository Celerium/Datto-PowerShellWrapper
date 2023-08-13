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
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoBaseURI.html
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    switch ([bool]$Datto_Base_URI) {
        $true   { Remove-Variable -Name "Datto_Base_URI" -Scope global -Force }
        $false  { Write-Warning "The Datto base URI variable is not set. Nothing to remove" }
    }

}