function Get-DattoMetaData {
<#
    .SYNOPSIS
        Gets various Api metadata values

    .DESCRIPTION
        The Get-DattoMetaData cmdlet gets various Api metadata values from an
        Invoke-WebRequest to assist in various troubleshooting scenarios such
        as rate-limiting.

    .PARAMETER base_uri
        Define the base URI for the Datto API connection using Datto's URI or a custom URI.

        The default base URI is https://api.datto.com/v1

    .EXAMPLE
        Get-DattoMetaData

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The default full base uri test path is:
            https://api.datto.com/v1

    .EXAMPLE
        Get-DattoMetaData -base_uri http://myapi.gateway.example.com

        Gets various Api metadata values from an Invoke-WebRequest to assist
        in various troubleshooting scenarios such as rate-limiting.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/device

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Get-DattoMetaData.html
#>

    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$base_uri = $Datto_Base_URI
    )

    begin { $resource_uri = "/bcdr/agent" }

    process {

        try {

            $Api_Token = Get-DattoAPIKey -plainText
            $Api_Token_base64 = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( ("{0}:{1}" -f ($Api_Token).PublicKey,($Api_Token).SecretKey) ) )

            $Datto_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $Datto_Headers.Add("Content-Type", 'application/json')
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
            Remove-Variable -Name Datto_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                ResponseUri             = $data.BaseResponse.ResponseUri.AbsoluteUri
                ResponsePort            = $data.BaseResponse.ResponseUri.Port
                StatusCode              = $data.StatusCode
                StatusDescription       = $data.StatusDescription
                'Content-Type'          = $data.headers.'Content-Type'
                'X-Request-Id'          = $data.headers.'X-Request-Id'
                'X-API-Limit-Remaining' = $data.headers.'X-API-Limit-Remaining'
                'X-API-Limit-Resets'    = $data.headers.'X-API-Limit-Resets'
                'X-API-Limit-Cost'      = $data.headers.'X-API-Limit-Cost'
                raw                     = $data
            }
        }

    }

    end {}
}