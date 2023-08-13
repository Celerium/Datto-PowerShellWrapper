function Get-DattoAPIKey {
<#
    .SYNOPSIS
        Gets the Datto API public & secret key global variables.

    .DESCRIPTION
        The Get-DattoAPIKey cmdlet gets the Datto API public & secret key
        global variables and returns them as an object.

    .PARAMETER plainText
        Decrypt and return the API key in plain text.

    .EXAMPLE
        Get-DattoAPIKey

        Gets the Datto API public & secret key global variables and returns them as an object
        with the secret key as a SecureString.

    .EXAMPLE
        Get-DattoAPIKey -plainText

        Gets the Datto API public & secret key global variables and returns them as an object
        with the secret key as plain text.


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [Switch]$plainText
    )

    begin {}

    process{

        try {

            if ($Datto_Secret_Key){

                if ($plainText){
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Datto_Secret_Key)

                    [PSCustomObject]@{
                        PublicKey = $Datto_Public_Key
                        SecretKey = ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                    }
                }
                else {
                    [PSCustomObject]@{
                        PublicKey = $Datto_Public_Key
                        SecretKey = $Datto_Secret_Key
                    }
                }

            }
            else { Write-Warning "The Datto API [ secret ] key is not set. Run Add-DattoAPIKey to set the API key." }

        }
        catch {
            Write-Error $_
        }
        finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }


    }

    end{}

}
