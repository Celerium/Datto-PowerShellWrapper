function Test-DattoAPIKey {
<#
    .SYNOPSIS
        Test the Datto API public & secret keys.

    .DESCRIPTION
        The Test-DattoAPIKey cmdlet tests the base URI & API public & secret keys that were defined in the
        Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the Datto API connection using Datto's URI or a custom URI.

        The default base URI is https://api.datto.com/v1/bcdr

    .EXAMPLE
        Test-DattoBaseURI

        Tests the base URI & API access token that was defined in the
        Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

        The default full base uri test path is:
            https://api.datto.com/v1/bcdr/device

    .EXAMPLE
        Test-DattoBaseURI -base_uri http://myapi.gateway.example.com

        Tests the base URI & API access token that was defined in the
        Add-DattoBaseURI & Add-DattoAPIKey cmdlets.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Test-DattoAPIKey.html
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline = $true)]
        [string]$base_uri = $Datto_Base_URI
    )

    $resource_uri = "/bcdr/agent"

    try {

        $Api_Token = Get-DattoAPIKey -plainText
        $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).PublicKey,($Api_Token).SecretKey) ) )

        $Datto_Headers.Add('Authorization', 'Basic {0}'-f $Api_Token_base64)

        $rest_output = Invoke-WebRequest -method Get -uri ($base_uri + $resource_uri) -headers $Datto_Headers -ErrorAction Stop
    }
    catch {

        [PSCustomObject]@{
            Method = $_.Exception.Response.Method
            StatusCode = $_.Exception.Response.StatusCode.value__
            StatusDescription = $_.Exception.Response.StatusDescription
            Message = $_.Exception.Message
            URI = $($Datto_Base_URI + $resource_uri)
        }

    }
    finally {
        [void] ( $Datto_Headers.Remove('Authorization') )
    }

    if ($rest_output){
        $data = @{}
        $data = $rest_output

        [PSCustomObject]@{
            StatusCode = $data.StatusCode
            StatusDescription = $data.StatusDescription
            URI = $($Datto_Base_URI + $resource_uri)
        }
    }
}
