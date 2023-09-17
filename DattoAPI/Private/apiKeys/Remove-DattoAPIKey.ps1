function Remove-DattoAPIKey {
<#
    .SYNOPSIS
        Removes the Datto API public & secret key global variables.

    .DESCRIPTION
        The Remove-DattoAPIKey cmdlet removes the Datto API public & secret key global variables.

    .EXAMPLE
        Remove-DattoAPIKey

        Removes the Datto API public & secret key global variables.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Remove-DattoAPIKey.html
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    begin {}

    process {

        switch ([bool]$Datto_Public_Key) {
            $true   { Remove-Variable -Name "Datto_Public_Key" -Scope global -Force }
            $false  { Write-Warning "The Datto API [ public ] key is not set. Nothing to remove" }
        }

        switch ([bool]$Datto_Secret_Key) {
            $true   { Remove-Variable -Name "Datto_Secret_Key" -Scope global -Force }
            $false  { Write-Warning "The Datto API [ secret ] key is not set. Nothing to remove" }
        }

    }

    end {}

}