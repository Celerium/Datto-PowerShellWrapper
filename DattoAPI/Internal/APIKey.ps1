function Add-DattoAPIKey {
<#
    .SYNOPSIS
        Sets the API public & secret keys used to authenticate all API calls.

    .DESCRIPTION
        The Add-DattoAPIKey cmdlet sets the API public & secret keys which are used to authenticate all API calls made to Datto.
        Once the API public & secret keys are defined by Add-DattoAPIKey, the secret key is encrypted using SecureString.

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
        public key & will prompt to enter in the secret key.

    .EXAMPLE
        '12345' | Add-DattoAPIKey

        The Datto API will use the string entered as the secret key & will prompt to enter in the public key.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://portal.dattobackup.com/integrations/xml
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
        $x_api_key = ConvertTo-SecureString $Api_Key_Secret -AsPlainText -Force

        Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_Secret_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
    else {
        Write-Output "Please enter your API secret key:"
        $x_api_key = Read-Host -AsSecureString

        Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_Secret_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
}

function Get-DattoAPIKey {
<#
    .SYNOPSIS
        Gets the Datto API public & secret key global variables.

    .DESCRIPTION
        The Get-DattoAPIKey cmdlet gets the Datto API public & secret key global variables and
        returns them as an object with the secret key as a SecureString.

    .PARAMETER Public_Only
        Only outputs the public key.

    .PARAMETER Secret_Only
        Only outputs the secret key.

    .EXAMPLE
        Get-DattoAPIKey

        Gets the Datto API public & secret key global variables and returns them as an object
        with the secret key as a SecureString.

    .EXAMPLE
        Get-DattoAPIKey -public_only

        Only outputs the public key.

    .EXAMPLE
        Get-DattoAPIKey -secret_only

        Only outputs the secret key as a SecureString.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://portal.dattobackup.com/integrations/xml
#>

    [cmdletbinding()]
    Param (
        [switch]$Public_Only,
        [switch]$Secret_Only
    )

    if (!$Public_Only -and !$Secret_Only) {
        if ($Datto_Public_Key -and $Datto_Secret_Key) {
            [PSCustomObject]@{
                PublicKey = $Datto_Public_Key
                SecretKey = $Datto_Secret_Key
            }
        }
        Else{
            Write-Warning "The Datto API keys are not set. Run Add-DattoAPIKey to set the API keys."
        }
    }

    if ($Public_Only) {
        if ($Datto_Public_Key){
            $Datto_Public_Key
        }
        Else{
            Write-Warning "The Datto API [ public ] key is not set. Run Add-DattoAPIKey to set the API key."
        }
    }

    if ($Secret_Only) {
        if ($Datto_Secret_Key){
            $Datto_Secret_Key
        }
        Else{
            Write-Warning "The Datto API [ secret ] key is not set. Run Add-DattoAPIKey to set the API key."
        }
    }

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
        https://github.com/Celerium/Datto-PowerShellWrapper
        https://portal.dattobackup.com/integrations/xml
#>

    [cmdletbinding()]
    Param ()

    if ($Datto_Public_Key) {
        Remove-Variable -Name "Datto_Public_Key" -Scope global -Force
    }
    Else{
        Write-Warning "The Datto API [ public ] key is not set. Nothing to remove"
    }

    if ($Datto_Secret_Key) {
        Remove-Variable -Name "Datto_Secret_Key" -Scope global -Force
    }
    Else{
        Write-Warning "The Datto API [ secret ] key is not set. Nothing to remove"
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
        https://portal.dattobackup.com/integrations/xml
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline = $true)]
        [string]$base_uri = $Datto_Base_URI
    )

    $resource_uri = "/device"

    try {
        if (!$Datto_Public_Key -or !$Datto_Secret_Key) {
            throw "The Datto API keys are not set. Run Add-DattoAPIKey to set the API keys."
        }

        $Datto_Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Datto_Public_Key, $Datto_Secret_Key
        $Credentials = Get-Credential $Datto_Credentials

        $rest_output = Invoke-WebRequest -method 'GET' -uri ($base_uri + $resource_uri) -headers $Datto_Headers -Credential $Credentials -ErrorAction Stop
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
    finally {}

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
