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
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoAPIKey.html
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

    Begin{}

    Process{

        if ($Api_Key_Secret) {
            $x_api_key = ConvertTo-SecureString $Api_Key_Secret -AsPlainText -Force

            Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
            Set-Variable -Name "Datto_Secret_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
        }
        else {
            $x_api_key = Read-Host -Prompt 'Please enter your API key' -AsSecureString

            Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
            Set-Variable -Name "Datto_Secret_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
        }

    }

    End{}
}

New-Alias -Name Set-DattoAPIKey -Value Add-DattoAPIKey -Force
