function Add-DattoAPIKey {
<#
    .SYNOPSIS
        Sets the API public & secret keys used to authenticate API calls.

    .DESCRIPTION
        The Add-DattoAPIKey cmdlet sets the API public & secret keys which are used to
        authenticate all API calls made to Datto.

        Once the API public & secret keys are defined, the secret key is encrypted using SecureString.

        The Datto API public & secret keys are generated via the Datto portal at Admin > Integrations

    .PARAMETER Api_Key_Public
        Defines your API public key.

    .PARAMETER Api_Key_Secret
        Defines your API secret key.

    .EXAMPLE
        Add-DattoAPIKey

        Prompts to enter in the API public key and secret key.

    .EXAMPLE
        Add-DattoAPIKey -Api_Key_Public '12345'

        The Datto API will use the string entered into the [ -Api_Key_Public ] parameter as the
        public key & will then prompt to enter in the secret key.

    .EXAMPLE
        '12345' | Add-DattoAPIKey

        The Datto API will use the string entered as the secret key & will prompt to enter in the public key.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Api_Key_Public,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Api_Key_Secret
    )

    if ($Api_Key_Secret) {
        $x_api_key = ConvertTo-SecureString $Api_Key_Secret -AsplainText -Force

        Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_Secret_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
    else {
        $x_api_key = Read-Host -Prompt 'Please enter your API key' -AsSecureString

        Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_Secret_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
}



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
        https://github.com/Celerium/Datto-PowerShellWrapper
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
        https://portal.dattobackup.com/integrations/api
#>

    [cmdletbinding(SupportsShouldProcess)]
    Param ()

    switch ([bool]$Datto_Public_Key) {
        $true   { Remove-Variable -Name "Datto_Public_Key" -Scope global -Force }
        $false  { Write-Warning "The Datto API [ public ] key is not set. Nothing to remove" }
    }

    switch ([bool]$Datto_Secret_Key) {
        $true   { Remove-Variable -Name "Datto_Secret_Key" -Scope global -Force }
        $false  { Write-Warning "The Datto API [ secret ] key is not set. Nothing to remove" }
    }

}



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
        https://github.com/Celerium/Datto-PowerShellWrapper
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


New-Alias -Name Set-DattoAPIKey -Value Add-DattoAPIKey -Force
